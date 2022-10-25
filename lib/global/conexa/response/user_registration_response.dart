import 'package:angel_car/global/model/object.dart';

class UserRegistrationResponse {
  int? status;
  String? msg;
  Object? object;
  int? timestamp;

  UserRegistrationResponse({this.status, this.msg, this.object, this.timestamp});

  UserRegistrationResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    object = json['object'] != null ? Object.fromJson(json['object']) : null;
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['msg'] = msg;
    if (object != null) {
      data['object'] = object?.toJson();
    }
    data['timestamp'] = timestamp;
    return data;
  }
}