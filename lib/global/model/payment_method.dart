class PaymentMethod {
  int? id;
  String? publicName;
  String? name;
  String? code;
  String? type;

  PaymentMethod({this.id, this.publicName, this.name, this.code, this.type});

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    publicName = json['public_name'];
    name = json['name'];
    code = json['code'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['public_name'] = publicName;
    data['name'] = name;
    data['code'] = code;
    data['type'] = type;
    return data;
  }
}
