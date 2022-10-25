import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:angel_car/global/utils/app-colors.dart';
import 'package:angel_car/global/utils/app-text-styles.dart';

Widget appBarDefault(String title, {VoidCallback? onPressed}){
  return AppBar(
    systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(statusBarColor: AppColors.transparent),
    backgroundColor: AppColors.primary,
    leading: BackButton(color: AppColors.white,
      onPressed: onPressed ?? () => Get.back(),),
    title: Text(
      title,
      style: AppTextStyles.robotoBlack(size: 16.0, color: AppColors.white),
    ),
  );
}