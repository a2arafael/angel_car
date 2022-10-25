import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:angel_car/global/firebase/app_database.dart';
import 'package:angel_car/global/model/benefit.dart';
import 'package:angel_car/global/model/buttons_benefit.dart';
import 'package:angel_car/global/utils/app-colors.dart';
import 'package:angel_car/global/utils/app-text-styles.dart';
import 'package:angel_car/global/widgets/app_bar_default.dart';
import 'package:angel_car/global/widgets/divider.dart';
import 'package:angel_car/global/widgets/social_media_buttons.dart';
import 'package:angel_car/ui/call_center/call_center.dart';
import 'package:angel_car/ui/home/widgets/card_default_home.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:url_launcher/url_launcher.dart';

class BenefitScreen extends StatefulWidget {
  final String title;
  final String document;

  const BenefitScreen({Key? key, required this.title, required this.document})
      : super(key: key);

  @override
  _BenefitScreenState createState() => _BenefitScreenState();
}

class _BenefitScreenState extends State<BenefitScreen> {
  ButtonsBenefit chatButton = ButtonsBenefit();
  ButtonsBenefit phoneButton = ButtonsBenefit();
  ButtonsBenefit emailButton = ButtonsBenefit();
  ButtonsBenefit siteButton = ButtonsBenefit();

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
            child: appBarDefault(widget.title)),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: StreamBuilder(
                stream: AppDatabase.getScreenStream(document: widget.document),
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
                      var benefit = Benefit.fromJson(map);
                      log("=====> Response Firebase <===== ${jsonEncode(map)}");
                      benefit.buttons?.forEach((element) {
                        if(element.type == 'chat'){
                          chatButton = element;
                        }else if(element.type == 'ligar'){
                          phoneButton = element;
                        }else if(element.type == 'email'){
                          emailButton = element;
                        }else if(element.type == 'site'){
                          siteButton = element;
                        }
                      });
                      context.loaderOverlay.hide();
                      return Column(
                        children: [
                          ///Título
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              benefit.description ?? '',
                              style: AppTextStyles.robotoRegular(
                                size: 18.0,
                                color: AppColors.gray,
                              ),
                            ),
                          ),
                          divider(AppColors.gray),

                          ///Subtitulo
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              benefit.description02 ?? '',
                              style: AppTextStyles.robotoRegular(
                                size: 16.0,
                                color: AppColors.gray,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Row(
                              children: [
                                chatButton.active == true ? Expanded(
                                  child: cardDefaultHome(
                                    image: 'assets/images/ic_chat.png',
                                    text: 'Chat',
                                    onPressed: () =>
                                        Get.to(() => const CallCenterScreen()),
                                  ),
                                ): Container(),
                                chatButton.active == true ? const SizedBox(
                                  width: 8.0,
                                ): Container(),
                                phoneButton.active == true ? Expanded(
                                  child: cardDefaultHome(
                                    image: 'assets/images/ic_phone.png',
                                    text: 'Ligar',
                                    onPressed: () {
                                      var url = Uri.parse("tel:${phoneButton.phone?.replaceAll(' ', '').replaceAll('-', '')}");
                                      _launchUrl(url);
                                    },
                                  ),
                                ): Container(),
                                phoneButton.active == true ? const SizedBox(
                                  width: 8.0,
                                ): Container(),
                                siteButton.active == true ? Expanded(
                                  child: cardDefaultHome(
                                    image: 'assets/images/ic_site.png',
                                    text: 'Site',
                                    onPressed: () {

                                      if(siteButton.url != null){
                                        var url = Uri.parse(siteButton.url!);
                                        _launchUrl(Uri.parse("$url"));
                                      }
                                    },
                                  ),
                                ): Container(),
                                siteButton.active == true ? const SizedBox(
                                  width: 8.0,
                                ): Container(),
                                emailButton.active == true ? Expanded(
                                  child: cardDefaultHome(
                                    image: 'assets/images/ic_email.png',
                                    text: 'E-mail',
                                    onPressed: () {
                                      var url = Uri.parse(
                                          "mailto:${emailButton.email}?subject=Contato do aplicativo.");
                                      _launchUrl(url);
                                    },
                                  ),
                                ): Container(),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 64.0,
                          ),

                          ///Botões rede social
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: socialMediaButtons(context),
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

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
