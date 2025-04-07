// To parse this JSON data, do
//
//     final registerCloseRequest = registerCloseRequestFromJson(jsonString);

import 'dart:convert';

RegisterCloseRequest registerCloseRequestFromJson(str) =>
    RegisterCloseRequest.fromJson(json.decode(str));

String registerCloseRequestToJson(RegisterCloseRequest data) =>
    json.encode(data.toJson());

class RegisterCloseRequest {
  String? outletId;
  String? registerId;
  String? registerTransactionId;
  String? terminalId;
  String? userId;
  List<TransactionSummary>? transactionSummary;

  RegisterCloseRequest({
    this.outletId,
    this.registerId,
    this.registerTransactionId,
    this.terminalId,
    this.userId,
    this.transactionSummary,
  });

  factory RegisterCloseRequest.fromJson(Map<String, dynamic> json) =>
      RegisterCloseRequest(
        outletId: json["outlet_id"],
        registerId: json["register_id"],
        registerTransactionId: json["register_transaction_id"],
        terminalId: json["terminal_id"],
        userId: json["user_id"],
        transactionSummary: json["transaction_summary"] == null
            ? []
            : List<TransactionSummary>.from(json["transaction_summary"]!
                .map((x) => TransactionSummary.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "outlet_id": outletId,
        "register_id": registerId,
        "register_transaction_id": registerTransactionId,
        "terminal_id": terminalId,
        "user_id": userId,
        "transaction_summary": transactionSummary == null
            ? []
            : List<dynamic>.from(transactionSummary!.map((x) => x.toJson())),
      };
}

class TransactionSummary {
  String? paymentOptionId;
  String? paymentOptionCode;
  String? pspId;
  String? pspName;
  int? chargeSlipCount;
  TotalTransactionAmount? totalTransactionAmount;

  TransactionSummary({
    this.paymentOptionId,
    this.paymentOptionCode,
    this.pspId,
    this.pspName,
    this.chargeSlipCount,
    this.totalTransactionAmount,
  });

  factory TransactionSummary.fromJson(Map<String, dynamic> json) =>
      TransactionSummary(
        paymentOptionId: json["payment_option_id"],
        paymentOptionCode: json["payment_option_code"],
        pspId: json["psp_id"],
        pspName: json["psp_name"],
        chargeSlipCount:
            json["charge_slip_count"] ?? json["total_transaction_count"],
        totalTransactionAmount: json["total_transaction_amount"] == null
            ? null
            : TotalTransactionAmount.fromJson(json["total_transaction_amount"]),
      );

  Map<String, dynamic> toJson() => {
        "payment_option_id": paymentOptionId,
        "payment_option_code": paymentOptionCode,
        "psp_id": pspId,
        "psp_name": pspName,
        if (chargeSlipCount != null) "charge_slip_count": chargeSlipCount,
        "total_transaction_amount": totalTransactionAmount?.toJson(),
      };
}

class TotalTransactionAmount {
  String? currency;
  int? centAmount;
  int? fraction;

  TotalTransactionAmount({
    this.currency,
    this.centAmount,
    this.fraction,
  });

  factory TotalTransactionAmount.fromJson(Map<String, dynamic> json) =>
      TotalTransactionAmount(
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
