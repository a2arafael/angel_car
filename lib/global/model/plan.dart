import 'package:angel_car/global/model/metadata.dart';
import 'package:angel_car/global/model/plan_items.dart';

class Plan {
  int? id;
  String? name;
  String? interval;
  int? intervalCount;
  String? billingTriggerType;
  int? billingTriggerDay;
  int? billingCycles;
  String? code;
  String? description;
  String? status;
  int? installments;
  bool? invoiceSplit;
  String? intervalName;
  String? createdAt;
  String? updatedAt;
  List<PlanItems>? planItems;
  Metadata? metadata;

  Plan(
      {this.id,
      this.name,
      this.interval,
      this.intervalCount,
      this.billingTriggerType,
      this.billingTriggerDay,
      this.billingCycles,
      this.code,
      this.description,
      this.status,
      this.installments,
      this.invoiceSplit,
      this.intervalName,
      this.createdAt,
      this.updatedAt,
      this.planItems,
      this.metadata});

  Plan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    interval = json['interval'];
    intervalCount = json['interval_count'];
    billingTriggerType = json['billing_trigger_type'];
    billingTriggerDay = json['billing_trigger_day'];
    billingCycles = json['billing_cycles'];
    code = json['code'];
    description = json['description'];
    status = json['status'];
    installments = json['installments'];
    invoiceSplit = json['invoice_split'];
    intervalName = json['interval_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['plan_items'] != null) {
      planItems = [];
      json['plan_items'].forEach((v) {
        planItems?.add(PlanItems.fromJson(v));
      });
    }
    metadata = json['metadata'] != null
        ? Metadata.fromJson(json['metadata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['interval'] = interval;
    data['interval_count'] = intervalCount;
    data['billing_trigger_type'] = billingTriggerType;
    data['billing_trigger_day'] = billingTriggerDay;
    data['billing_cycles'] = billingCycles;
    data['code'] = code;
    data['description'] = description;
    data['status'] = status;
    data['installments'] = installments;
    data['invoice_split'] = invoiceSplit;
    data['interval_name'] = intervalName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (planItems != null) {
      data['plan_items'] = planItems?.map((v) => v.toJson()).toList();
    }
    if (metadata != null) {
      data['metadata'] = metadata?.toJson();
    }
    return data;
  }
}
