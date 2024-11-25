// To parse this JSON data, do
//
//     final registerCloseRequest = registerCloseRequestFromJson(jsonString);

import 'dart:convert';

RegisterCloseRequest registerCloseRequestFromJson(dynamic str) =>
    RegisterCloseRequest.fromJson(json.decode(str));

String registerCloseRequestToJson(RegisterCloseRequest data) =>
    json.encode(data.toJson());

class RegisterCloseRequest {
  String? outletId;
  String? registerId;
  String? terminalId;
  String? userId;
  CashTransactionSummary? cashTransactionSummary;
  TransactionSummary? cardTransactionSummary;
  TransactionSummary? upiTransactionSummary;

  RegisterCloseRequest({
    this.outletId,
    this.registerId,
    this.terminalId,
    this.userId,
    this.cashTransactionSummary,
    this.cardTransactionSummary,
    this.upiTransactionSummary,
  });

  factory RegisterCloseRequest.fromJson(Map<String, dynamic> json) =>
      RegisterCloseRequest(
        outletId: json["outlet_id"],
        registerId: json["register_id"],
        terminalId: json["terminal_id"],
        userId: json["user_id"],
        cashTransactionSummary: json["cash_transaction_summary"] == null
            ? null
            : CashTransactionSummary.fromJson(json["cash_transaction_summary"]),
        cardTransactionSummary: json["card_transaction_summary"] == null
            ? null
            : TransactionSummary.fromJson(json["card_transaction_summary"]),
        upiTransactionSummary: json["upi_transaction_summary"] == null
            ? null
            : TransactionSummary.fromJson(json["upi_transaction_summary"]),
      );

  Map<String, dynamic> toJson() => {
        "outlet_id": outletId,
        "register_id": registerId,
        "terminal_id": terminalId,
        "user_id": userId,
        "cash_transaction_summary": cashTransactionSummary?.toJson(),
        "card_transaction_summary": cardTransactionSummary?.toJson(),
        "upi_transaction_summary": upiTransactionSummary?.toJson(),
      };
}

class TransactionSummary {
  int? chargeSlipCount;
  Amount? amount;

  TransactionSummary({
    this.chargeSlipCount,
    this.amount,
  });

  factory TransactionSummary.fromJson(Map<String, dynamic> json) =>
      TransactionSummary(
        chargeSlipCount: json["charge_slip_count"],
        amount: json["amount"] == null ? null : Amount.fromJson(json["amount"]),
      );

  Map<String, dynamic> toJson() => {
        "charge_slip_count": chargeSlipCount,
        "amount": amount?.toJson(),
      };
}

class Amount {
  String? currency;
  int? centAmount;
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

class CashTransactionSummary {
  Amount? amount;

  CashTransactionSummary({
    this.amount,
  });

  factory CashTransactionSummary.fromJson(Map<String, dynamic> json) =>
      CashTransactionSummary(
        amount: json["amount"] == null ? null : Amount.fromJson(json["amount"]),
      );

  Map<String, dynamic> toJson() => {
        "amount": amount?.toJson(),
      };
}
