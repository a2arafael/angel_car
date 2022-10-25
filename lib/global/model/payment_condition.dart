import 'package:angel_car/global/model/payment_condition_discounts.dart';

class PaymentCondition {
  String? penaltyFeeValue;
  String? dailyFeeValue;
  int? afterDueDays;
  String? dailyFeeType;
  String? penaltyFeeType;

  List<PaymentConditionDiscounts>? paymentConditionDiscounts;

  PaymentCondition(
      {this.penaltyFeeValue,
      this.penaltyFeeType,
      this.dailyFeeValue,
      this.dailyFeeType,
      this.afterDueDays,
      this.paymentConditionDiscounts});

  PaymentCondition.fromJson(Map<String, dynamic> json) {
    penaltyFeeValue =
        json['penalty_fee_value'];
    penaltyFeeType =
        json['penalty_fee_type'];
    dailyFeeValue =
        json['daily_fee_value'];
    dailyFeeType =
        json['daily_fee_type'];
    afterDueDays =
        json['after_due_days'];
    if (json['payment_condition_discounts'] != null) {
      paymentConditionDiscounts = [];
      json['payment_condition_discounts'].forEach((v) {
        paymentConditionDiscounts
            ?.add(PaymentConditionDiscounts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['penalty_fee_value'] = penaltyFeeValue;
    data['penalty_fee_type'] = penaltyFeeType;
    data['daily_fee_value'] = dailyFeeValue;
    data['daily_fee_type'] = dailyFeeType;
    data['after_due_days'] = afterDueDays;
    if (paymentConditionDiscounts != null) {
      data['payment_condition_discounts'] =
          paymentConditionDiscounts?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
