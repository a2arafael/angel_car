import 'package:angel_car/global/model/current_period.dart';
import 'package:angel_car/global/model/customer.dart';
import 'package:angel_car/global/model/metadata.dart';
import 'package:angel_car/global/model/payment_method.dart';
import 'package:angel_car/global/model/payment_profile.dart';
import 'package:angel_car/global/model/plan.dart';
import 'package:angel_car/global/model/product_item.dart';

class Subscription {
  int? id;
  String? status;
  String? startAt;
  String? endAt;
  String? nextBillingAt;
  String? overdueSince;
  String? code;
  String? cancelAt;
  String? interval;
  int? intervalCount;
  String? billingTriggerType;
  int? billingTriggerDay;
  int? billingCycles;
  int? installments;
  String? createdAt;
  String? updatedAt;
  Customer? customer;
  Plan? plan;
  List<ProductItem>? productItems;
  PaymentMethod? paymentMethod;
  CurrentPeriod? currentPeriod;
  Metadata? metadata;
  PaymentProfile? paymentProfile;
  bool? invoiceSplit;

  Subscription(
      {this.id,
      this.status,
      this.startAt,
      this.endAt,
      this.nextBillingAt,
      this.overdueSince,
      this.code,
      this.cancelAt,
      this.interval,
      this.intervalCount,
      this.billingTriggerType,
      this.billingTriggerDay,
      this.billingCycles,
      this.installments,
      this.createdAt,
      this.updatedAt,
      this.customer,
      this.plan,
      this.productItems,
      this.paymentMethod,
      this.currentPeriod,
      this.metadata,
      this.paymentProfile,
      this.invoiceSplit});

  Subscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    startAt = json['start_at'];
    endAt = json['end_at'];
    nextBillingAt =
        json['next_billing_at'];
    overdueSince = json['overdue_since'];
    code = json['code'];
    cancelAt = json['cancel_at'];
    interval = json['interval'];
    intervalCount =
        json['interval_count'];
    billingTriggerType = json['billing_trigger_type'];
    billingTriggerDay = json['billing_trigger_day'];
    billingCycles =
        json['billing_cycles'];
    installments = json['installments'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    invoiceSplit = json['invoice_split'];
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
    plan = json['plan'] != null ? Plan.fromJson(json['plan']) : null;
    paymentMethod = json['payment_method'] != null
        ? PaymentMethod.fromJson(json['payment_method'])
        : null;
    currentPeriod = json['current_period'] != null
        ? CurrentPeriod.fromJson(json['current_period'])
        : null;
    metadata = json['metadata'] != null
        ? Metadata.fromJson(json['metadata'])
        : null;
    if (json['product_items'] != null) {
      productItems = [];
      json['product_items'].forEach((v) {
        productItems?.add(ProductItem.fromJson(v));
      });
    }
    if (json['payment_profile'] != null) {
      PaymentProfile.fromJson(json['payment_profile']);
    }
    /*paymentProfile = json['payment_profile'] != null
        ? new PaymentProfile.fromJson(json['payment_profile'])
        : null;*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['start_at'] = startAt;
    data['end_at'] = endAt;
    data['next_billing_at'] = nextBillingAt;
    data['overdue_since'] = overdueSince;
    data['code'] = code;
    data['cancel_at'] = cancelAt;
    data['interval'] = interval;
    data['interval_count'] = intervalCount;
    data['billing_trigger_type'] = billingTriggerType;
    data['billing_trigger_day'] = billingTriggerDay;
    data['billing_cycles'] = billingCycles;
    data['installments'] = installments;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['payment_profile'] = paymentProfile;
    data['invoice_split'] = invoiceSplit;
    if (customer != null) {
      data['customer'] = customer?.toJson();
    }
    if (plan != null) {
      data['plan'] = plan?.toJson();
    }
    if (productItems != null) {
      data['product_items'] = productItems?.map((v) => v.toJson()).toList();
    }
    if (paymentMethod != null) {
      data['payment_method'] = paymentMethod?.toJson();
    }
    if (currentPeriod != null) {
      data['current_period'] = currentPeriod?.toJson();
    }
    if (metadata != null) {
      data['metadata'] = metadata?.toJson();
    }
    return data;
  }
}
