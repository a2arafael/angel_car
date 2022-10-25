import 'package:angel_car/global/model/payment_company.dart';

class PaymentProfile {
  int? id;
  String? holderName;
  String? registryCode;
  String? bankBranch;
  String? bankAccount;
  String? cardExpiration;
  bool? allowAsFallback;
  bool? invoiceSplit;
  String? cardNumberFirstSix;
  String? cardNumberLastFour;
  String? token;
  String? createdAt;

  PaymentCompany? paymentCompany;

  PaymentProfile(
      {this.id,
      this.holderName,
      this.registryCode,
      this.bankBranch,
      this.bankAccount,
      this.cardExpiration,
      this.allowAsFallback,
      this.cardNumberFirstSix,
      this.cardNumberLastFour,
      this.token,
      this.createdAt,
      this.paymentCompany});

  PaymentProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    holderName = json['holder_name'];
    registryCode = json['registry_code'];
    bankBranch = json['bank_branch'];
    bankAccount = json['bank_account'];
    cardExpiration =
        json['card_expiration'];
    allowAsFallback =
        json['allow_as_fallback'];
    invoiceSplit = json['invoice_split'];
    cardNumberFirstSix = json['card_number_first_six'];
    cardNumberLastFour = json['card_number_last_four'];
    token = json['token'];
    createdAt = json['created_at'];
    paymentCompany = json['payment_company'] != null
        ? PaymentCompany.fromJson(json['payment_company'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['holder_name'] = holderName;
    data['registry_code'] = registryCode;
    data['bank_branch'] = bankBranch;
    data['bank_account'] = bankAccount;
    data['card_expiration'] = cardExpiration;
    data['allow_as_fallback'] = allowAsFallback;
    data['invoice_split'] = invoiceSplit;
    data['card_number_first_six'] = cardNumberFirstSix;
    data['card_number_last_four'] = cardNumberLastFour;
    data['token'] = token;
    data['created_at'] = createdAt;
    if (paymentCompany != null) {
      data['payment_company'] = paymentCompany?.toJson();
    }
    return data;
  }
}
