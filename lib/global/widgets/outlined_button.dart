import 'package:angel_car/global/utils/app-colors.dart';
import 'package:flutter/material.dart';
import 'package:angel_car/global/utils/app-text-styles.dart';

Widget outlinedButton({String? text, VoidCallback? onPressed, double? textSize}){
  return SizedBox(
      height: 48.0,
      width: double.infinity,
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1000.0),
        ),
        side: const BorderSide(width: 1.0, color: AppColors.primary),
      ),
      onPressed: onPressed,
      child: Text(
        text ?? "",
        style: AppTextStyles.robotoBold(color: AppColors.primary, size: textSize ?? 20.0),
      ),
    )
  );
}