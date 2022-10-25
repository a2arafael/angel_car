import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:angel_car/global/model/holder.dart';
import 'package:angel_car/global/utils/app-alerts.dart';
import 'package:angel_car/global/utils/app-strings.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class AppDatabase {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///Buscando usuário no banco
  static Future getAuthUser({required String? uid}){
    return _firestore
        .collection(AppStrings.collectionAuthUsers)
        .doc(uid)
        .get();
  }

  static Future<DocumentSnapshot> getUser({required String? document}){
    return _firestore
        .collection(AppStrings.collectionUsers)
        .doc(document)
        .get();
  }

  static Stream<DocumentSnapshot> getUserStream({required String? document}){
    return _firestore
        .collection(AppStrings.collectionUsers)
        .doc(document)
        .snapshots();
  }

  static Stream<DocumentSnapshot> getScreenStream({required String? document}){
    return _firestore
        .collection(AppStrings.collectionScreens)
        .doc(document)
        .snapshots();
  }

  ///Criando usuário no banco
  static Future<bool> createAuthUser({required String authUid, required Map<String, Object?> data}) async {
    bool isSuccess = false;
    try {
      await _firestore
          .collection(AppStrings.collectionAuthUsers)
          .doc(authUid)
          .set(data)
          .then((value) {

          isSuccess = true;
      });
    } on FirebaseAuthException catch (e) {
      isSuccess = false;
      if (kDebugMode) {
        print('********* Novo erro: ${e.code}');
      }
      AppAlerts.snackbarError("Atenção",
          "Falha de conexão, verifique sua conexão ou tente novamente mais tarde!");
    } catch (e) {
      isSuccess = false;
      if (kDebugMode) {
        print("********* Catch App Auth Signin: $e");
      }
      AppAlerts.snackbarError("Atenção",
          "Falha de conexão, verifique sua conexão ou tente novamente mais tarde!");
    }
    return isSuccess;
  }

  static Future<bool> createUser({required String? document, required Map<String, Object?> data}) async {
    bool isSuccess = false;
    try {
      await _firestore
          .collection(AppStrings.collectionUsers)
          .doc(document)
          .set(data)
          .then((value) {
          isSuccess = true;
      });
    } on FirebaseAuthException catch (e) {
      isSuccess = false;
      if (kDebugMode) {
        print('********* Novo erro: ${e.code}');
      }
      AppAlerts.snackbarError("Atenção",
          "Falha de conexão, verifique sua conexão ou tente novamente mais tarde!");
    } catch (e) {
      isSuccess = false;
      if (kDebugMode) {
        print("********* Catch App Auth Signin: $e");
      }
      AppAlerts.snackbarError("Atenção",
          "Falha de conexão, verifique sua conexão ou tente novamente mais tarde!");
    }
    return isSuccess;
  }

  static Future<bool> createHolder({required Holder holder}) async {
    bool isSuccess = false;

    await OneSignal.shared.getDeviceState().then((value) async {
      holder.pushId = value?.userId;
      try {
        await _firestore
            .collection(AppStrings.collectionHolders)
            .doc(holder.document)
            .set(holder.toJson())
            .then((value) {
          isSuccess = true;
        });
      } on FirebaseAuthException catch (e) {
        isSuccess = false;
        if (kDebugMode) {
          print('********* Novo erro: ${e.code}');
        }
        AppAlerts.snackbarError("Atenção",
            "Falha de conexão, verifique sua conexão ou tente novamente mais tarde!");
      } catch (e) {
        isSuccess = false;
        if (kDebugMode) {
          print("********* Catch App Auth Signin: $e");
        }
        AppAlerts.snackbarError("Atenção",
            "Falha de conexão, verifique sua conexão ou tente novamente mais tarde!");
      }
    });

    return isSuccess;
  }

  ///Atualizando user no banco
  static Future updateUser(
      {required String? document, required Map<String, Object?> data}) {
    return _firestore
        .collection(AppStrings.collectionUsers)
        .doc(document)
        .update(data);
  }
  static Future updateAuthUser(
      {required String? uid, required Map<String, Object?> data}) {
    return _firestore
        .collection(AppStrings.collectionAuthUsers)
        .doc(uid)
        .update(data);
  }

  ///Deletando user do banco
  static Future deleteUser({required String? document}) {
    return _firestore
        .collection(AppStrings.collectionUsers)
        .doc(document)
        .delete();
  }
  static Future deleteAuthUser({required String? document}) {
    return _firestore
        .collection(AppStrings.collectionAuthUsers)
        .doc(document)
        .delete();
  }
}
