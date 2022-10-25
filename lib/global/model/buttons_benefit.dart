class ButtonsBenefit {
  bool? active;
  String? type;
  String? phone;
  String? email;
  String? url;

  ButtonsBenefit({this.active, this.type, this.phone, this.email, this.url});

  ButtonsBenefit.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    type = json['type'];
    phone = json['phone'];
    email = json['email'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['active'] = active;
    data['type'] = type;
    data['phone'] = phone;
    data['email'] = email;
    data['url'] = url;
    return data;
  }
}