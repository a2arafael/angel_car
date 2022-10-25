import 'package:angel_car/global/model/discount.dart';
import 'package:angel_car/global/model/pricing_schema.dart';
import 'package:angel_car/global/model/product.dart';
import 'package:angel_car/global/model/product_item.dart';

class BillItems {
  int? id;
  String? amount;
  int? quantity;
  int? pricingRangeId;
  String? description;
  PricingSchema? pricingSchema;
  Product? product;
  ProductItem? productItem;
  Discount? discount;

  BillItems(
      {this.id,
      this.amount,
      this.quantity,
      this.pricingRangeId,
      this.description,
      this.pricingSchema,
      this.product,
      this.productItem,
      this.discount});

  BillItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    quantity = json['quantity'];
    pricingRangeId =
        json['pricing_range_id'];
    description = json['description'];
    pricingSchema = json['pricing_schema'] != null
        ? PricingSchema.fromJson(json['pricing_schema'])
        : null;
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    productItem = json['product_item'] != null
        ? ProductItem.fromJson(json['product_item'])
        : null;
    discount = json['discount'] != null
        ? Discount.fromJson(json['discount'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;
    data['quantity'] = quantity;
    data['pricing_range_id'] = pricingRangeId;
    data['description'] = description;
    if (pricingSchema != null) {
      data['pricing_schema'] = pricingSchema?.toJson();
    }
    if (product != null) {
      data['product'] = product?.toJson();
    }
    if (productItem != null) {
      data['product_item'] = productItem?.toJson();
    }
    if (discount != null) {
      data['discount'] = discount?.toJson();
    }
    return data;
  }
}
