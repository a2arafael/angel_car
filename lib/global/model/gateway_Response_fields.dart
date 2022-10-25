class GatewayResponseFields {
  String? stoneIdRcptTxId;

  GatewayResponseFields({this.stoneIdRcptTxId});

  GatewayResponseFields.fromJson(Map<String, dynamic> json) {
    stoneIdRcptTxId = json['stone_id_rcpt_tx_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stone_id_rcpt_tx_id'] = stoneIdRcptTxId;
    return data;
  }
}
