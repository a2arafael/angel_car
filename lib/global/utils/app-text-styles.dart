import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:angel_car/global/utils/app-colors.dart';
import 'package:angel_car/global/utils/app-font-weight.dart';

class AppTextStyles {
  ///ROBOTO
  ///Thin
  static TextStyle robotoThin({Color? color, double? size}) {
    return GoogleFonts.roboto(
      color: color ?? AppColors.black,
      fontSize: size ?? 12.0,
      fontWeight: AppFontWeight.THIN,
    );
  }

  ///ExtraLight
  static TextStyle robotoExtraLight({Color? color, double? size}) {
    return GoogleFonts.roboto(
      color: color ?? AppColors.black,
      fontSize: size ?? 12.0,
      fontWeight: AppFontWeight.EXTRA_LIGHT,
    );
  }

  ///Light
  static TextStyle robotoLight({Color? color, double? size}) {
    return GoogleFonts.roboto(
      color: color ?? AppColors.black,
      fontSize: size ?? 12.0,
      fontWeight: AppFontWeight.LIGHT,
    );
  }

  ///Regular
  static TextStyle robotoRegular({Color? color, double? size}) {
    return GoogleFonts.roboto(
      color: color ?? AppColors.black,
      fontSize: size ?? 12.0,
      fontWeight: AppFontWeight.REGULAR,
    );
  }

  ///Medium
  static TextStyle robotoMedium({Color? color, double? size}) {
    return GoogleFonts.roboto(
      color: color ?? AppColors.black,
      fontSize: size ?? 12.0,
      fontWeight: AppFontWeight.MEDIUM,
    );
  }

  ///Medium Underline
  static TextStyle robotoMediumUnderline({Color? color, double? size}) {
    return GoogleFonts.roboto(
      color: color ?? AppColors.black,
      fontSize: size ?? 12.0,
      fontWeight: AppFontWeight.MEDIUM,
      decoration: TextDecoration.underline,
    );
  }

  ///SemiBold
  static TextStyle robotoSemiBold({Color? color, double? size}) {
    return GoogleFonts.roboto(
      color: color ?? AppColors.black,
      fontSize: size ?? 12.0,
      fontWeight: AppFontWeight.SEMI_BOLD,
    );
  }

  ///Bold
  static TextStyle robotoBold({Color? color, double? size}) {
    return GoogleFonts.roboto(
      color: color ?? AppColors.black,
      fontSize: size ?? 12.0,
      fontWeight: AppFontWeight.BOLD,
    );
  }

  ///ExtraBold
  static TextStyle robotoExtraBold({Color? color, double? size}) {
    return GoogleFonts.roboto(
      color: color ?? AppColors.black,
      fontSize: size ?? 12.0,
      fontWeight: AppFontWeight.BOLD,
    );
  }

  ///Black
  static TextStyle robotoBlack({Color? color, double? size}) {
    return GoogleFonts.roboto(
      color: color ?? AppColors.black,
      fontSize: size,
      fontWeight: AppFontWeight.BLACK,
    );
  }
}
