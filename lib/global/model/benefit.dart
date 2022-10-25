import 'package:angel_car/global/model/buttons_benefit.dart';

class Benefit {
  List<ButtonsBenefit>? buttons;
  String? description;
  String? description02;
  String? title;

  Benefit({this.buttons, this.description, this.description02, this.title});

  Benefit.fromJson(Map<String, dynamic> json) {
    if (json['buttons'] != null) {
      buttons = <ButtonsBenefit>[];
      json['buttons'].forEach((v) {
        buttons!.add(ButtonsBenefit.fromJson(v));
      });
    }
    description = json['description'];
    description02 = json['description02'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (buttons != null) {
      data['buttons'] = buttons!.map((v) => v.toJson()).toList();
    }
    data['description'] = description;
    data['description02'] = description02;
    data['title'] = title;
    return data;
  }
}
