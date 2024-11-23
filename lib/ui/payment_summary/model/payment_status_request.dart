// To parse this JSON data, do
//
//     final paymentStatusRequest = paymentStatusRequestFromJson(jsonString);

import 'dart:convert';

PaymentStatusRequest paymentStatusRequestFromJson(String str) =>
    PaymentStatusRequest.fromJson(json.decode(str));

String paymentStatusRequestToJson(PaymentStatusRequest data) =>
    json.encode(data.toJson());

class PaymentStatusRequest {
  String? username;
  String? appKey;
  String? origP2PRequestId;

  PaymentStatusRequest({
    this.username,
    this.appKey,
    this.origP2PRequestId,
  });

  factory PaymentStatusRequest.fromJson(Map<String, dynamic> json) =>
      PaymentStatusRequest(
        username: json["username"],
        appKey: json["appKey"],
        origP2PRequestId: json["origP2pRequestId"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "appKey": appKey,
        "origP2pRequestId": origP2PRequestId,
      };
}
