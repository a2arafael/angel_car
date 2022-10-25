import 'package:angel_car/global/utils/app-strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:angel_car/global/firebase/app_database.dart';
import 'package:angel_car/global/model/drug_discount.dart';
import 'package:angel_car/global/utils/app-colors.dart';
import 'package:angel_car/global/utils/app-text-styles.dart';
import 'package:angel_car/global/widgets/app_bar_default.dart';
import 'package:angel_car/global/widgets/divider.dart';
import 'package:angel_car/ui/discount_medicines/widget/card_medicines.dart';
import 'package:angel_car/ui/webview/web_view_screen.dart';
import 'package:loader_overlay/loader_overlay.dart';

class DiscountMedicinesScreen extends StatefulWidget {
  const DiscountMedicinesScreen({Key? key}) : super(key: key);

  @override
  _DiscountMedicinesScreenState createState() =>
      _DiscountMedicinesScreenState();
}

class _DiscountMedicinesScreenState extends State<DiscountMedicinesScreen> {
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayOpacity: 0.7,
      overlayColor: AppColors.black,
      useDefaultLoading: false,
      overlayWidget: const Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: appBarDefault('DESCONTO EM MEDICAMENTOS')),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: StreamBuilder(
                stream: AppDatabase.getScreenStream(document: 'medicamentos'),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      context.loaderOverlay.show();
                      return Container();
                    default:
                      DocumentSnapshot documentSnapshot =
                          snapshot.data as DocumentSnapshot;
                      Map<String, dynamic> map =
                          documentSnapshot.data() as Map<String, dynamic>;
                      var drugDiscount = DrugDiscount.fromJson(map);
                      var drugDiscountButtons = [];

                      drugDiscount.buttons?.forEach((element) {
                        if(element.active == true){
                          drugDiscountButtons.add(element);
                        }
                      });

                      context.loaderOverlay.hide();
                      return Column(
                        children: [
                          ///Título
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              drugDiscount.description ?? '',
                              style: AppTextStyles.robotoRegular(
                                size: 18.0,
                                color: AppColors.gray,
                              ),
                            ),
                          ),
                          divider(AppColors.gray),
                          const SizedBox(
                            height: 32.0,
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: drugDiscountButtons.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8),
                            itemBuilder: (ctx, index) {
                              return cardMedicines(
                                image: drugDiscountButtons[index].image,
                                onPressed: () => Get.to(
                                      () => WebViewScreen(
                                    title: drugDiscountButtons[index].title,
                                    url: drugDiscountButtons[index].url,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                  }
                }),
          ),
        ),
      ),
    );
  }
}
