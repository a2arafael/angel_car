import 'package:angel_car/global/utils/app-colors.dart';
import 'package:flutter/material.dart';
import 'package:angel_car/global/utils/app-text-styles.dart';

Widget buttonSolid({
  String? text,
  VoidCallback? onPressed,
  Color? color,
  Color? textColor,
  double? height,
  double? width,
  double? textSize,
}){
  return Container(
    height: height ?? 48.0,
    width: width ?? double.infinity,
    decoration: BoxDecoration(
      color: color ?? AppColors.primary,
      borderRadius: const BorderRadius.all(Radius.circular(1000.0))
    ),
    child: TextButton(
      onPressed: onPressed,
      child: Text(
        text ?? "",
        style: AppTextStyles.robotoBold(color: textColor ?? AppColors.white, size: textSize ?? 20.0),
      ),
    ),
  );
}