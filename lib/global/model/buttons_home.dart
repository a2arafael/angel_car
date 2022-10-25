import 'package:angel_car/global/model/card_destaque.dart';
import 'package:angel_car/global/model/card_padrao.dart';

class ButtonsHome {
  CardDestaque? cardDestaque;
  CardPadrao? cardPadrao;

  ButtonsHome({this.cardDestaque, this.cardPadrao});

  ButtonsHome.fromJson(Map<String, dynamic> json) {
    cardDestaque = json['card_destaque'] != null
        ? CardDestaque.fromJson(json['card_destaque'])
        : null;
    cardPadrao = json['card_padrão'] != null
        ? CardPadrao.fromJson(json['card_padrão'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cardDestaque != null) {
      data['card_destaque'] = cardDestaque!.toJson();
    }
    if (cardPadrao != null) {
      data['card_padrão'] = cardPadrao!.toJson();
    }
    return data;
  }
}
