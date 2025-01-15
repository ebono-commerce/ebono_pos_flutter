// To parse this JSON data, do
//
//     final walletChargeRequest = walletChargeRequestFromJson(jsonString);

import 'dart:convert';

WalletChargeRequest walletChargeRequestFromJson(String str) => WalletChargeRequest.fromJson(json.decode(str));

String walletChargeRequestToJson(WalletChargeRequest data) => json.encode(data.toJson());

class WalletChargeRequest {
  String? phoneNumber;
  String? otp;
  Amount? amount;

  WalletChargeRequest({
    this.phoneNumber,
    this.otp,
    this.amount,
  });

  factory WalletChargeRequest.fromJson(Map<String, dynamic> json) => WalletChargeRequest(
    phoneNumber: json["phone_number"],
    otp: json["otp"],
    amount: json["amount"] == null ? null : Amount.fromJson(json["amount"]),
  );

  Map<String, dynamic> toJson() => {
    "phone_number": phoneNumber,
    "otp": otp,
    "amount": amount?.toJson(),
  };
}

class Amount {
  String? currency;
  double? centAmount;
  int? fraction;

  Amount({
    this.currency,
    this.centAmount,
    this.fraction,
  });

  factory Amount.fromJson(Map<String, dynamic> json) => Amount(
    currency: json["currency"],
    centAmount: json["cent_amount"],
    fraction: json["fraction"],
  );

  Map<String, dynamic> toJson() => {
    "currency": currency,
    "cent_amount": centAmount,
    "fraction": fraction,
  };
}
