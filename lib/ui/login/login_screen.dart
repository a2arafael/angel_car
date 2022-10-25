import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
import 'package:angel_car/global/utils/app-text-styles.dart';
import 'package:angel_car/global/utils/app-utils.dart';
import 'package:angel_car/global/vindi/vindi_view_model.dart';
import 'package:angel_car/global/widgets/app_bar_initial.dart';
import 'package:angel_car/global/widgets/button_solid.dart';
import 'package:angel_car/global/widgets/button_text_underline.dart';
import 'package:angel_car/global/widgets/input.dart';
import 'package:angel_car/ui/forgot_password/forgot_password_screen.dart';
import 'package:angel_car/ui/home/home_screen.dart';
import 'package:angel_car/ui/signup/signup_screen.dart';
import 'package:angel_car/ui/webview/web_view_screen.dart';
import 'package:loader_overlay/loader_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isIOS = GetPlatform.isIOS;
  double screenHeight = Get.height;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  var holder = Holder();
  var dependent = Dependent();
  var holderKeraDB = Holder();

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayOpacity: 0.7,
      overlayColor: AppColors.black,
      useDefaultLoading: false,
      overlayWidget: const Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: appBarInitial('ENTRAR EM MINHA CONTA', screenHeight)),
        body: SingleChildScrollView(
          child: Padding(
            padding: screenHeight > 650.0
                ? const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0)
                : const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidate,
              child: Column(
                children: [
                  ///E-mail
                  Input(
                    hint: 'E-mail',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return "Campo obrigatório!";
                      } else if (value != null && !GetUtils.isEmail(value)) {
                        return "E-mail inválido!";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),

                  ///Senha
                  Input(
                    hint: 'Senha',
                    maxLength: 10,
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return "Campo obrigatório!";
                      } else {
                        return null;
                      }
                    },
                  ),

                  ///Esqueci a senha
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.to(const ForgotPasswordScreen());
                      },
                      child: Text(
                        'Esqueceu a senha?',
                        style: AppTextStyles.robotoRegular(
                            color: AppColors.grayLight, size: 16.0),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),

                  ///Botão entrar
                  buttonSolid(
                      text: 'Entrar',
                      onPressed: () {
                        signIn(emailController.text, passwordController.text);
                      }),
                  const SizedBox(
                    height: 16.0,
                  ),

                  ///Texto 2
                  buttonTextUnderline(
                      text: 'Seus dados estão seguros, conheça nossa',
                      textUnderline: 'Política de Privacidade',
                      onPressed: () => Get.to(() => const WebViewScreen(
                            title: 'Política de Privacidade',
                            url: 'https://kera.app.br/politica-privacidade-app',
                          ))),

                  ///Espaçamento
                  isIOS
                      ? //TODO: Vericicar tamanho de tela da Apple
                      //Apple
                      screenHeight > 650
                          ? SizedBox(
                              height: Get.context!.height * 0.17,
                            )
                          : SizedBox(
                              height: Get.context!.height * 0.08,
                            )
                      :
                      //Google
                      screenHeight > 650
                          ? SizedBox(
                              height: Get.context!.height * 0.35,
                            )
                          : SizedBox(
                              height: Get.context!.height * 0.05,
                            ),

                  ///Texto 3
                  buttonTextUnderline(
                      text: 'Ainda não tenho uma conta?',
                      textUnderline: 'Clique aqui',
                      onPressed: () => Get.off(() => const SignupScreen())),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signIn(String email, String password) {
    AppUtils.hideKeyboard(context: context);
    context.loaderOverlay.show();
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      AppAuth.signIn(email, password, context.loaderOverlay).then((user) {
        if (user != null) {
          AppDatabase.getAuthUser(uid: user.uid).then((authUserDB) {
            if (authUserDB.exists && authUserDB['holder_document'] != null) {
              VindiViewModel.holderActive(
                      cpf: AppUtils.unmaskDocument(
                          authUserDB['holder_document']))
                  .then((value) {
                if (value) {
                  AppDatabase.getUser(
                          document: AppUtils.unmaskDocument(
                              authUserDB['document']))
                      .then((userDB) {
                    VindiViewModel.getHolder(cpf: AppUtils.unmaskDocument(
                        authUserDB['holder_document'])).then((holder) {
                      if (holder != null) {
                        holder = holder;
                        var holderDocument = AppUtils.unmaskDocument(authUserDB['holder_document']);
                        var document = AppUtils.unmaskDocument(authUserDB['document']);
                        if(userDB['is_holder'] == true){
                          Map<String, dynamic> map =
                          userDB.data() as Map<String, dynamic>;
                          holderKeraDB = Holder.fromJson(map);
                          checkHolderData(
                              holderVindi: holder,
                              userData: holderKeraDB,
                              cpf: holderDocument);
                        }else{
                          Map<String, dynamic> map =
                          userDB.data() as Map<String, dynamic>;
                          dependent = Dependent.fromJson(map);
                          checkDependentData(
                            userData: dependent,
                            holderVindi: holder,
                            cpf: document
                          );
                        }
                      }
                    });
                  });
                } else {
                  AppDatabase.updateAuthUser(
                      uid: user.uid, data: {'status': 'inativo'}).then((value) {
                    AppDatabase.updateUser(
                        document: authUserDB['holder_document'],
                        data: {'status': 'inativo'}).then((value) {
                      AppDatabase.updateUser(
                          document: authUserDB['document'],
                          data: {'status': 'inativo'}).then((value) {

                        if (authUserDB['conexa_id'] != null) {
                          ConexaRepository()
                              .blockPatient(authUserDB['conexa_id'])
                              .then((value) {
                            messageError(
                                message:
                                'Encontramos divergências em seu contrato. Entre em contato para mais informações.');
                          });
                        } else {
                          messageError(
                              message:
                              'Encontramos divergências em seu contrato. Entre em contato para mais informações.');
                        }
                      });
                    });
                  });
                }
              });
            } else {
              messageError(
                  message:
                      'Encontramos divergências em seu contrato. Entre em contato para mais informações.');
            }
          });
        }
      });
    } else {
      setState(() {
        context.loaderOverlay.hide();
        _autoValidate = AutovalidateMode.always;
      });
    }
  }

  void messageError({required String message}) {
    AppAuth.signOut();
    context.loaderOverlay.hide();
    AppAlerts.snackbarError("Atenção", message);
  }

  void checkDependentData(
      {required Holder holderVindi,
        required Dependent userData,
        required String cpf}) {
    var document = AppUtils.unmaskDocument(userData.document);
    var name = userData.name;
    var dateBirthday = userData.dateBirthday;
    var conexaId = userData.conexaId;
    var dependents = holderVindi.dependents;
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
      holderVindi.dependents?.forEach((element) {
        if (element?.document == document ||
            element?.name == name ||
            element?.dateBirthday == dateBirthday) {
          if (element?.name != userData.name) {
            userData.name = element?.name;
          }
          if (element?.document != userData.document) {
            userData.document = element?.document;
          }
          if (element?.dateBirthday != userData.dateBirthday) {
            userData.dateBirthday = element?.dateBirthday;
          }
        }
      });
      AppDatabase.deleteUser(document: cpf).then((value) {
        if(conexaId != null){
          UserRegistrationRequest request = UserRegistrationRequest(
            holder: HolderResponse(
              sex: userData.sex,
              name: userData.name,
              mail: userData.email,
              dateBirth: userData.dateBirthday,
              cpf: AppUtils.unmaskDocument(userData.document),
              cellphone: AppUtils.unmaskPhone(userData.cellphone),
            ),
          );
          ConexaRepository().createOrUpdatePatient(request).then((value) {
            UserRegistrationResponse response =
            UserRegistrationResponse.fromJson(value.data);
            userData.conexaId = response.object?.holder?.id;
          });
        }
        AppDatabase.createUser(
            document: AppUtils.unmaskDocument(userData.document), data: userData.toJson())
            .then((value) {
          AppDatabase.updateAuthUser(uid: userData.authUid, data: {
            'holder_document': userData.holderDocument,
            'name': userData.name,
            'conexa_id': userData.conexaId,
            'document': userData.document
          }).then((value) {
            GetStorage().write(AppStrings.keyUserName, userData.name);
            GetStorage().write(AppStrings.keyConexaId, userData.conexaId);
            Get.offAll(() => const HomeScreen());
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
          String email = userData.email!;
          String password = 'AppKeraDeleteAccount';
          AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);
          user?.reauthenticateWithCredential(credential);
          user?.delete();
          AppAuth.signOut();
          Get.offAll(() => const LoginScreen());
          AppAlerts.snackbarError("Atenção",
              "Encontramos divergências em seu cadastro. Entre em contato para mais informações.");
        });
      });
    }
  }

  void checkHolderData(
      {required Holder holderVindi,
        required Holder userData,
        required String cpf}) {
    var document = AppUtils.unmaskDocument(userData.document);
    var name = userData.name;
    var dateBirthday = userData.dateBirthday;
    var email = userData.email;
    var cellphone = AppUtils.unmaskPhone(userData.cellphone);
    var conexaId = userData.conexaId;
    var dependentsVindi = holderVindi.dependents;
    var dependentsDB = userData.dependents;
    User? user = FirebaseAuth.instance.currentUser;
    if (holderVindi.document != document) {
      userData.document = holderVindi.document;
    }
    if (holderVindi.name != name) userData.name = holderVindi.name;
    if (holderVindi.dateBirthday != dateBirthday) {
      userData.dateBirthday = holderVindi.dateBirthday;
    }
    if (holderVindi.cellphone != cellphone) {
      userData.cellphone = holderVindi.cellphone;
    }
    if (holderVindi.email != email) {
      assert(holderVindi.email != null);
      String email = userData.email!;
      String password = 'AppKeraNewEmail';
      AuthCredential credential =
      EmailAuthProvider.credential(email: email, password: password);
      user?.reauthenticateWithCredential(credential);
      user?.updateEmail(holderVindi.email!);
      user?.reload();
      userData.email = holderVindi.email;
    }
    Dependent? dependent01, dependent02, dependent03, dependent04, dependent05;
    List<Dependent> depsDB = [];
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
                depsDB.add(element!);
              }
            }
          });
        } else if (!depsDB.contains(dependent01)) {
          depsDB.add(dependent01!);
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
                depsDB.add(element!);
              }
            }
          });
        } else if (!depsDB.contains(dependent02)) {
          depsDB.add(dependent02!);
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
                depsDB.add(element!);
              }
            }
          });
        } else if (!depsDB.contains(dependent03)) {
          depsDB.add(dependent03!);
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
                depsDB.add(element!);
              }
            }
          });
        } else if (!depsDB.contains(dependent04)) {
          depsDB.add(dependent04!);
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
                depsDB.add(element!);
              }
            }
          });
        } else if (!depsDB.contains(dependent05)) {
          depsDB.add(dependent05!);
        }
      }
    }

    userData.dependents = depsDB;

    AppDatabase.deleteUser(document: cpf).then((value) {
      if(conexaId != null){
        UserRegistrationRequest request = UserRegistrationRequest(
          holder: HolderResponse(
            sex: userData.sex,
            name: userData.name,
            mail: userData.email,
            dateBirth: userData.dateBirthday,
            cpf: AppUtils.unmaskDocument(userData.document),
            cellphone: AppUtils.unmaskPhone(userData.cellphone),
          ),
        );
        ConexaRepository().createOrUpdatePatient(request).then((value) {
          UserRegistrationResponse response =
          UserRegistrationResponse.fromJson(value.data);
          userData.conexaId = response.object?.holder?.id;
        });
      }
        AppDatabase.createUser(
            document: AppUtils.unmaskDocument(userData.document),
            data: userData.toJson())
            .then((value) {
          AppDatabase.updateAuthUser(uid: userData.authUid, data: {
            'holder_document': userData.document,
            'name': userData.name,
            'conexa_id': userData.conexaId,
            'document': userData.document
          }).then((value) {
            GetStorage().write(AppStrings.keyUserName, userData.name);
            GetStorage().write(AppStrings.keyConexaId, userData.conexaId);
            Get.offAll(() => const HomeScreen());
          });
        });
    });
  }
}
