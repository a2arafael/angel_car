class ButtonsSocialMedia {
  bool? active;
  String? type;
  String? url;

  ButtonsSocialMedia({this.active, this.type, this.url});

  ButtonsSocialMedia.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    type = json['type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['active'] = active;
    data['type'] = type;
    data['url'] = url;
    return data;
  }
}