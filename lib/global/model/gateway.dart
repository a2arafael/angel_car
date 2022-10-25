class Gateway {
  int? id;
  String? connector;

  Gateway({this.id, this.connector});

  Gateway.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    connector = json['connector'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['connector'] = connector;
    return data;
  }
}
