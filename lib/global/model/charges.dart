import 'package:angel_car/global/model/last_transaction.dart';
import 'package:angel_car/global/model/payment_method.dart';

class Charges {
  int? id;
  String? amount;
  String? status;
  String? dueAt;
  String? paidAt;
  int? installments;
  int? attemptCount;
  String? nextAttempt;
  String? printUrl;
  String? createdAt;
  String? updatedAt;
  LastTransaction? lastTransaction;
  PaymentMethod? paymentMethod;

  Charges(
      {this.id,
      this.amount,
      this.status,
      this.dueAt,
      this.paidAt,
      this.installments,
      this.attemptCount,
      this.nextAttempt,
      this.printUrl,
      this.createdAt,
      this.updatedAt,
      this.lastTransaction,
      this.paymentMethod});

  Charges.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    status = json['status'];
    dueAt = json['due_at'];
    paidAt = json['paid_at'];
    installments = json['installments'];
    attemptCount = json['attempt_count'];
    nextAttempt = json['next_attempt'];
    printUrl = json['print_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    lastTransaction = json['last_transaction'] != null
        ? LastTransaction.fromJson(json['last_transaction'])
        : null;
    paymentMethod = json['payment_method'] != null
        ? PaymentMethod.fromJson(json['payment_method'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;
    data['status'] = status;
    data['due_at'] = dueAt;
    data['paid_at'] = paidAt;
    data['installments'] = installments;
    data['attempt_count'] = attemptCount;
    data['next_attempt'] = nextAttempt;
    data['print_url'] = printUrl;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (lastTransaction != null) {
      data['last_transaction'] = lastTransaction?.toJson();
    }
    if (paymentMethod != null) {
      data['payment_method'] = paymentMethod?.toJson();
    }
    return data;
  }
}
