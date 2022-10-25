import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:angel_car/global/utils/app-alerts.dart';

class AppAuth{

  static final FirebaseAuth _auth = FirebaseAuth.instance ;

  static Stream<User?>  authState(){
    return _auth
        .userChanges();
  }

  static Future<String?> getUserUid() async{
    String uid = "";
      if(_auth.currentUser != null){
        uid = _auth.currentUser!.uid;
      }
      return uid;
  }

  static Future<User?> signUp(String? email, String? password, String? name) async{
    User? user;
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email ?? "",
          password: password ?? ""
      ).then((value) {
        _auth.currentUser?.updateDisplayName(name);
        user = value.user;
      });
    } on FirebaseAuthException catch (e) {
      user = null;
      if (e.code == 'weak-password') {
        if (kDebugMode) {
          print('********* A senha fornecida é muito fraca.');
        }
        AppAlerts.snackbarError("Atenção", "A senha fornecida é muito fraca.");
      } else if (e.code == 'email-already-in-use') {
        if (kDebugMode) {
          print('********* A conta já existe para esse e-mail.');
        }
        AppAlerts.snackbarError("Atenção", "E-mail já cadastrado, forneça um e-mail diferente deste, se o erro persistir entre em contato com a central.");
      }else{
        if (kDebugMode) {
          print('********* Novo erro: ${e.code}');
        }
        AppAlerts.snackbarError("Atenção", "Falha de conexão, verifique sua conexão ou tente novamente mais tarde! Se o erro persistir entre em contato com a central.");
      }
    } catch (e) {
      user = null;
      if (kDebugMode) {
        print("********* Catch App Auth Signin: $e");
      }
      AppAlerts.snackbarError("Atenção", "Falha de conexão, verifique sua conexão ou tente novamente mais tarde! Se o erro persistir entre em contato com a central.");
    }
    return user;
  }

  static Future<User?> signIn(String email, String password, loaderOverlay) async{
    User? user;
    try {
      await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      ).then((value) {
        user = value.user;
      });
    } on FirebaseAuthException catch (e) {
      loaderOverlay.hide();
      if (e.code == 'user-not-found') {
        AppAlerts.snackbarError('Atenção', 'Usuário não cadastrado.');
      } else if (e.code == 'wrong-password') {
        AppAlerts.snackbarError('Atenção', 'E-mail ou senha incorretos.');
      } else {
        if (kDebugMode) {
          print('********* SignIn erro novo: ${e.code}');
        }
      }
    }

    return user;
  }

  static void signOut(){
    _auth.signOut();

    // Get.offAll(() => WelcomeScreen());
  }

  //Função para login Apple
  static String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  //Função para login Apple
  static String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<bool> forgotPassword(String email, loaderOverlay) async{
    bool isSuccess = false;
    try {
      await _auth.sendPasswordResetEmail(email: email).then((value) {
        if (kDebugMode) {
          print('********* Sucesso Forgot Password');
        }
        isSuccess = true;
      });
    } on FirebaseAuthException catch (e) {
      loaderOverlay.hide();
      if(e.code == "user-not-found"){
        AppAlerts.snackbarError("Atenção", "E-mail não cadastrado.");
      }
      if (kDebugMode) {
        print('********* Firebase Auth Exception Forgot Password: ${e.code}');
      }
    } catch (e) {
      loaderOverlay.hide();
      if (kDebugMode) {
        print("********* Catch Forgot Password: $e");
      }
      AppAlerts.snackbarError("Atenção", "Falha de conexão, verifique sua conexão ou tente novamente mais tarde!");
      isSuccess = false;
    }
    return isSuccess;
  }
}