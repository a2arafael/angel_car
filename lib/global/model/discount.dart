class Discount {
  int? id;
  String? discountType;
  String? percentage;
  String? amount;
  int? quantity;
  int? cycles;

  Discount(
      {this.id,
      this.discountType,
      this.percentage,
      this.amount,
      this.quantity,
      this.cycles});

  Discount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    discountType = json['discount_type'];
    percentage = json['percentage'];
    amount = json['amount'];
    quantity = json['quantity'];
    cycles = json['cycles'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['discount_type'] = discountType;
    data['percentage'] = percentage;
    data['amount'] = amount;
    data['quantity'] = quantity;
    data['cycles'] = cycles;
    return data;
  }
}
