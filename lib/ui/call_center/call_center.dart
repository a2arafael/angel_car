import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:angel_car/global/firebase/app_database.dart';
import 'package:angel_car/global/model/call_center.dart';
import 'package:angel_car/global/model/singleton.dart';
import 'package:angel_car/global/model/social_media.dart';
import 'package:angel_car/global/utils/app-colors.dart';
import 'package:angel_car/global/utils/app-strings.dart';
import 'package:angel_car/global/utils/app-text-styles.dart';
import 'package:angel_car/global/widgets/app_bar_default.dart';
import 'package:angel_car/global/widgets/button_solid.dart';
import 'package:angel_car/global/widgets/divider.dart';
import 'package:angel_car/global/widgets/social_media_buttons.dart';
import 'package:angel_car/ui/call_center/widgets/tfd_message.dart';
import 'package:angel_car/ui/call_center/widgets/tff_name.dart';
import 'package:angel_car/ui/call_center/widgets/tff_subject.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:url_launcher/url_launcher.dart';

class CallCenterScreen extends StatefulWidget {
  const CallCenterScreen({Key? key}) : super(key: key);

  @override
  _CallCenterScreenState createState() => _CallCenterScreenState();
}

class _CallCenterScreenState extends State<CallCenterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  var _autoValidate = AutovalidateMode.disabled;
  CallCenter response = CallCenter();
  SocialMedia? socialMedia;

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
            child: appBarDefault('CENTRAL DE ATENDIMENTO')),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: _autoValidate,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder(
                  stream: AppDatabase.getScreenStream(document: "central"),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        context.loaderOverlay.show();
                        return Container();
                      default:
                        DocumentSnapshot documentSnapshot =
                            snapshot.data as DocumentSnapshot;
                        Map<String, dynamic> map =
                            documentSnapshot.data() as Map<String, dynamic>;

                        socialMedia = Singleton().getSocialMedia();
                        response = CallCenter.fromJson(map);
                        return Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            ///Título
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  bottom: 16.0),
                              child: Text(
                                response.description ?? '',
                                style: AppTextStyles.robotoRegular(
                                  size: 18.0,
                                  color: AppColors.gray,
                                ),
                              ),
                            ),
                            divider(AppColors.gray),

                            const SizedBox(
                              height: 16.0,
                            ),
                            tffName(
                              nameController: _nameController,
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return "Campo obrigatório!";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            tffSubject(
                              subjectController: _subjectController,
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return "Campo obrigatório!";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            tfdMessage(
                              messageController: _messageController,
                              messageLength: 300,
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return "Campo obrigatório!";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(
                              height: 32.0,
                            ),
                            buttonSolid(
                                text: 'Enviar',
                                onPressed: () =>
                                    _validateInputs(response)),
                            const SizedBox(height: 64.0),

                            ///Botões rede social
                            socialMediaButtons(context),
                          ],
                        );
                    }
                  }),
            ),
          ),
        ),
      ),
    );
  }

  ///---------------------------------------------------------------------------
  ///Validação dos formulários
  void _validateInputs(CallCenter response) async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String? phone =
          response.whatsappPhone?.replaceAll(' ', '').replaceAll('-', '');
      var url = Uri.parse(
          "https://api.whatsapp.com/send?phone=55$phone&text=${AppStrings.initSalutation()}\n\n*Nome*: ${_nameController.text}\n\n*Motivo do contato*: ${_subjectController.text}\n\n*Mensagem*: ${_messageController.text}");
      _launchUrl(url);
    } else {
      //Se todos os dados não forem válidos, inicie a validação automática.
      setState(() {
        _autoValidate = AutovalidateMode.always;
      });
    }
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    } else {
      _nameController.clear();
      _subjectController.clear();
      _messageController.clear();
    }
  }
}
