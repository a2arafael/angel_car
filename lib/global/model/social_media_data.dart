class SocialMediaData{
  bool? active;
  String? type;
  String? value;

  SocialMediaData({this.active, this.type, this.value});

  SocialMediaData.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['active'] = active;
    data['type'] = type;
    data['value'] = value;
    return data;
  }
}