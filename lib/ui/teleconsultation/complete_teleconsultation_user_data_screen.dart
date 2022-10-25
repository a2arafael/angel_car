import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:angel_car/global/conexa/conexa_repository.dart';
import 'package:angel_car/global/conexa/request/user_registration_request.dart';
import 'package:angel_car/global/conexa/response/holder_response.dart';
import 'package:angel_car/global/conexa/response/user_registration_response.dart';
import 'package:angel_car/global/firebase/app_database.dart';
import 'package:angel_car/global/model/dependent.dart';
import 'package:angel_car/global/model/holder.dart';
import 'package:angel_car/global/utils/app-alerts.dart';
import 'package:angel_car/global/utils/app-colors.dart';
import 'package:angel_car/global/utils/app-strings.dart';
import 'package:angel_car/global/utils/app-text-styles.dart';
import 'package:angel_car/global/utils/app-utils.dart';
import 'package:angel_car/global/widgets/app_bar_default.dart';
import 'package:angel_car/global/widgets/button_solid.dart';
import 'package:angel_car/global/widgets/divider.dart';
import 'package:angel_car/global/widgets/input.dart';
import 'package:loader_overlay/loader_overlay.dart';

class CompleteTeleconsultationUserDataScreen extends StatefulWidget {
  final String? document;
  final String? dependentName;
  final String? documentHolder;
  final bool? isHolder;

  const CompleteTeleconsultationUserDataScreen({
    Key? key,
    required this.document,
    required this.documentHolder,
    required this.isHolder,
    this.dependentName,
  }) : super(key: key);

  @override
  _CompleteTeleconsultationUserDataScreenState createState() =>
      _CompleteTeleconsultationUserDataScreenState();
}

class _CompleteTeleconsultationUserDataScreenState
    extends State<CompleteTeleconsultationUserDataScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController documentController = TextEditingController();
  TextEditingController dateBirthController = TextEditingController();
  bool isIOS = GetPlatform.isIOS;
  double screenHeight = Get.height;
  static GetStorage storage = GetStorage();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  String dropdownValue = 'Selecione o sexo';
  final ConexaRepository conexaRepository = ConexaRepository();

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
            child: appBarDefault('TELECONSULTA')),
        body: SingleChildScrollView(
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(AppStrings.collectionUsers)
                      .doc(AppUtils.unmaskDocument(widget.document))
                      .snapshots(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        context.loaderOverlay.show();
                        return Container();
                      default:
                        context.loaderOverlay.hide();
                        DocumentSnapshot documentSnapshot =
                            snapshot.data as DocumentSnapshot;
                        Map<String, dynamic> map =
                            documentSnapshot.data() as Map<String, dynamic>;
                        if (documentSnapshot.data() != null) {
                          if (widget.isHolder == true) {
                            Holder holder = Holder.fromJson(map);
                            if (widget.dependentName != null) {
                              Dependent? dependent;
                              holder.dependents?.forEach((element) {
                                if (element?.name == widget.dependentName) {
                                  dependent = element;
                                }
                              });
                              return bodyScreenHolder(
                                  holder: holder, dependent: dependent);
                            } else {
                              return bodyScreenHolder(holder: holder);
                            }
                          } else {
                            Dependent dependent = Dependent.fromJson(map);
                            return bodyScreenDependent(dependent: dependent);
                          }
                        } else {
                          Get.back();
                          AppAlerts.snackbarError('Atenção',
                              'Falha de conexão, verifique sua conexão ou tente novamente mais tarde! Se o erro persistir entre em contato com a central.');
                          return Container();
                        }
                    }
                  })),
        ),
      ),
    );
  }

  Widget bodyScreenHolder({Holder? holder, Dependent? dependent}) {
    if (dependent != null) {
      nameController.text = dependent.name ?? '';
      emailController.text = dependent.email ?? '';
      documentController.text = dependent.document ?? '';
      phoneController.text = dependent.cellphone ?? '';
      dateBirthController.text = dependent.dateBirthday ?? '';
      return Form(
        key: _formKey,
        autovalidateMode: _autoValidate,
        child: Column(
          children: [
            ///Título
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Text(
                'Precisamos de algumas informações adicionais antes de continuar',
                style: AppTextStyles.robotoMedium(
                  color: AppColors.gray,
                  size: 18.0,
                ),
              ),
            ),
            divider(AppColors.gray),
            const SizedBox(
              height: 16.0,
            ),

            ///Nome
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Input(
                enable: dependent.name != null ? false : true,
                hint: 'Nome',
                controller: nameController,
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
            ),
            const SizedBox(
              height: 16.0,
            ),

            ///Sexo
            Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0, bottom: 8.0),
                      child: Text(
                        'Sexo',
                        style: AppTextStyles.robotoRegular(
                            color: AppColors.gray, size: 14.0),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 32.0, top: 4.0, right: 32.0),
                      height: 55.0,
                      width: double.maxFinite,
                      decoration: const BoxDecoration(
                          color: AppColors.grayLight,
                          borderRadius:
                              BorderRadius.all(Radius.circular(1000.0))),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        iconEnabledColor: Colors.white,
                        dropdownColor: AppColors.grayLight,
                        value: dropdownValue,
                        iconSize: 24,
                        elevation: 16,
                        style: AppTextStyles.robotoRegular(
                            color: AppColors.white, size: 18.0),
                        onChanged: (String? newValue) {
                          if (newValue != 'Selecione o sexo') {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          }
                        },
                        items: <String>[
                          'Selecione o sexo',
                          'Feminino',
                          'Masculino'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: AppTextStyles.robotoRegular(
                                  color: AppColors.white, size: 18.0),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                )),
            const SizedBox(
              height: 16.0,
            ),

            ///E-mail
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Input(
                enable: dependent.email != null ? false : true,
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
            ),
            const SizedBox(
              height: 16.0,
            ),

            ///Celular
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Input(
                hint: 'Celular',
                maxLength: 10,
                controller: phoneController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Campo obrigatório!";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),

            ///CPF Dependente ou Titular
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Input(
                enable: dependent.document != null ? false : true,
                hint: 'CPF',
                maxLength: 10,
                controller: documentController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Campo obrigatório!";
                  } else if (value != null && !GetUtils.isCpf(value)) {
                    return "Senhas não coincidem.";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),

            ///Nascimento
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Input(
                hint: 'Data de nascimento',
                maxLength: 10,
                controller: dateBirthController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Campo obrigatório!";
                  } else {
                    return null;
                  }
                },
              ),
            ),

            const SizedBox(
              height: 32.0,
            ),

            ///Botão Continuar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: buttonSolid(
                  text: 'Continuar',
                  onPressed: () {
                    validateInputsDependent(dependent: dependent);
                  }),
            ),
          ],
        ),
      );
    } else {
      nameController.text = holder?.name ?? '';
      emailController.text = holder?.email ?? '';
      documentController.text = holder?.document ?? '';
      phoneController.text = holder?.cellphone?.substring(2) ?? '';
      return Form(
        key: _formKey,
        autovalidateMode: _autoValidate,
        child: Column(
          children: [
            ///Título
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Text(
                'Precisamos de algumas informações adicionais antes de continuar',
                style: AppTextStyles.robotoMedium(
                  color: AppColors.gray,
                  size: 18.0,
                ),
              ),
            ),
            divider(AppColors.gray),
            const SizedBox(
              height: 16.0,
            ),

            ///Nome
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Input(
                enable: holder?.name != null ? false : true,
                hint: 'Nome',
                controller: nameController,
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
            ),
            const SizedBox(
              height: 16.0,
            ),

            ///Sexo
            Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0, bottom: 8.0),
                      child: Text(
                        'Sexo',
                        style: AppTextStyles.robotoRegular(
                            color: AppColors.gray, size: 14.0),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 32.0, top: 4.0, right: 32.0),
                      height: 55.0,
                      width: double.maxFinite,
                      decoration: const BoxDecoration(
                          color: AppColors.grayLight,
                          borderRadius:
                              BorderRadius.all(Radius.circular(1000.0))),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        iconEnabledColor: Colors.white,
                        dropdownColor: AppColors.grayLight,
                        value: dropdownValue,
                        iconSize: 24,
                        elevation: 16,
                        style: AppTextStyles.robotoRegular(
                            color: AppColors.white, size: 18.0),
                        onChanged: (String? newValue) {
                          if (newValue != 'Selecione o sexo') {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          }
                        },
                        items: <String>[
                          'Selecione o sexo',
                          'Feminino',
                          'Masculino'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: AppTextStyles.robotoRegular(
                                  color: AppColors.white, size: 18.0),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                )),
            const SizedBox(
              height: 16.0,
            ),

            ///E-mail
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Input(
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
            ),
            const SizedBox(
              height: 16.0,
            ),

            ///Celular
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Input(
                hint: 'Celular',
                maxLength: 10,
                controller: phoneController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Campo obrigatório!";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),

            ///CPF Dependente ou Titular
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Input(
                enable: holder?.document != null ? false : true,
                hint: 'CPF',
                maxLength: 10,
                controller: documentController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Campo obrigatório!";
                  } else if (value != null && !GetUtils.isCpf(value)) {
                    return "Senhas não coincidem.";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),

            ///Nascimento
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Input(
                hint: 'Data de nascimento',
                maxLength: 10,
                controller: dateBirthController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Campo obrigatório!";
                  } else {
                    return null;
                  }
                },
              ),
            ),

            const SizedBox(
              height: 32.0,
            ),

            ///Botão Continuar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: buttonSolid(
                  text: 'Continuar',
                  onPressed: () {
                    validateInputsHolder(holder: holder);
                  }),
            ),
          ],
        ),
      );
    }
  }

  Widget bodyScreenDependent({Dependent? dependent}) {
    nameController.text = dependent?.name ?? '';
    emailController.text = dependent?.email ?? '';
    documentController.text = dependent?.document ?? '';
    phoneController.text = dependent?.cellphone?.substring(2) ?? '';
    dateBirthController.text = dependent?.dateBirthday ?? '';

    return Form(
      key: _formKey,
      autovalidateMode: _autoValidate,
      child: Column(
        children: [
          ///Título
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Text(
              'Precisamos de algumas informações adicionais antes de continuar',
              style: AppTextStyles.robotoMedium(
                color: AppColors.gray,
                size: 18.0,
              ),
            ),
          ),
          divider(AppColors.gray),
          const SizedBox(
            height: 16.0,
          ),

          ///Nome
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Input(
              enable: dependent?.name != null ? false : true,
              hint: 'Nome',
              controller: nameController,
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
          ),
          const SizedBox(
            height: 16.0,
          ),

          ///Sexo
          Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0, bottom: 8.0),
                    child: Text(
                      'Sexo',
                      style: AppTextStyles.robotoRegular(
                          color: AppColors.gray, size: 14.0),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 32.0, top: 4.0, right: 32.0),
                    height: 55.0,
                    width: double.maxFinite,
                    decoration: const BoxDecoration(
                        color: AppColors.grayLight,
                        borderRadius:
                            BorderRadius.all(Radius.circular(1000.0))),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      iconEnabledColor: Colors.white,
                      dropdownColor: AppColors.grayLight,
                      value: dropdownValue,
                      iconSize: 24,
                      elevation: 16,
                      style: AppTextStyles.robotoRegular(
                          color: AppColors.white, size: 18.0),
                      onChanged: (String? newValue) {
                        if (newValue != 'Selecione o sexo') {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        }
                      },
                      items: <String>[
                        'Selecione o sexo',
                        'Feminino',
                        'Masculino'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: AppTextStyles.robotoRegular(
                                color: AppColors.white, size: 18.0),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              )),
          const SizedBox(
            height: 16.0,
          ),

          ///E-mail
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Input(
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
          ),
          const SizedBox(
            height: 16.0,
          ),

          ///Celular
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Input(
              hint: 'Celular',
              maxLength: 10,
              controller: phoneController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return "Campo obrigatório!";
                } else {
                  return null;
                }
              },
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),

          ///CPF Dependente ou Titular
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Input(
              enable: dependent?.document != null ? false : true,
              hint: 'CPF',
              maxLength: 10,
              controller: documentController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return "Campo obrigatório!";
                } else if (value != null && !GetUtils.isCpf(value)) {
                  return "Senhas não coincidem.";
                } else {
                  return null;
                }
              },
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),

          ///Nascimento
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Input(
              hint: 'Data de nascimento',
              maxLength: 10,
              controller: dateBirthController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return "Campo obrigatório!";
                } else {
                  return null;
                }
              },
            ),
          ),
          const SizedBox(
            height: 32.0,
          ),

          ///Botão Continuar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: buttonSolid(
                text: 'Continuar',
                onPressed: () => validateInputsDependent(dependent: dependent)),
          ),
        ],
      ),
    );
  }

  void validateInputsHolder({Holder? holder}) {
    context.loaderOverlay.show();
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate() &&
        dropdownValue != 'Selecione o sexo') {
      _formKey.currentState!.save();

      int? conexaId = 0;

      UserRegistrationRequest request = UserRegistrationRequest(
        holder: HolderResponse(
          sex: dropdownValue == 'Feminino' ? 'FEMALE' : 'MALE',
          name: nameController.text,
          mail: emailController.text,
          dateBirth: dateBirthController.text,
          cpf: AppUtils.unmaskDocument(documentController.text),
          cellphone: AppUtils.unmaskPhone(phoneController.text),
        ),
      );
      conexaRepository.createOrUpdatePatient(request).then((conexaUser) {
        UserRegistrationResponse response =
            UserRegistrationResponse.fromJson(conexaUser.data);
        conexaId = response.object?.holder?.id;
        conexaRepository.activatePatient(conexaId).then((apValue) async {
          if (apValue.data['status'] == 200) {
            final ipv4 = await Ipify.ipv4();
            conexaRepository
                .acceptTermsPatient(conexaId, ipv4)
                .then((atpValue) {
              if (atpValue.data['status'] == 200) {
                holder?.name = nameController.text;
                holder?.email = emailController.text;
                holder?.cellphone = phoneController.text;
                holder?.document = documentController.text;
                holder?.dateBirthday = dateBirthController.text;
                holder?.sex = dropdownValue == 'Feminino' ? 'FEMALE' : 'MALE';
                holder?.fullRegistration = true;
                holder?.isHolder = true;
                holder?.status = 'ativo';
                holder?.conexaId = conexaId;

                AppDatabase.updateUser(
                  document: AppUtils.unmaskDocument(holder?.document),
                  data: holder!.toJson(),
                ).then((value) {
                  storage.write(AppStrings.keyFullRegistration, true);
                  storage.write(AppStrings.keyConexaId, conexaId);

                  conexaRepository.generateMagicLink(conexaId).then((glmValue) {
                    if (glmValue.data['status'] == 200) {
                      context.loaderOverlay.hide();
                      Get.back();
                      _launchURL(context,
                          glmValue.data['object']['linkMagicoWeb']);
                    }
                  }).catchError((onError) {
                    context.loaderOverlay.hide();
                    DioError dioError = onError;
                    AppAlerts.snackbarError('Atenção', dioError.response!.data['msg']);
                  });
                });
              }
            }).catchError((onError) {
              context.loaderOverlay.hide();
              DioError dioError = onError;
              AppAlerts.snackbarError('Atenção', dioError.response!.data['msg']);
            });
          }
        }).catchError((onError) {
          context.loaderOverlay.hide();
          DioError dioError = onError;
          AppAlerts.snackbarError('Atenção', dioError.response!.data['msg']);
        });
      }).catchError((onError) {
        context.loaderOverlay.hide();
        DioError dioError = onError;
        AppAlerts.snackbarError('Atenção', dioError.response!.data['msg']);
      });
    } else {
      context.loaderOverlay.hide();
      _autoValidate = AutovalidateMode.always;
      if (dropdownValue == 'Selecione o sexo') {
        AppAlerts.snackbarError('Atenção', 'Campo sexo obrigatório!');
      }
    }
  }

  void validateInputsDependent({Dependent? dependent}) {
    context.loaderOverlay.show();
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate() &&
        dropdownValue != 'Selecione o sexo') {
      _formKey.currentState!.save();

      int? conexaId = 0;

      UserRegistrationRequest request = UserRegistrationRequest(
        holder: HolderResponse(
          sex: dropdownValue == 'Feminino' ? 'FEMALE' : 'MALE',
          name: nameController.text,
          mail: emailController.text,
          dateBirth: dateBirthController.text,
          cpf: AppUtils.unmaskDocument(documentController.text),
          cellphone: AppUtils.unmaskPhone(phoneController.text),
        ),
      );
      conexaRepository.createOrUpdatePatient(request).then((conexaUser) {
        UserRegistrationResponse response =
            UserRegistrationResponse.fromJson(conexaUser.data);
        conexaId = response.object?.holder?.id;
        conexaRepository.activatePatient(conexaId).then((apValue) async {
          if (apValue.data['status'] == 200) {
            final ipv4 = await Ipify.ipv4();
            conexaRepository
                .acceptTermsPatient(conexaId, ipv4)
                .then((atpValue) {
              if (atpValue.data['status'] == 200) {
                AppDatabase.getUser(
                        document:
                            AppUtils.unmaskDocument(widget.documentHolder))
                    .then((value) {
                  if (value.exists) {
                    Map<String, dynamic> map =
                        value.data() as Map<String, dynamic>;
                    Holder holder = Holder.fromJson(map);
                    Dependent? dpt = Dependent();
                    holder.dependents?.forEach((element) {
                      if (element?.name == dependent?.name) {
                        element?.name = nameController.text;
                        element?.email = emailController.text;
                        element?.cellphone = phoneController.text;
                        element?.document = documentController.text;
                        element?.dateBirthday = dateBirthController.text;
                        element?.sex =
                            dropdownValue == 'Feminino' ? 'FEMALE' : 'MALE';
                        element?.fullRegistration = true;
                        element?.status = 'ativo';
                        element?.holderDocument = holder.document;
                        element?.conexaId = conexaId;
                        element?.isHolder = false;
                        dpt = element;
                      }
                    });
                    AppDatabase.getUser(
                            document: AppUtils.unmaskDocument(dpt?.document))
                        .then((value) {
                      if (value.exists) {
                        AppDatabase.updateUser(
                            document: AppUtils.unmaskDocument(dpt?.document),
                            data: dpt!.toJson());
                      } else {
                        AppDatabase.createUser(
                            document: AppUtils.unmaskDocument(dpt?.document),
                            data: dpt!.toJson());
                      }
                    });

                    AppDatabase.updateUser(
                      document: AppUtils.unmaskDocument(holder.document),
                      data: holder.toJson(),
                    ).then((value) {
                      storage.write(AppStrings.keyFullRegistration, true);
                      storage.write(AppStrings.keyConexaId, conexaId);

                      conexaRepository
                          .generateMagicLink(conexaId)
                          .then((glmValue) {
                        if (glmValue.data['status'] == 200) {
                          context.loaderOverlay.hide();
                          Get.back();
                          _launchURL(context,
                              glmValue.data['object']['linkMagicoWeb']);
                        }
                      }).catchError((onError) {
                        context.loaderOverlay.hide();
                        DioError dioError = onError;
                        AppAlerts.snackbarError('Atenção', dioError.response!.data['msg']);
                      });
                    });
                  } else {
                    AppAlerts.snackbarError('Atenção',
                        'Falha na conexão. Tente novamente  mais tarde. Se o erro persistir entre em contato com a central.');
                  }
                });
              }
            });
          }
        });
      });
    } else {
      context.loaderOverlay.hide();
      _autoValidate = AutovalidateMode.always;
      if (dropdownValue == 'Selecione o sexo') {
        AppAlerts.snackbarError('Atenção', 'Campo sexo obrigatório!');
      }
    }
  }

  void _launchURL(BuildContext context, String url) async {
    try {
      await launch(
        url,
        customTabsOption: CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          extraCustomTabs: const <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
        safariVCOption: SafariViewControllerOption(
          preferredBarTintColor: Theme.of(context).primaryColor,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}
