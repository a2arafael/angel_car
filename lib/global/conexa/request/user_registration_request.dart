import 'package:angel_car/global/conexa/response/holder_response.dart';

class UserRegistrationRequest {
  HolderResponse? holder;

  UserRegistrationRequest({
    this.holder,
  });

  UserRegistrationRequest.fromJson(Map<String, dynamic> json) {
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
