import 'package:angel_car/global/model/buttons_home.dart';

class CardsHome {
  ButtonsHome? buttons;

  CardsHome({this.buttons});

  CardsHome.fromJson(Map<String, dynamic> json) {
    buttons =
    json['buttons'] != null ? ButtonsHome.fromJson(json['buttons']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (buttons != null) {
      data['buttons'] = buttons!.toJson();
    }
    return data;
  }
}