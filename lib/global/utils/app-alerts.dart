import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:angel_car/global/model/dependent.dart';
import 'package:angel_car/global/utils/app-text-styles.dart';
import 'package:angel_car/global/widgets/divider.dart';

import 'app-colors.dart';

class AppAlerts{

  static void snackbarError(String title, String message){
    Get.snackbar(
      title,
      message,
      duration: const Duration(seconds: 10),
      backgroundColor: AppColors.red,
      colorText: AppColors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16.0),
    );
  }

  static void snackbarSuccess(String title, String message){
    Get.snackbar(
      title,
      message,
      duration: const Duration(seconds: 5),
      backgroundColor: AppColors.green,
      colorText: AppColors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16.0),
    );
  }

  static void progress(BuildContext context) async {
    Get.dialog(
      AlertDialog(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Center(
              child: SizedBox(
                  height: 40.0,
                  width: 40.0,
                  child: CircularProgressIndicator(
                    backgroundColor: AppColors.gray,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.primary),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  static void benefitSelector(BuildContext context, List<Dependent>? benefits) {
    Get.dialog(
      AlertDialog(
        content: SizedBox(
          width: 100,
          height: 100,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: benefits?.length,
              itemBuilder: (context, index){
            return Column(
              children: [
                Text(
                  benefits?[index].name ?? '',
                  style: AppTextStyles.robotoExtraBold(
                    color: AppColors.primary,
                    size: 17.0,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                divider(AppColors.gray),
              ],
            );
          }),
        ),
      ),
    );
  }
}