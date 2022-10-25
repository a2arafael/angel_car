class PricingRanges {
  String? id;
  int? startQuantity;
  int? endQuantity;
  int? price;
  int? overagePrice;

  PricingRanges(
      {this.id,
      this.startQuantity,
      this.endQuantity,
      this.price,
      this.overagePrice});

  PricingRanges.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startQuantity =
        json['start_quantity'];
    endQuantity = json['end_quantity'];
    price = json['price'];
    overagePrice = json['overage_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['start_quantity'] = startQuantity;
    data['end_quantity'] = endQuantity;
    data['price'] = price;
    data['overage_price'] = overagePrice;
    return data;
  }
}
