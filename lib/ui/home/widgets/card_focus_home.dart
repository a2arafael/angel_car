import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:angel_car/global/utils/app-colors.dart';
import 'package:angel_car/global/utils/app-text-styles.dart';

Widget cardFocusHome({String? image, String? text, VoidCallback? onPressed}) {
  double screenWidth = Get.width;
  double screenHeigth = Get.height;
  String imageDefault = 'assets/images/ic_logo_white.png';
  return Card(
      elevation: 10.0,
      color: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: SizedBox(
          height: screenWidth * 0.45,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16.0,),
                Image.asset(
                  image ?? imageDefault,
                  height: screenHeigth > 650.0 ? 70.0 : 60.0,
                ),
                const SizedBox(height: 16.0,),
                Expanded(
                  child: Text(
                    text ??  'Não informado',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.robotoMedium(
                        color: AppColors.white,
                      size: screenHeigth > 650.0 ? 14.0 : 10.0
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
}
