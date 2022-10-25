import 'package:angel_car/global/model/bill.dart';

class BillResponse {
  List<Bill>? bills;
  BillResponse({this.bills});

  BillResponse.fromJson(Map<String, dynamic> json) {
    if (json['bills'] != null) {
      bills = [];
      json['bills'].forEach((v) {
        bills?.add(Bill.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bills != null) {
      data['bills'] = bills?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
