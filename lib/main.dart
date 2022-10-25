import 'dart:async';

import 'package:angel_car/global/conexa/conexa_repository.dart';
import 'package:angel_car/global/conexa/request/user_registration_request.dart';
import 'package:angel_car/global/conexa/response/holder_response.dart';
import 'package:angel_car/global/conexa/response/user_registration_response.dart';
import 'package:angel_car/global/firebase/app_auth.dart';
import 'package:angel_car/global/firebase/app_database.dart';
import 'package:angel_car/global/model/dependent.dart';
import 'package:angel_car/global/model/holder.dart';
import 'package:angel_car/global/utils/app-alerts.dart';
import 'package:angel_car/global/utils/app-colors.dart';
import 'package:angel_car/global/utils/app-strings.dart';
import 'package:angel_car/global/utils/app-utils.dart';
import 'package:angel_car/global/vindi/vindi_view_model.dart';
import 'package:angel_car/ui/home/home_screen.dart';
import 'package:angel_car/ui/welcome/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  initOneSignal();
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    nextScreen(const WelcomeScreen());
  } else {
    FirebaseFirestore.instance
        .collection(AppStrings.collectionAuthUsers)
        .doc(user.uid)
        .get()
        .then((value) {
      if (value.exists) {
        var holderDocument = AppUtils.unmaskDocument(value['holder_document']);
        var document = AppUtils.unmaskDocument(value['document']);
        var holderKeraDB = Holder();
        var dependent = Dependent();
        VindiViewModel.holderActive(cpf: holderDocument).then((holderActive) {
          if (holderActive) {
            VindiViewModel.getHolder(cpf: holderDocument).then((holder) {
              if (holder != null) {
                holder = holder;
                VindiViewModel.isHolder(cpf: document).then((isHolder) {
                  if (isHolder) {
                    AppDatabase.getUser(document: holderDocument)
                        .then((holderValue) {
                      Map<String, dynamic> map =
                      holderValue.data() as Map<String, dynamic>;
                      holderKeraDB = Holder.fromJson(map);
                      checkHolderData(
                          holderVindi: holder,
                          userData: holderKeraDB,
                          cpf: holderDocument);
                    });
                  } else {
                    AppDatabase.getUser(document: document)
                        .then((dependentValue) {
                      Map<String, dynamic> map =
                      dependentValue.data() as Map<String, dynamic>;
                      dependent = Dependent.fromJson(map);
                      checkDependentData(
                          holderVindi: holder,
                          userData: dependent,
                          cpf: document);
                    });
                  }
                });
              }
            });
          } else {
            nextScreen(const WelcomeScreen());
          }
        });
      } else {
        nextScreen(const WelcomeScreen());
      }
    });
  }
}

void nextScreen(screen) {
  runZonedGuarded(() {
    runApp(
      GetMaterialApp(
          theme: ThemeData(
            primaryColor: AppColors.primary,
          ),
          debugShowCheckedModeBanner: false,
          home: screen),
    );
  }, FirebaseCrashlytics.instance.recordError);
}

void initOneSignal() async {
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  await OneSignal.shared.setAppId(AppStrings.oneSignalAppId);
  OneSignal.shared.setRequiresUserPrivacyConsent(true);
  await OneSignal.shared
      .promptUserForPushNotificationPermission(fallbackToSettings: true);
  OneSignal.shared.disablePush(false);
  OneSignal.shared.consentGranted(true);
}

void checkDependentData(
    {required Holder? holderVindi,
      required Dependent? userData,
      required String? cpf}) {
  var document = AppUtils.unmaskDocument(userData?.document);
  var name = userData?.name;
  var dateBirthday = userData?.dateBirthday;
  var conexaId = userData?.conexaId;
  var dependents = holderVindi?.dependents;
  Dependent? documentExists = dependents?.singleWhere(
          (element) => element?.document == document,
      orElse: () => Dependent());
  Dependent? nameExists = dependents?.singleWhere(
          (element) => element?.name == name,
      orElse: () => Dependent());
  Dependent? dateBirthdayExists = dependents?.singleWhere(
          (element) => element?.dateBirthday == dateBirthday,
      orElse: () => Dependent());
  if (documentExists?.document != null ||
      nameExists?.name != null ||
      dateBirthdayExists?.dateBirthday != null) {
    holderVindi?.dependents?.forEach((element) {
      if (element?.document == document ||
          element?.name == name ||
          element?.dateBirthday == dateBirthday) {
        if (element?.name != userData?.name) {
          userData?.name = element?.name;
        }
        if (element?.document != userData?.document) {
          userData?.document = element?.document;
        }
        if (element?.dateBirthday != userData?.dateBirthday) {
          userData?.dateBirthday = element?.dateBirthday;
        }
      }
    });
    AppDatabase.deleteUser(document: cpf).then((value) {
      if(conexaId != null){
        UserRegistrationRequest request = UserRegistrationRequest(
          holder: HolderResponse(
            sex: userData?.sex,
            name: userData?.name,
            mail: userData?.email,
            dateBirth: userData?.dateBirthday,
            cpf: AppUtils.unmaskDocument(userData?.document),
            cellphone: AppUtils.unmaskPhone(userData?.cellphone),
          ),
        );
        ConexaRepository().createOrUpdatePatient(request).then((value) {
          UserRegistrationResponse response =
          UserRegistrationResponse.fromJson(value.data);
          userData?.conexaId = response.object?.holder?.id;
        });
      }
      AppDatabase.createUser(
          document: AppUtils.unmaskDocument(userData?.document), data: userData!.toJson())
          .then((value) {
        AppDatabase.updateAuthUser(uid: userData.authUid, data: {
          'holder_document': userData.holderDocument,
          'name': userData.name,
          'conexa_id': userData.conexaId,
          'document': userData.document
        }).then((value) {
          GetStorage().write(AppStrings.keyUserName, userData.name);
          GetStorage().write(AppStrings.keyConexaId, userData.conexaId);
          nextScreen(const HomeScreen());
        });
      });
    });
  } else {
    AppDatabase.deleteAuthUser(document: AppUtils.unmaskDocument(cpf))
        .then((value) {
      AppDatabase.deleteUser(document: AppUtils.unmaskDocument(cpf))
          .whenComplete(() {
        if (conexaId != null) {
          ConexaRepository().inactivatePatient(conexaId);
          ConexaRepository().blockPatient(conexaId);
        }
        var user = FirebaseAuth.instance.currentUser;
        String email = userData!.email!;
        String password = 'AppKeraDeleteAccount';
        AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: password);
        user?.reauthenticateWithCredential(credential);
        user?.delete();
        AppAuth.signOut();
        nextScreen(const WelcomeScreen());
        AppAlerts.snackbarError("Atenção",
            "Encontramos divergências em seu cadastro. Entre em contato para mais informações.");
      });
    });
  }
}

void checkHolderData(
    {required Holder? holderVindi,
      required Holder? userData,
      required String? cpf}) {
  var document = AppUtils.unmaskDocument(userData?.document);
  var name = userData?.name;
  var dateBirthday = userData?.dateBirthday;
  var email = userData?.email;
  var cellphone = AppUtils.unmaskPhone(userData?.cellphone);
  var conexaId = userData?.conexaId;
  var dependentsVindi = holderVindi?.dependents;
  var dependentsDB = userData?.dependents;
  User? user = FirebaseAuth.instance.currentUser;
  if (holderVindi?.document != document) {
    userData?.document = holderVindi?.document;
  }
  if (holderVindi?.name != name) userData?.name = holderVindi?.name;
  if (holderVindi?.dateBirthday != dateBirthday) {
    userData?.dateBirthday = holderVindi?.dateBirthday;
  }
  if (holderVindi?.cellphone != cellphone) {
    userData?.cellphone = holderVindi?.cellphone;
  }
  if (holderVindi?.email != email) {
    assert(holderVindi?.email != null);
    String email = userData!.email!;
    String password = 'AppKeraNewEmail';
    AuthCredential credential =
    EmailAuthProvider.credential(email: email, password: password);
    user?.reauthenticateWithCredential(credential);
    user?.updateEmail(holderVindi!.email!);
    user?.reload();
    userData.email = holderVindi?.email;
  }
  Dependent? dependent01, dependent02, dependent03, dependent04, dependent05;
  List<Dependent?>? depsDB = [];
  if (dependentsVindi != null && dependentsVindi.isNotEmpty) {
    if (dependentsVindi.isNotEmpty) {
      dependent01 = dependentsVindi[0];
      Dependent? dependent01NameExists;
      var dependent01document = dependent01?.document ?? "";
      var dependent01name = dependent01?.name ?? "";
      var dependent01DateBirthday = dependent01?.dateBirthday ?? "";
      dependent01NameExists = dependentsDB?.singleWhere(
              (element) => element?.name == dependent01name,
          orElse: () => Dependent());
      if (dependent01NameExists?.name != null) {
        dependentsDB?.forEach((element) {
          if (element?.name == dependent01name ||
              element?.document == dependent01document ||
              element?.dateBirthday == dependent01DateBirthday) {
            if (element?.name != dependent01name) {
              element?.name = dependent01?.name;
            }
            if (element?.document != dependent01document) {
              element?.document = dependent01?.document;
            }
            if (element?.dateBirthday != dependent01DateBirthday) {
              element?.dateBirthday = dependent01?.dateBirthday;
            }
            if (!depsDB.contains(element)) {
              depsDB.add(element);
            }
          }
        });
      } else if (!depsDB.contains(dependent01)) {
        depsDB.add(dependent01);
      }
    }
    if (dependentsVindi.length >= 2) {
      dependent02 = dependentsVindi[1];
      Dependent? dependent02NameExists;
      var dependent02document = dependent02?.document ?? "";
      var dependent02name = dependent02?.name ?? "";
      var dependent02DateBirthday = dependent02?.dateBirthday ?? "";
      dependent02NameExists = dependentsDB?.singleWhere(
              (element) => element?.name == dependent02name,
          orElse: () => Dependent());
      if (dependent02NameExists?.name != null) {
        dependentsDB?.forEach((element) {
          if (element?.name == dependent02name ||
              element?.document == dependent02document ||
              element?.dateBirthday == dependent02DateBirthday) {
            if (element?.name != dependent02name) {
              element?.name = dependent02?.name;
            }
            if (element?.document != dependent02document) {
              element?.document = dependent02?.document;
            }
            if (element?.dateBirthday != dependent02DateBirthday) {
              element?.dateBirthday = dependent02?.dateBirthday;
            }
            if (!depsDB.contains(element)) {
              depsDB.add(element);
            }
          }
        });
      } else if (!depsDB.contains(dependent02)) {
        depsDB.add(dependent02);
      }
    }
    if (dependentsVindi.length >= 3) {
      dependent03 = dependentsVindi[2];
      Dependent? dependent03NameExists;
      var dependent03document = dependent03?.document ?? "";
      var dependent03name = dependent03?.name ?? "";
      var dependent03DateBirthday = dependent03?.dateBirthday ?? "";
      dependent03NameExists = dependentsDB?.singleWhere(
              (element) => element?.name == dependent03name,
          orElse: () => Dependent());
      if (dependent03NameExists?.name != null) {
        dependentsDB?.forEach((element) {
          if (element?.name == dependent03name ||
              element?.document == dependent03document ||
              element?.dateBirthday == dependent03DateBirthday) {
            if (element?.name != dependent03name) {
              element?.name = dependent03?.name;
            }
            if (element?.document != dependent03document) {
              element?.document = dependent03?.document;
            }
            if (element?.dateBirthday != dependent03DateBirthday) {
              element?.dateBirthday = dependent03?.dateBirthday;
            }
            if (!depsDB.contains(element)) {
              depsDB.add(element);
            }
          }
        });
      } else if (!depsDB.contains(dependent03)) {
        depsDB.add(dependent03);
      }
    }
    if (dependentsVindi.length >= 4) {
      dependent04 = dependentsVindi[3];
      Dependent? dependent04NameExists;
      var dependent04document = dependent04?.document ?? "";
      var dependent04name = dependent04?.name ?? "";
      var dependent04DateBirthday = dependent04?.dateBirthday ?? "";
      dependent04NameExists = dependentsDB?.singleWhere(
              (element) => element?.name == dependent04name,
          orElse: () => Dependent());
      if (dependent04NameExists?.name != null) {
        dependentsDB?.forEach((element) {
          if (element?.name == dependent04name ||
              element?.document == dependent04document ||
              element?.dateBirthday == dependent04DateBirthday) {
            if (element?.name != dependent04name) {
              element?.name = dependent04?.name;
            }
            if (element?.document != dependent04document) {
              element?.document = dependent04?.document;
            }
            if (element?.dateBirthday != dependent04DateBirthday) {
              element?.dateBirthday = dependent04?.dateBirthday;
            }
            if (!depsDB.contains(element)) {
              depsDB.add(element);
            }
          }
        });
      } else if (!depsDB.contains(dependent04)) {
        depsDB.add(dependent04);
      }
    }
    if (dependentsVindi.length >= 5) {
      dependent05 = dependentsVindi[4];
      Dependent? dependent05NameExists;
      var dependent05document = dependent05?.document ?? "";
      var dependent05name = dependent05?.name ?? "";
      var dependent05DateBirthday = dependent05?.dateBirthday ?? "";
      dependent05NameExists = dependentsDB?.singleWhere(
              (element) => element?.name == dependent05name,
          orElse: () => Dependent());
      if (dependent05NameExists?.name != null) {
        dependentsDB?.forEach((element) {
          if (element?.name == dependent05name ||
              element?.document == dependent05document ||
              element?.dateBirthday == dependent05DateBirthday) {
            if (element?.name != dependent05name) {
              element?.name = dependent05?.name;
            }
            if (element?.document != dependent05document) {
              element?.document = dependent05?.document;
            }
            if (element?.dateBirthday != dependent05DateBirthday) {
              element?.dateBirthday = dependent05?.dateBirthday;
            }
            if (!depsDB.contains(element)) {
              depsDB.add(element);
            }
          }
        });
      } else if (!depsDB.contains(dependent05)) {
        depsDB.add(dependent05);
      }
    }
  }

  userData?.dependents = depsDB;

  AppDatabase.deleteUser(document: cpf).then((value) {
    if(conexaId != null){
      UserRegistrationRequest request = UserRegistrationRequest(
        holder: HolderResponse(
          sex: userData?.sex,
          name: userData?.name,
          mail: userData?.email,
          dateBirth: userData?.dateBirthday,
          cpf: AppUtils.unmaskDocument(userData?.document),
          cellphone: AppUtils.unmaskPhone(userData?.cellphone),
        ),
      );
      ConexaRepository().createOrUpdatePatient(request).then((value) {
        UserRegistrationResponse response =
        UserRegistrationResponse.fromJson(value.data);
        userData?.conexaId = response.object?.holder?.id;
      });
    }
    AppDatabase.createUser(
        document: AppUtils.unmaskDocument(userData?.document),
        data: userData!.toJson())
        .then((value) {
      AppDatabase.updateAuthUser(uid: userData.authUid, data: {
        'holder_document': userData.document,
        'name': userData.name,
        'conexa_id': userData.conexaId,
        'document': userData.document
      }).then((value) {
        GetStorage().write(AppStrings.keyUserName, userData.name);
        GetStorage().write(AppStrings.keyConexaId, userData.conexaId);
        nextScreen(const HomeScreen());
      });
    });
  });
}
