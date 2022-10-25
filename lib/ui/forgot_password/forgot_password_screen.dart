import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:angel_car/global/firebase/app_auth.dart';
import 'package:angel_car/global/utils/app-alerts.dart';
import 'package:angel_car/global/utils/app-colors.dart';
import 'package:angel_car/global/utils/app-text-styles.dart';
import 'package:angel_car/global/utils/app-utils.dart';
import 'package:angel_car/global/widgets/app_bar_initial.dart';
import 'package:angel_car/global/widgets/button_solid.dart';
import 'package:angel_car/global/widgets/input.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  double screenHeight = Get.height;

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
            child: appBarInitial('RECUPERAR SENHA', screenHeight)),
        body: SingleChildScrollView(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidate,
              child: Column(
                children: [
                  ///Título
                  Text(
                    'Digite o e-mail cadastrado e receba as instruções para recuperar sua senha.',
                    style: AppTextStyles.robotoRegular(
                      size: 18.0,
                      color: AppColors.gray,
                    ),
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),
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
                    height: 64.0,
                  ),

                  ///Botão enviar
                  buttonSolid(
                      text: 'Enviar',
                      onPressed: () => forgotPassword(email: emailController.text)),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void forgotPassword({required String email}) {
    AppUtils.hideKeyboard(context: context);
    context.loaderOverlay.show();
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      AppAuth.forgotPassword(email, context.loaderOverlay).then((value) {
        if(value){
          context.loaderOverlay.hide();
          Get.back();
          AppAlerts.snackbarSuccess("Sucesso", "E-mail enviado! Verifique sua caixa de e-mail e siga as instruções.");
        }
      });
    } else {
      setState(() {
        context.loaderOverlay.hide();
        _autoValidate = AutovalidateMode.always;
      });
    }
  }
}
