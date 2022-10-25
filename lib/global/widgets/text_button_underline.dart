import 'package:angel_car/global/utils/app-colors.dart';
import 'package:flutter/material.dart';

Widget textButtonUnderline({String? text, VoidCallback? onPressed}){
  return TextButton(
      onPressed: onPressed,
      child: Text(
          text ?? "",
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
          decoration: TextDecoration.underline
        ),
      )
  );
}