import 'package:angel_car/global/model/pricing_schema.dart';
import 'package:angel_car/global/model/product.dart';

class PlanItems {
  int? id;
  Product? product;
  PricingSchema? pricingSchema;
  Null cycles;///TODO: Verificar o tipo
  String? createdAt;
  String? updatedAt;

  PlanItems(
      {this.id,
      this.product,
      this.pricingSchema,
      this.cycles,
      this.createdAt,
      this.updatedAt});

  PlanItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    pricingSchema = json['pricing_schema'] != null
        ? PricingSchema.fromJson(json['pricing_schema'])
        : null;
    cycles = json['cycles'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (product != null) {
      data['product'] = product?.toJson();
    }
    if (pricingSchema != null) {
      data['pricing_schema'] = pricingSchema?.toJson();
    }
    data['cycles'] = cycles;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
