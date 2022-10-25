import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:angel_car/global/utils/app-colors.dart';
import 'package:angel_car/ui/welcome/welcome_screen.dart';

Widget appBarHome({String? title}){
  return AppBar(
    automaticallyImplyLeading: false,
    systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(statusBarColor: AppColors.transparent),
    backgroundColor: AppColors.primary,
    title: Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Image.asset('assets/images/logo.png', height: 65.0,),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: IconButton(
          splashColor: AppColors.transparent,
          highlightColor: AppColors.transparent,
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Get.offAll(() => const WelcomeScreen());
          },
          // onPressed: () => Get.to(() => ProfileScreen()),TODO: Finalizar Profile
          icon: const Icon(Icons.exit_to_app_rounded),
          // icon: Image.asset('assets/images/ic_profile.png'), TODO: Finalizar Profile
        ),
      ),
    ],
  );
}