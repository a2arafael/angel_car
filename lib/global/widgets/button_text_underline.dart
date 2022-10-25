import 'package:flutter/material.dart';
import 'package:angel_car/global/utils/app-colors.dart';
import 'package:angel_car/global/utils/app-text-styles.dart';

Widget buttonTextUnderline({String? text, String? textUnderline, VoidCallback? onPressed}){
  return GestureDetector(
    onTap: onPressed,
    child: Text.rich(
      TextSpan(
        text: '$text ',
        style: AppTextStyles.robotoLight(
          size: 14.0,
          color: AppColors.gray,
        ),
        children: <TextSpan>[
          TextSpan(
            text: textUnderline,
            style: AppTextStyles.robotoMediumUnderline(
              color: AppColors.primary,
              size: 14.0,
            ),
          ),
          // can add more TextSpans here...
        ],
      ),
    ),
  );
}