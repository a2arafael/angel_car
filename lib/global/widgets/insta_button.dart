import 'package:flutter/material.dart';
import 'package:angel_car/global/model/singleton.dart';
import 'package:angel_car/global/model/social_media.dart';
import 'package:url_launcher/url_launcher.dart';

Widget instaButton() {
  String? url;
  bool? active;
  SocialMedia? socialMedia = Singleton().getSocialMedia();
  socialMedia?.buttons?.forEach((element) {
    if(element.type == 'insta'){
      url = element.url;
      active = element.active;
    }
  });
  if(active == true){
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 4.0),
      child: GestureDetector(
        onTap: () {
          _launchUrl(Uri.parse("$url"));
        },
        child: Image.asset(
          'assets/images/ic_insta.png'
        ),
      ),
    );
  }else {
    return Container();
  }
}

Future<void> _launchUrl(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}