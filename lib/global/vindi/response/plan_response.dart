import 'package:angel_car/global/model/plan.dart';

class PlanResponse {
  List<Plan>? plans;

  PlanResponse({this.plans});

  PlanResponse.fromJson(Map<String, dynamic> json) {
    if (json['plans'] != null) {
      plans = [];
      json['plans'].forEach((v) {
        plans?.add(Plan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (plans != null) {
      data['plans'] = plans?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
