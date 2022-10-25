import 'package:angel_car/global/model/customer.dart';

class CustomerResponse {
  List<Customer>? customers;

  CustomerResponse({this.customers});

  CustomerResponse.fromJson(Map<String, dynamic> json) {
    if (json['customers'] != null) {
      customers = [];
      json['customers'].forEach((v) {
        customers?.add(Customer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (customers != null) {
      data['customers'] = customers?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
