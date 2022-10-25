import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
import 'package:angel_car/global/widgets/divider.dart';
import 'package:angel_car/global/widgets/input.dart';
import 'package:angel_car/ui/home/home_screen.dart';
import 'package:angel_car/ui/signup/widget/widget_signup.dart';
import 'package:loader_overlay/loader_overlay.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController documentController = TextEditingController();
  TextEditingController documentDependentController = TextEditingController();
  bool isIOS = GetPlatform.isIOS;
  bool _isVerification = false;
  bool _isDependents = false;
  bool _noDependents = false;
  bool _dependentSelected = false;
  double screenHeight = Get.height;
  static GetStorage storage = GetStorage();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  var _character = 'Titular';
  Holder holder = Holder();

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
            child: appBarInitial('CRIAR UMA CONTA', screenHeight)),
        body: SingleChildScrollView(
          child: Padding(
            padding:screenHeight > 650.0
                ? const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0)
                : const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///Titularidade
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0, bottom: 8.0),
                    child: Text(
                      'Titularidade',
                      style: AppTextStyles.robotoRegular(
                          color: AppColors.gray, size: 14.0),
                    ),
                  ),
                  Container(
                    height: 55.0,
                    decoration: const BoxDecoration(
                      color: AppColors.grayLight,
                      borderRadius: BorderRadius.all(Radius.circular(1000.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                       // Container(
                         // width: 140,
                          //child:
                          Expanded(
                            flex: 1,
                            child: RadioListTile<String>(

                              activeColor: AppColors.white,
                              contentPadding: const EdgeInsets.only(left: 0.0),
                              title: Text(
                                'Titular',
                                style: AppTextStyles.robotoRegular(
                                    color: AppColors.white, size: screenHeight > 650 ? 16.0 : 12.0),
                              ),
                              value: 'Titular',
                              groupValue: _character,
                              onChanged: (value) {
                                setState(() {
                                  if (value != null) {
                                    documentController.clear();
                                    _isVerification = false;
                                    _isDependents = false;
                                    _noDependents = false;
                                    _dependentSelected = false;
                                    _character = value;
                                  }
                                });
                              },
                            ),
                          ),
                       // ),
                       // Container(
                         // width: 130,
                          //child:
                          Expanded(
                            flex: 2,
                            child: RadioListTile<String>(
                              contentPadding: const EdgeInsets.only(left: 16.0),
                              activeColor: AppColors.white,
                              value: 'Dependente',
                              groupValue: _character,
                              title: Text(
                                'Dependente',
                                style: AppTextStyles.robotoRegular(
                                    color: AppColors.white, size: screenHeight > 650 ? 16.0 : 12.0),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  if (value != null) {
                                    documentController.clear();
                                    _isVerification = false;
                                    _character = value;
                                  }
                                });
                              },
                            ),
                          ),
                       // ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Input(
                    hint: 'CPF do titular do plano',
                    maxLength: 10,
                    controller: documentController,
                    keyboardType: GetPlatform.isIOS ? TextInputType.text : TextInputType.number,
                    textInputAction: TextInputAction.go,
                    onFieldSubmited: (value) {
                      validateHolder(
                          documentHolder: AppUtils.unmaskDocument(value));
                    },
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return "Campo obrigatório!";
                      } else if (value != null && !GetUtils.isCpf(value)) {
                        return "CPF inválido.";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),

                  _noDependents == true
                      ? Card(
                          shadowColor: AppColors.primary,
                          elevation: 5.0,
                          color: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Este titular não possui dependentes.',
                                  style: AppTextStyles.robotoMedium(
                                    color: AppColors.black,
                                    size: 19.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),

                  _noDependents == true
                      ? const SizedBox(
                          height: 16.0,
                        )
                      : Container(),

                  ///Lista de usuários
                  _isDependents == true
                      ? _dependentSelected == false
                          ? Column(
                              children: [
                                const SizedBox(
                                  height: 16.0,
                                ),

                                ///Título
                                Text(
                                  'Selecione um dependente.',
                                  style: AppTextStyles.robotoLight(
                                    size: screenHeight > 650.0 ? 22.0: 18.0,
                                    color: AppColors.gray,
                                  ),
                                ),
                                divider(AppColors.gray),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: holder.dependents?.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _dependentSelected = true;
                                          if(holder.dependents![index]?.name != null && holder.dependents![index]!.name!.isNotEmpty){
                                            nameController.text = holder.dependents![index]!.name!;
                                          }else{
                                            AppAlerts.snackbarError("Atenção",
                                                "Encontramos divergências em seu cadastro. Entre em contato com a central para mais informações.");
                                          }
                                          if(holder.dependents![index]!.document != null && holder.dependents![index]!.document!.isNotEmpty){
                                            documentDependentController.text = holder.dependents![index]!.document!;
                                          }else{
                                            AppAlerts.snackbarError("Atenção",
                                                "Encontramos divergências em seu cadastro. Entre em contato com a central para mais informações.");
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: Card(
                                          shadowColor: AppColors.primary,
                                          elevation: 5.0,
                                          color: AppColors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  holder.dependents?[index]!
                                                          .name ??
                                                      "",
                                                  style: AppTextStyles
                                                      .robotoMedium(
                                                    color: AppColors.black,
                                                    size: 19.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            )
                          : widgetSignup(
                              nameController: nameController,
                              confirmPasswordController:
                                  confirmPasswordController,
                              documentController: documentDependentController,
                              emailController: emailController,
                              passwordController: passwordController,
                              character: _character,
                              onPressed: () {
                                _character == 'Titular'
                                    ? signUpHolder(
                                        password: passwordController.text)
                                    : signUpDependent(
                                        password: passwordController.text);
                              },
                            )
                      : Container(),
                  _isDependents == true
                      ? const SizedBox(
                          height: 16.0,
                        )
                      : Container(),

                  _isVerification == true
                      ? widgetSignup(
                          nameController: nameController,
                          confirmPasswordController: confirmPasswordController,
                          documentController: documentDependentController,
                          emailController: emailController,
                          passwordController: passwordController,
                          character: _character,
                          onPressed: () {
                            _character == 'Titular'
                                ? signUpHolder(
                                    password: passwordController.text)
                                : signUpDependent(
                                    password: passwordController.text);
                          },
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUpDependent({required String password}) {
    context.loaderOverlay.show();
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.loaderOverlay.show();
      createDependent(password);
    } else {
      setState(() {
        context.loaderOverlay.hide();
        _autoValidate = AutovalidateMode.always;
      });
    }
  }

  void validateHolder({required String documentHolder}) {
    context.loaderOverlay.show();
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.loaderOverlay.show();
      VindiViewModel.holderActive(cpf: documentHolder).then((value) {
        if (value) {
          VindiViewModel.getHolder(cpf: documentHolder).then((hd) {
            if(hd != null){
              holder = hd;
              if (_character == 'Titular') {
                if(holder.name != null && holder.name!.isNotEmpty){
                  nameController.text = holder.name!;
                }else{
                  AppAlerts.snackbarError("Atenção",
                      "Encontramos divergências em seu cadastro. Entre em contato com a central para mais informações.");
                }
                if(holder.email != null && holder.email!.isNotEmpty){
                  emailController.text = holder.email!;
                }else{
                  AppAlerts.snackbarError("Atenção",
                      "Encontramos divergências em seu cadastro. Entre em contato com a central para mais informações.");
                }
                setState(() {
                  _isVerification = true;
                });
              }

              if (_character == 'Dependente') {
                if (holder.dependents != null &&
                    holder.dependents!.isNotEmpty) {
                  setState(() {
                    _isDependents = true;
                  });
                } else {
                  setState(() {
                    _noDependents = true;
                  });
                }
              }
              context.loaderOverlay.hide();
            }else{
              _isVerification = false;
              context.loaderOverlay.hide();
              AppAlerts.snackbarError("Atenção",
                  'Falha na conexão. Tente novamente  mais tarde. Se o erro persistir entre em contato.');
            }
          });
        } else {
          _isVerification = false;
          context.loaderOverlay.hide();
          AppAlerts.snackbarError("Atenção",
              "Encontramos divergências em seu contrato. Entre em contato para mais informações.");
        }
      });
    } else {
      setState(() {
        context.loaderOverlay.hide();
        _autoValidate = AutovalidateMode.always;
      });
    }
  }

  void signUpHolder({required String password}) {
    context.loaderOverlay.show();
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.loaderOverlay.show();
      AppDatabase.getUser(
              document: AppUtils.unmaskDocument(documentController.text))
          .then((value) {
        if (value.exists && value.data() != null) {
          Map<String, dynamic> map = value.data() as Map<String, dynamic>;
          if (map['auth_uid'] != null) {
            context.loaderOverlay.hide();
            AppAlerts.snackbarError('Atenção',
                'Usuário já cadastrado. Para mais informções entre em contato com a central.');
          } else {
            updateHolder(password);
          }
        } else {
          createHolder(password);
        }
      });
    } else {
      setState(() {
        context.loaderOverlay.hide();
        _autoValidate = AutovalidateMode.always;
      });
    }
  }

  void createHolder(String password) {
    AppAuth.signUp(emailController.text, password, nameController.text).then((user) {
      if (user != null) {
        AppDatabase.createAuthUser(authUid: user.uid, data: {
          'holder_document': documentController.text,
          'name': nameController.text,
          'conexa_id': null,
          'document': documentController.text
        }).then((value) {
          holder.authUid = user.uid;
          holder.status = 'ativo';
          holder.fullRegistration = false;
          holder.isHolder = true;
          holder.email = user.email;
          holder.document = documentController.text;
          holder.name = nameController.text;
          AppDatabase.createUser(
                  document: AppUtils.unmaskDocument(documentController.text),
                  data: holder.toJson())
              .then((value) {
            context.loaderOverlay.hide();
            storage.write(AppStrings.keyUserName, holder.name);
            storage.write(AppStrings.keyHolder, true);
            Get.off(() => const HomeScreen());
          });
        });
      } else {
        context.loaderOverlay.hide();
        // AppAlerts.snackbarError('Atenção',
        //     'Falha na conexão. Tente novamente  mais tarde. Se o erro persistir entre em contato.');
      }
    });
  }

  void updateHolder(String password) {
    AppAuth.signUp(emailController.text, password, nameController.text).then((user) {
      if (user != null) {
        holder.authUid = user.uid;
        holder.isHolder = true;
        AppDatabase.createAuthUser(authUid: user.uid, data: {
          'holder_document': documentController.text,
          'name': nameController.text,
          'conexa_id': null,
          'document': documentController.text
        }).then((value) {
          AppDatabase.updateUser(
                  document: AppUtils.unmaskDocument(documentController.text),
                  data: holder.toJson())
              .then((value) {
            context.loaderOverlay.hide();
            storage.write(AppStrings.keyUserName, holder.name);
            storage.write(AppStrings.keyHolder, true);
            Get.off(() => const HomeScreen());
          });
        });
      } else {
        context.loaderOverlay.hide();
        // AppAlerts.snackbarError('Atenção',
        //     'Falha na conexão. Tente novamente  mais tarde. Se o erro persistir entre em contato.');
      }
    });
  }

  void createDependent(String password) {
    AppAuth.signUp(emailController.text, password, nameController.text)
        .then((user) {
      if (user != null) {
        Dependent? dependent = Dependent();
        holder.dependents?.forEach((element) {
          if (element?.name == nameController.text) {
            element?.name = nameController.text;
            element?.document = documentDependentController.text;
            element?.email = emailController.text;
            element?.holderDocument = documentController.text;
            element?.authUid = user.uid;
            element?.fullRegistration = false;
            element?.isHolder = false;
            element?.status = 'ativo';
            dependent = element;
          }
        });

        AppDatabase.createAuthUser(authUid: user.uid, data: {
          'holder_document': documentController.text,
          'name': nameController.text,
          'conexa_id': null,
          'document': documentDependentController.text
        }).then((value) {
          AppDatabase.getUser(
              document: AppUtils.unmaskDocument(documentDependentController.text)
          ).then((dep) {
            if(dep.exists && dep.data() != null){
              Map<String, dynamic> map = dep.data() as Map<String, dynamic>;
              Dependent ddt = Dependent.fromJson(map);
              ddt.authUid = user.uid;
              ddt.email = user.email;
              AppDatabase.updateUser(
                  document: AppUtils.unmaskDocument(documentDependentController.text),
                  data: ddt.toJson()
              ).then((value) {
                getHolderWithDependent(dependent: dependent, holder: holder);
              });
            }else{
              AppDatabase.createUser(
                  document: AppUtils.unmaskDocument(documentDependentController.text),
                  data: dependent!.toJson()
              ).then((value) {
                getHolderWithDependent(dependent: dependent, holder: holder);
              });
            }
          });
        });
      } else {
        context.loaderOverlay.hide();
        // AppAlerts.snackbarError('Atenção',
        //     'Falha na conexão. Tente novamente  mais tarde. Se o erro persistir entre em contato.');
      }
    });
  }

  void getHolderWithDependent({required Dependent? dependent, required Holder? holder}){
    AppDatabase.getUser(
        document: AppUtils.unmaskDocument(documentController.text)
    ).then((value) {
      if(value.exists && value.data() != null){
        Map<String, dynamic> map = value.data() as Map<String, dynamic>;
        Holder hlr = Holder.fromJson(map);
        hlr.dependents?.forEach((element) {
          if(element?.name == dependent?.name){
            element?.email = emailController.text;
            element?.holderDocument = documentController.text;
            element?.authUid = dependent?.authUid;
          }
        });
        AppDatabase.updateUser(
            document: AppUtils.unmaskDocument(documentController.text),
            data: hlr.toJson())
            .then((value) {
          goToHomeDependent();
        });
      }else{
        AppDatabase.createUser(
            document: AppUtils.unmaskDocument(documentController.text),
            data: holder!.toJson()
        ).then((value) {
          goToHomeDependent();
        });
      }
    });
  }

  void goToHomeDependent() {
    context.loaderOverlay.hide();
    storage.write(AppStrings.keyUserName, nameController.text);
    storage.write(AppStrings.keyHolder, false);
    Get.off(() => const HomeScreen());
  }
}
