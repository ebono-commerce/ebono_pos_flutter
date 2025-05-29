// To parse this JSON data, do
//
//     final paytmStatusChecksumRequest = paytmStatusChecksumRequestFromJson(jsonString);

import 'dart:convert';

PaytmStatusChecksumRequest paytmStatusChecksumRequestFromJson(str) => PaytmStatusChecksumRequest.fromJson(json.decode(str));

String paytmStatusChecksumRequestToJson(PaytmStatusChecksumRequest data) => json.encode(data.toJson());

class PaytmStatusChecksumRequest {
  String? outletId;
  String? terminalId;
  String? requestId;
  String? cartId;

  PaytmStatusChecksumRequest({
    this.outletId,
    this.terminalId,
    this.requestId,
    this.cartId,
  });

  factory PaytmStatusChecksumRequest.fromJson(Map<String, dynamic> json) => PaytmStatusChecksumRequest(
    outletId: json["outlet_id"],
    terminalId: json["terminal_id"],
    requestId: json["request_id"],
    cartId: json["cart_id"],
  );

  Map<String, dynamic> toJson() => {
    "outlet_id": outletId,
    "terminal_id": terminalId,
    "request_id": requestId,
    "cart_id": cartId,
  };
}
