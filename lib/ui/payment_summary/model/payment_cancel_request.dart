// To parse this JSON data, do
//
//     final paymentCancelRequest = paymentCancelRequestFromJson(jsonString);

import 'dart:convert';

import 'package:ebono_pos/ui/payment_summary/model/payment_initiate_request.dart';

PaymentCancelRequest paymentCancelRequestFromJson(String str) =>
    PaymentCancelRequest.fromJson(json.decode(str));

String paymentCancelRequestToJson(PaymentCancelRequest data) =>
    json.encode(data.toJson());

class PaymentCancelRequest {
  String? username;
  String? appKey;
  String? origP2PRequestId;
  PushTo? pushTo;

  PaymentCancelRequest({
    this.username,
    this.appKey,
    this.origP2PRequestId,
    this.pushTo,
  });

  factory PaymentCancelRequest.fromJson(Map<String, dynamic> json) =>
      PaymentCancelRequest(
        username: json["username"],
        appKey: json["appKey"],
        origP2PRequestId: json["origP2pRequestId"],
        pushTo: json["pushTo"] == null ? null : PushTo.fromJson(json["pushTo"]),
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "appKey": appKey,
        "origP2pRequestId": origP2PRequestId,
        "pushTo": pushTo?.toJson(),
      };
}

