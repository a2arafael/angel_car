import 'package:angel_car/global/model/bill_items.dart';
import 'package:angel_car/global/model/charges.dart';
import 'package:angel_car/global/model/customer.dart';
import 'package:angel_car/global/model/metadata.dart';
import 'package:angel_car/global/model/payment_condition.dart';
import 'package:angel_car/global/model/payment_profile.dart';
import 'package:angel_car/global/model/period.dart';
import 'package:angel_car/global/model/subscription.dart';

class Bill {
  int? id;
  String? code;
  String? amount;
  int? installments;
  String? status;
  String? seenAt;
  String? billingAt;
  String? dueAt;
  String? url;
  String? createdAt;
  String? updatedAt;
  List<BillItems>? billItems;
  List<Charges>? charges;
  Customer? customer;
  Period? period;
  Subscription? subscription;
  Metadata? metadata;
  PaymentProfile? paymentProfile;
  PaymentCondition? paymentCondition;

  Bill({
    this.id,
    this.code,
    this.amount,
    this.installments,
    this.status,
    this.seenAt,
    this.billingAt,
    this.dueAt,
    this.url,
    this.createdAt,
    this.updatedAt,
    this.billItems,
    this.charges,
    this.customer,
    this.period,
    this.subscription,
    this.paymentProfile,
    this.paymentCondition,
  });

  Bill.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'] ?? "";
    amount = json['amount'];
    installments = json['installments'];
    status = json['status'];
    seenAt = json['seen_at'] ?? "";
    billingAt = json['billing_at'] ?? "";
    dueAt = json['due_at'];
    url = json['url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
    period =
        json['period'] != null ? Period.fromJson(json['period']) : null;
    subscription = json['subscription'] != null
        ? Subscription.fromJson(json['subscription'])
        : null;
    metadata = json['metadata'] != null
        ? Metadata.fromJson(json['metadata'])
        : null;
    paymentProfile = json['payment_profile'] != null
        ? PaymentProfile.fromJson(json['payment_profile'])
        : null;
    paymentCondition = json['payment_condition'] != null
        ? PaymentCondition.fromJson(json['payment_condition'])
        : null;
    if (json['bill_items'] != null) {
      billItems = [];
      json['bill_items'].forEach((v) {
        billItems?.add(BillItems.fromJson(v));
      });
    }
    if (json['charges'] != null) {
      charges = [];
      json['charges'].forEach((v) {
        charges?.add(Charges.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['amount'] = amount;
    data['installments'] = installments;
    data['status'] = status;
    data['seen_at'] = seenAt;
    data['billing_at'] = billingAt;
    data['due_at'] = dueAt;
    data['url'] = url;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (billItems != null) {
      data['bill_items'] = billItems?.map((v) => v.toJson()).toList();
    }
    if (charges != null) {
      data['charges'] = charges?.map((v) => v.toJson()).toList();
    }
    if (customer != null) {
      data['customer'] = customer?.toJson();
    }
    if (period != null) {
      data['period'] = period?.toJson();
    }
    if (subscription != null) {
      data['subscription'] = subscription?.toJson();
    }
    if (metadata != null) {
      data['metadata'] = metadata?.toJson();
    }
    if (paymentProfile != null) {
      data['payment_profile'] = paymentProfile?.toJson();
    }
    if (paymentCondition != null) {
      data['payment_condition'] = paymentCondition?.toJson();
    }
    return data;
  }
}
