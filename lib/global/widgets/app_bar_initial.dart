import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:angel_car/global/utils/app-colors.dart';
import 'package:angel_car/global/utils/app-text-styles.dart';

Widget appBarInitial(String title, double screenHeight,  {VoidCallback? onPressed}){
  return AppBar(
    systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(statusBarColor: AppColors.primary),
    backgroundColor: AppColors.white,
    leading: Padding(
      padding: EdgeInsets.only(top: screenHeight > 650.0 ? 12.0 : 16.0),
      child: BackButton(color: AppColors.primary,
        onPressed: onPressed ?? () => Get.back(),),
    ),
    title: Padding(
      padding: EdgeInsets.only(top: screenHeight > 650.0 ? 12.0 : 16.0),
      child: Text(
        title,
        style: AppTextStyles.robotoBlack(size: screenHeight > 650.0 ? 16.0: 12.0),
      ),
    ),
  );
}