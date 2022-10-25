class Period {
  int? id;
  String? billingAt;
  int? cycle;
  String? startAt;
  String? endAt;
  int? duration;

  Period(
      {this.id,
      this.billingAt,
      this.cycle,
      this.startAt,
      this.endAt,
      this.duration});

  Period.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    billingAt = json['billing_at'];
    cycle = json['cycle'];
    startAt = json['start_at'];
    endAt = json['end_at'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['billing_at'] = billingAt;
    data['cycle'] = cycle;
    data['start_at'] = startAt;
    data['end_at'] = endAt;
    data['duration'] = duration;
    return data;
  }
}
