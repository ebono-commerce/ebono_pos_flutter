// To parse this JSON data, do
//
//     final paytmInitiateChecksumRequest = paytmInitiateChecksumRequestFromJson(jsonString);

import 'dart:convert';

import 'package:ebono_pos/ui/payment_summary/model/payment_summary_response.dart';

PaytmInitiateChecksumRequest paytmInitiateChecksumRequestFromJson(str) => PaytmInitiateChecksumRequest.fromJson(json.decode(str));

String paytmInitiateChecksumRequestToJson(PaytmInitiateChecksumRequest data) => json.encode(data.toJson());

class PaytmInitiateChecksumRequest {
  String? outletId;
  String? terminalId;
  String? cartId;
  AmountPayable? amount;

  PaytmInitiateChecksumRequest({
    this.outletId,
    this.terminalId,
    this.cartId,
    this.amount,
  });

  factory PaytmInitiateChecksumRequest.fromJson(Map<String, dynamic> json) => PaytmInitiateChecksumRequest(
    outletId: json["outlet_id"],
    terminalId: json["terminal_id"],
    cartId: json["cart_id"],
    amount: json["amount"] == null ? null : AmountPayable.fromJson(json["amount"]),
  );

  Map<String, dynamic> toJson() => {
    "outlet_id": outletId,
    "terminal_id": terminalId,
    "cart_id": cartId,
    "amount": amount?.toJson(),
  };
}
