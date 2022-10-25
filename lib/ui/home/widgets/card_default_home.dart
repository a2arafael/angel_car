import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:angel_car/global/utils/app-colors.dart';
import 'package:angel_car/global/utils/app-text-styles.dart';

Widget cardDefaultHome({String? image, String? text, VoidCallback? onPressed}){
  double screenWidth = Get.width;
  double screenHeight = Get.height;
  String imageDefault = 'assets/images/logo.png';
  String textDefault = 'Não informado';
  return Card(
    elevation: 5.0,
    color: AppColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: GestureDetector(
      onTap: onPressed,
      child: Container(
        height: screenWidth * 0.28,
        padding: const EdgeInsets.only(top: 12.0,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(
                image ?? imageDefault,
                height: 60.0,
              ),
              const SizedBox(height: 8.0,),
              Expanded(
                child: Text(
                  text ?? textDefault,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.robotoRegular(
                      color: AppColors.primary,
                      size: screenHeight > 650.0 ? 12.0 : 10.0
                  ),
                ),
              ),
            ],
          ),
      ),
    ),
  );
}