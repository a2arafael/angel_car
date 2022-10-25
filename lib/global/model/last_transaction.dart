import 'package:angel_car/global/model/gateway.dart';
import 'package:angel_car/global/model/gateway_Response_fields.dart';
import 'package:angel_car/global/model/payment_profile.dart';

class LastTransaction {
  int? id;
  String? transactionType;
  String? status;
  String? amount;
  int? installments;
  String? gatewayMessage;
  String? gatewayResponseCode;
  String? gatewayAuthorization;
  String? gatewayTransactionId;
  GatewayResponseFields? gatewayResponseFields;
  int? fraudDetectorScore;
  String? fraudDetectorStatus;
  String? fraudDetectorId;
  String? createdAt;
  Gateway? gateway;
  PaymentProfile? paymentProfile;

  LastTransaction(
      {this.id,
      this.transactionType,
      this.status,
      this.amount,
      this.installments,
      this.gatewayMessage,
      this.gatewayResponseCode,
      this.gatewayAuthorization,
      this.gatewayTransactionId,
      this.gatewayResponseFields,
      this.fraudDetectorScore,
      this.fraudDetectorStatus,
      this.fraudDetectorId,
      this.createdAt,
      this.gateway,
      this.paymentProfile});

  LastTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionType =
        json['transaction_type'];
    status = json['status'];
    amount = json['amount'];
    installments = json['installments'];
    gatewayMessage =
        json['gateway_message'];
    gatewayResponseCode = json['gateway_response_code'];
    gatewayAuthorization = json['gateway_authorization'];
    gatewayTransactionId = json['gateway_transaction_id'];
    fraudDetectorScore = json['fraud_detector_score'];
    fraudDetectorStatus = json['fraud_detector_status'];
    fraudDetectorId =
        json['fraud_detector_id'];
    createdAt = json['created_at'];
    gatewayResponseFields = json['gateway_response_fields'] != null
        ? GatewayResponseFields.fromJson(json['gateway_response_fields'])
        : null;
    gateway =
        json['gateway'] != null ? Gateway.fromJson(json['gateway']) : null;
    paymentProfile = json['payment_profile'] != null
        ? PaymentProfile.fromJson(json['payment_profile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['transaction_type'] = transactionType;
    data['status'] = status;
    data['amount'] = amount;
    data['installments'] = installments;
    data['gateway_message'] = gatewayMessage;
    data['gateway_response_code'] = gatewayResponseCode;
    data['gateway_authorization'] = gatewayAuthorization;
    data['gateway_transaction_id'] = gatewayTransactionId;
    data['gateway_response_fields'] = gatewayResponseFields;
    data['fraud_detector_score'] = fraudDetectorScore;
    data['fraud_detector_status'] = fraudDetectorStatus;
    data['fraud_detector_id'] = fraudDetectorId;
    data['created_at'] = createdAt;
    if (gateway != null) {
      data['gateway'] = gateway?.toJson();
    }
    if (paymentProfile != null) {
      data['payment_profile'] = paymentProfile?.toJson();
    }
    return data;
  }
}
