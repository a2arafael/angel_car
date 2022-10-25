import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:angel_car/global/firebase/app_database.dart';
import 'package:angel_car/global/model/singleton.dart';
import 'package:angel_car/global/model/social_media.dart';
import 'package:angel_car/global/utils/app-colors.dart';
import 'package:angel_car/global/utils/app-text-styles.dart';
import 'package:angel_car/global/widgets/insta_button.dart';
import 'package:angel_car/global/widgets/logo_button.dart';
import 'package:angel_car/global/widgets/twitter_button.dart';
import 'package:angel_car/global/widgets/youtube_button.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:url_launcher/url_launcher.dart';

import 'face_button.dart';

Widget socialMediaButtons(BuildContext context){

  return StreamBuilder(
      stream: AppDatabase.getScreenStream(
          document: "socialMedia"),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            context.loaderOverlay.show();
            return Container();
          default:
            DocumentSnapshot documentSnapshot =
            snapshot.data as DocumentSnapshot;
            Map<String, dynamic> map = documentSnapshot
                .data() as Map<String, dynamic>;

            var socialMedia = SocialMedia.fromJson(map);
            Singleton().setSocialMedia(socialMedia);

            context.loaderOverlay.hide();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(
                  width: double.maxFinite,
                  height: 40.0,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: socialMedia.buttons?.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return socialMediaButton(
                            socialMedia.buttons?[index].type);
                      }),
                ),

                ///Telefone
                socialMedia.phone?.active == true ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      var url = Uri.parse(
                          "tel:${socialMedia.phone?.value?.replaceAll(' ', '')}");
                      _launchUrl(url);
                    },
                    child: Text(
                      'Central de Atendimento: ${socialMedia.phone?.value}',
                      style: AppTextStyles.robotoMedium(
                        size: 12.0,
                        color: AppColors.gray,
                      ),
                    ),
                  ),
                ): Container(),

                ///E-mail
                socialMedia.email?.active == true ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      var url = Uri.parse(
                          "mailto:${socialMedia.email?.value}?subject=Contato do aplicativo.");
                      _launchUrl(url);
                    },
                    child: Text(
                      'E-mail: ${socialMedia.email?.value}',
                      style: AppTextStyles.robotoMedium(
                        size: 12.0,
                        color: AppColors.gray,
                      ),
                    ),
                  ),
                ): Container(),
              ],
            );
        }
      });
}

Widget socialMediaButton(String? type) {
  switch (type) {
    case 'logo':
      return logoButton();
    case 'insta':
      return instaButton();
    case 'youtube':
      return youtubeButton();
    case 'face':
      return faceButton();
    case 'twitter':
      return twitterButton();
    default:
      return Container();
  }
}

Future<void> _launchUrl(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}