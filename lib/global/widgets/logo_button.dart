import 'package:flutter/material.dart';
import 'package:angel_car/global/model/singleton.dart';
import 'package:angel_car/global/model/social_media.dart';
import 'package:url_launcher/url_launcher.dart';

Widget logoButton() {
  String? url;
  bool? active;
  SocialMedia? socialMedia = Singleton().getSocialMedia();
  socialMedia?.buttons?.forEach((element) {
    if(element.type == 'logo'){
      url = element.url;
      active = element.active;
    }
  });
  if(active == true){
    return GestureDetector(
      onTap: () {
        _launchUrl(Uri.parse("$url"));
      },
      child: Image.asset(
        'assets/images/logo.png',
        width: 40.0,
        fit: BoxFit.cover,
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