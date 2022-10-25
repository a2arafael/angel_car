class Address {
  String? street;
  String? number;
  String? additionalDetails;
  String? zipcode;
  String? neighborhood;
  String? city;
  String? state;
  String? country;

  Address(
      {this.street,
      this.number,
      this.additionalDetails,
      this.zipcode,
      this.neighborhood,
      this.city,
      this.state,
      this.country});

  Address.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    number = json['number'];
    additionalDetails = json['additional_details'];
    zipcode = json['zipcode'];
    neighborhood = json['neighborhood'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['street'] = street;
    data['number'] = number;
    data['additional_details'] = additionalDetails;
    data['zipcode'] = zipcode;
    data['neighborhood'] = neighborhood;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    return data;
  }
}
