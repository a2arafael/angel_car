class Phone {
  int? id;
  String? phoneType;
  String? number;
  String? extension;

  Phone({this.id, this.phoneType, this.number, this.extension});

  Phone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneType = json['phone_type'];
    number = json['number'];
    extension = json['extension'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phone_type'] = phoneType;
    data['number'] = number;
    data['extension'] = extension;
    return data;
  }
}
