class PaymentConditionDiscounts {
  int? value;
  int? valueType;
  int? daysBeforeDue;

  PaymentConditionDiscounts({this.value, this.valueType, this.daysBeforeDue});

  PaymentConditionDiscounts.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    valueType = json['value_type'];
    daysBeforeDue = json['days_before_due'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['value_type'] = valueType;
    data['days_before_due'] = daysBeforeDue;
    return data;
  }
}
