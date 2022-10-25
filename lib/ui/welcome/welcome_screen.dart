import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:angel_car/global/utils/app-colors.dart';
import 'package:angel_car/global/utils/app-text-styles.dart';
import 'package:angel_car/global/widgets/button_solid.dart';
import 'package:angel_car/global/widgets/outlined_button.dart';
import 'package:angel_car/ui/login/login_screen.dart';
import 'package:angel_car/ui/signup/signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  double screenHeight = Get.height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      body: Stack(
          children: [
            ///Imagem
            Positioned(
                top: 130.0,
                left: 32.0,
                right: 32.0,
                child: Column(
                  children: [
                    Image.asset('assets/images/logo.png',width: Get.width * 0.5,),
                  ],
                )
            ),

            ///Botões
            Padding(
              padding: screenHeight > 650 ?
              const EdgeInsets.only(bottom: 16.0, left: 32.0, right: 32.0) :
              const EdgeInsets.only(left: 32.0, right: 32.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 24.0,),

                    ///Botão cadastrar
                    buttonSolid(
                      text: "Criar uma conta",
                      textSize: screenHeight > 650.0 ? 20.0 :16.0,
                      onPressed: (){
                        Get.to(const SignupScreen());
                      },
                    ),
                    const SizedBox(height: 16.0,),

                    ///Botão entrar
                    outlinedButton(
                      text: "Entrar em minha conta",
                      textSize: screenHeight > 650.0 ? 20.0 :16.0,
                      onPressed: (){
                        Get.to(const LoginScreen());
                      }
                    ),
                    const SizedBox(height: 16.0,),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }
}
