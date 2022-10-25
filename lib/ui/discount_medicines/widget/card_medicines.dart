import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:angel_car/global/utils/app-colors.dart';

Widget cardMedicines({String? image, String? text, VoidCallback? onPressed}){
  CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;
  String imageDefault = 'assets/images/logo_alpha.png';
  return Card(
    elevation: 5.0,
    color: AppColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: GestureDetector(
      onTap: onPressed,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CachedNetworkImage(
            imageUrl: image ?? imageDefault,
            placeholder: (context, url) => const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryAlpha)),
            errorWidget: (context, url, error) => Image.asset(imageDefault),
          ),
        ),
      ),
    ),
  );
}