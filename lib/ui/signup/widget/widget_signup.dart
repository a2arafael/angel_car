import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:angel_car/global/widgets/button_solid.dart';
import 'package:angel_car/global/widgets/button_text_underline.dart';
import 'package:angel_car/global/widgets/input.dart';
import 'package:angel_car/ui/login/login_screen.dart';
import 'package:angel_car/ui/webview/web_view_screen.dart';

Widget widgetSignup({
  required TextEditingController nameController,
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required TextEditingController confirmPasswordController,
  required TextEditingController documentController,
  required String character,
  required VoidCallback onPressed,
}){
  return Column(
    children: [
      ///CPF Dependente
      character == 'Dependente' ?
      Input(
        hint: 'CPF do dependente',
        maxLength: 10,
        enable: false,
        controller: documentController,
        keyboardType:  GetPlatform.isIOS ? TextInputType.text : TextInputType.number,
        textInputAction: TextInputAction.go,
        validator: (value) {
          if (value != null && value.isEmpty) {
            return "Campo obrigatório!";
          } else if (value != null &&
              !GetUtils.isCpf(value)) {
            return "CPF inválido.";
          } else {
            return null;
          }
        },
      ): Container(),
      character == 'Dependente' ?
      const SizedBox(
        height: 10.0,
      ): Container(),

      ///Nome
      Input(
        hint: 'Nome',
        enable: false,
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
      const SizedBox(
        height: 10.0,
      ),

      ///E-mail
      Input(
        hint: 'E-mail',
        enable: character == 'Dependente' ? true : false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.go,
        validator: (value) {
          if (value != null && value.isEmpty) {
            return "Campo obrigatório!";
          } else if (value != null &&
              !GetUtils.isEmail(value)) {
            return "E-mail inválido!";
          } else {
            return null;
          }
        },
      ),
      const SizedBox(
        height: 10.0,
      ),

      ///Senha
      Input(
        hint: 'Senha',
        maxLength: 10,
        controller: passwordController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.go,
        validator: (value) {
          if (value != null && value.isEmpty) {
            return "Campo obrigatório!";
          } else {
            return null;
          }
        },
      ),
      const SizedBox(
        height: 10.0,
      ),

      ///Confirmar Senha
      Input(
        hint: 'Confirmar Senha',
        maxLength: 10,
        controller: confirmPasswordController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.go,
        validator: (value) {
          if (value != null && value.isEmpty) {
            return "Campo obrigatório!";
          } else if (value != passwordController.text) {
            return "Senhas não coincidem.";
          } else {
            return null;
          }
        },
      ),
      const SizedBox(
        height: 24.0,
      ),

      ///Botão Criar conta
      buttonSolid(
          text: 'Criar conta',
          onPressed: onPressed,
      ),

      const SizedBox(
        height: 16.0,
      ),

      // ///Espaçamento
      // isIOS
      //     ? //TODO: Vericicar tamanho de tela da Apple
      //     //Apple
      //     screenHeight > 650
      //         ? SizedBox(
      //             height: Get.context!.height * 0.17,
      //           )
      //         : SizedBox(
      //             height: Get.context!.height * 0.08,
      //           )
      //     :
      //     //Google
      //     screenHeight > 650
      //         ? SizedBox(
      //             height: Get.context!.height * 0.17,
      //           )
      //         : SizedBox(
      //             height: Get.context!.height * 0.12,
      //           ),

      ///Texto 1
      // Text(
      //   'Use seu login:',
      //   style: AppTextStyles.robotoMedium(
      //     size: 18.0,
      //     color: AppColors.gray,
      //   ),
      // ),
      // SizedBox(
      //   height: 16.0,
      // ),

      ///Botões sociais
      // buttonsSocial(),
      // SizedBox(
      //   height: 16.0,
      // ),

      ///Texto 2
      buttonTextUnderline(
          text: 'Seus dados estão seguros, conheça nossa',
          textUnderline: 'Política de Privacidade',
          onPressed: () => Get.to(() => const WebViewScreen(
            title: 'Política de Privacidade',
            url: 'https://kera.app.br/politica-privacidade-app',
          ))),
      const SizedBox(
        height: 48.0,
      ),

      ///Texto 3
      buttonTextUnderline(
          text: 'Já tenho uma conta?',
          textUnderline: 'Clique aqui',
          onPressed: () => Get.off(() => const LoginScreen())),
    ],
  );
}