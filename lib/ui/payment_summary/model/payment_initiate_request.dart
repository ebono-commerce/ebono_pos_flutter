// To parse this JSON data, do
//
//     final paymentRequest = paymentRequestFromJson(jsonString);

import 'dart:convert';

PaymentRequest paymentRequestFromJson(dynamic str) =>
    PaymentRequest.fromJson(json.decode(str));

String paymentRequestToJson(PaymentRequest data) => json.encode(data.toJson());

class PaymentRequest {
  String? amount;
  String? externalRefNumber;
  String? customerName;
  String? customerEmail;
  String? customerMobileNumber;
  bool? isEmi;
  String? terminalId;
  String? username;
  String? appKey;
  PushTo? pushTo;

  PaymentRequest({
    this.amount,
    this.externalRefNumber,
    this.customerName,
    this.customerEmail,
    this.customerMobileNumber,
    this.isEmi,
    this.terminalId,
    this.username,
    this.appKey,
    this.pushTo,
  });

  factory PaymentRequest.fromJson(Map<String, dynamic> json) => PaymentRequest(
        amount: json["amount"],
        externalRefNumber: json["externalRefNumber"],
        customerName: json["customerName"],
        customerEmail: json["customerEmail"],
        customerMobileNumber: json["customerMobileNumber"],
        isEmi: json["is_emi"],
        terminalId: json["terminal_id"],
        username: json["username"],
        appKey: json["appKey"],
        pushTo: json["pushTo"] == null ? null : PushTo.fromJson(json["pushTo"]),
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "externalRefNumber": externalRefNumber,
        "customerName": customerName,
        "customerEmail": customerEmail,
        "customerMobileNumber": customerMobileNumber,
        "is_emi": isEmi,
        "terminal_id": terminalId,
        "username": username,
        "appKey": appKey,
        "pushTo": pushTo?.toJson(),
      };
}

class PushTo {
  String? deviceId;

  PushTo({
    this.deviceId,
  });

  factory PushTo.fromJson(Map<String, dynamic> json) => PushTo(
        deviceId: json["deviceId"],
      );

  Map<String, dynamic> toJson() => {
        "deviceId": deviceId,
      };
}
