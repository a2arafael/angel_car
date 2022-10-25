import 'package:angel_car/global/model/subscription.dart';

class SubscriptionResponse {
  List<Subscription>? subscriptions;

  SubscriptionResponse({this.subscriptions});

  SubscriptionResponse.fromJson(Map<String, dynamic> json) {
    if (json['subscriptions'] != null) {
      subscriptions = [];
      json['subscriptions'].forEach((v) {
        subscriptions?.add(Subscription.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (subscriptions != null) {
      data['subscriptions'] =
          subscriptions?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
