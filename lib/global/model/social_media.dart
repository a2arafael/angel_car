import 'package:angel_car/global/model/buttons_social_media.dart';
import 'package:angel_car/global/model/social_media_data.dart';

class SocialMedia {
  List<ButtonsSocialMedia>? buttons;
  SocialMediaData? phone;
  SocialMediaData? email;

  SocialMedia({this.buttons, this.phone, this.email});

  SocialMedia.fromJson(Map<String, dynamic> json) {
    if (json['buttons'] != null) {
      buttons = <ButtonsSocialMedia>[];
      json['buttons'].forEach((v) {
        buttons!.add(ButtonsSocialMedia.fromJson(v));
      });
    }
    phone = json['phone'] != null ? SocialMediaData.fromJson(json['phone']) : null;
    email = json['email'] != null ? SocialMediaData.fromJson(json['email']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (buttons != null) {
      data['buttons'] = buttons!.map((v) => v.toJson()).toList();
    }
    if (phone != null) {
      data['phone'] = phone!.toJson();
    }
    if (email != null) {
      data['email'] = email!.toJson();
    }
    return data;
  }
}