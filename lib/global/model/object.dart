import 'package:angel_car/global/conexa/response/holder_response.dart';

class Object {
  HolderResponse? holder;

  Object({
    this.holder,
  });

  Object.fromJson(Map<String, dynamic> json) {
    holder = json['holder'] != null
        ? HolderResponse.fromJson(json['holder'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (holder != null) {
      data['holder'] = holder?.toJson();
    }
    return data;
  }
}
