import 'package:angel_car/global/model/address.dart';
import 'package:angel_car/global/model/metadata.dart';
import 'package:angel_car/global/model/phone.dart';

class Customer {
  int? id;
  String? name;
  String? email;
  String? registryCode;
  String? code;
  String? notes;
  String? status;
  String? createdAt;
  String? updatedAt;
  Metadata? metadata;
  Address? address;
  List<Phone>? phones;

  Customer(
      {this.id,
      this.name,
      this.email,
      this.registryCode,
      this.code,
      this.notes,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.metadata,
      this.address,
      this.phones});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    registryCode = json['registry_code'];
    code = json['code'];
    notes = json['notes'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    metadata = json['metadata'] != null
        ? Metadata.fromJson(json['metadata'])
        : null;
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    if (json['phones'] != null) {
      phones = [];
      json['phones'].forEach((v) {
        phones?.add(Phone.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['registry_code'] = registryCode;
    data['code'] = code;
    data['notes'] = notes;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (metadata != null) {
      data['metadata'] = metadata?.toJson();
    }
    if (address != null) {
      data['address'] = address?.toJson();
    }
    if (phones != null) {
      data['phones'] = phones?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
