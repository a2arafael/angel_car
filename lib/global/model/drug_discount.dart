import 'package:angel_car/global/model/buttons_drug_discount.dart';

class DrugDiscount {
  List<ButtonsDrugDiscount>? buttons;
  String? description;

  DrugDiscount({this.buttons, this.description});

  DrugDiscount.fromJson(Map<String, dynamic> json) {
    if (json['buttons'] != null) {
      buttons = <ButtonsDrugDiscount>[];
      json['buttons'].forEach((v) {
        buttons!.add(ButtonsDrugDiscount.fromJson(v));
      });
    }
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (buttons != null) {
      data['buttons'] = buttons!.map((v) => v.toJson()).toList();
    }
    data['description'] = description;
    return data;
  }
}