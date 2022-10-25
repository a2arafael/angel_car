import 'package:angel_car/global/model/product.dart';

class ProductItem {
  int? id;
  Product? product;

  ProductItem({this.id, this.product});

  ProductItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (product != null) {
      data['product'] = product?.toJson();
    }
    return data;
  }
}
