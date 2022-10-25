class CallCenter {
  String? phone;
  String? description;
  String? email;
  String? whatsappPhone;
  String? site;

  CallCenter(
      {this.phone,
        this.description,
        this.email,
        this.site,
        this.whatsappPhone});

  CallCenter.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    description = json['description'];
    email = json['email'];
    whatsappPhone = json['whatsappPhone'];
    site = json['site'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone'] = phone;
    data['description'] = description;
    data['email'] = email;
    data['whatsappPhone'] = whatsappPhone;
    data['site'] = site;
    return data;
  }
}