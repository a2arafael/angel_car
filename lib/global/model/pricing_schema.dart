import 'package:angel_car/global/model/pricing_ranges.dart';

class PricingSchema {
  int? id;
  String? shortFormat;
  String? price;
  int? minimumPrice;
  String? schemaType;
  List<PricingRanges>? pricingRanges;
  String? createdAt;

  PricingSchema(
      {this.id,
      this.shortFormat,
      this.price,
      this.minimumPrice,
      this.schemaType,
      this.pricingRanges,
      this.createdAt});

  PricingSchema.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shortFormat = json['short_format'];
    price = json['price'];
    minimumPrice = json['minimum_price'];
    schemaType = json['schema_type'];
    createdAt = json['created_at'];
    if (json['pricing_ranges'] != null) {
      pricingRanges = [];
      json['pricing_ranges'].forEach((v) {
        pricingRanges?.add(PricingRanges.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['short_format'] = shortFormat;
    data['price'] = price;
    data['minimum_price'] = minimumPrice;
    data['schema_type'] = schemaType;
    if (pricingRanges != null) {
      data['pricing_ranges'] =
          pricingRanges?.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    return data;
  }
}
