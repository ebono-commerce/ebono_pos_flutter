// To parse this JSON data, do
//
//     final paymentInitiateResponse = paymentInitiateResponseFromJson(jsonString);

import 'dart:convert';

PaymentInitiateResponse paymentInitiateResponseFromJson(String str) =>
    PaymentInitiateResponse.fromJson(json.decode(str));

String paymentInitiateResponseToJson(PaymentInitiateResponse data) =>
    json.encode(data.toJson());

class PaymentInitiateResponse {
  bool? success;
  dynamic messageCode;
  String? message;
  String? errorCode;
  String? errorMessage;
  String? realCode;
  dynamic apiMessageTitle;
  dynamic apiMessage;
  dynamic apiMessageText;
  dynamic apiWarning;
  String? p2PRequestId;

  PaymentInitiateResponse({
    this.success,
    this.messageCode,
    this.message,
    this.errorCode,
    this.errorMessage,
    this.realCode,
    this.apiMessageTitle,
    this.apiMessage,
    this.apiMessageText,
    this.apiWarning,
    this.p2PRequestId,
  });

  factory PaymentInitiateResponse.fromJson(Map<String, dynamic> json) =>
      PaymentInitiateResponse(
        success: json["success"],
        messageCode: json["messageCode"],
        message: json["message"],
        errorCode: json["errorCode"],
        errorMessage: json["errorMessage"],
        realCode: json["realCode"],
        apiMessageTitle: json["apiMessageTitle"],
        apiMessage: json["apiMessage"],
        apiMessageText: json["apiMessageText"],
        apiWarning: json["apiWarning"],
        p2PRequestId: json["p2pRequestId"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "messageCode": messageCode,
        "message": message,
        "errorCode": errorCode,
        "errorMessage": errorMessage,
        "realCode": realCode,
        "apiMessageTitle": apiMessageTitle,
        "apiMessage": apiMessage,
        "apiMessageText": apiMessageText,
        "apiWarning": apiWarning,
        "p2pRequestId": p2PRequestId,
      };
}
