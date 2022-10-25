class ButtonsDrugDiscount {
  bool? active;
  String? image;
  String? title;
  String? url;

  ButtonsDrugDiscount({this.active, this.image, this.title, this.url});

  ButtonsDrugDiscount.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    image = json['image'];
    title = json['title'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['active'] = active;
    data['image'] = image;
    data['title'] = title;
    data['url'] = url;
    return data;
  }
}