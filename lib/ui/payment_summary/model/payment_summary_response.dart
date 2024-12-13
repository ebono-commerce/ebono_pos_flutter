// To parse this JSON data, do
//
//     final paymentSummaryResponse = paymentSummaryResponseFromJson(jsonString);

import 'dart:convert';

PaymentSummaryResponse paymentSummaryResponseFromJson(str) => PaymentSummaryResponse.fromJson(json.decode(str));

String paymentSummaryResponseToJson(PaymentSummaryResponse data) => json.encode(data.toJson());

class PaymentSummaryResponse {
  String? cartId;
  DateTime? createdAt;
  String? cartType;
  dynamic? totalUnits;
  int? totalItems;
  AmountPayable? amountPayable;
  AmountPayable? mrpSavings;
  AmountPayable? taxTotal;
  AmountPayable? discountTotal;
  List<PaymentOption>? redeemablePaymentOptions;
  List<PaymentOption>? paymentOptions;

  PaymentSummaryResponse({
    this.cartId,
    this.createdAt,
    this.cartType,
    this.totalUnits,
    this.totalItems,
    this.amountPayable,
    this.mrpSavings,
    this.taxTotal,
    this.discountTotal,
    this.redeemablePaymentOptions,
    this.paymentOptions,
  });

  factory PaymentSummaryResponse.fromJson(Map<String, dynamic> json) => PaymentSummaryResponse(
    cartId: json["cart_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    cartType: json["cart_type"],
    totalUnits: json["total_units"]?.toDouble(),
    totalItems: json["total_items"],
    amountPayable: json["amount_payable"] == null ? null : AmountPayable.fromJson(json["amount_payable"]),
    mrpSavings: json["mrp_savings"] == null ? null : AmountPayable.fromJson(json["mrp_savings"]),
    taxTotal: json["tax_total"] == null ? null : AmountPayable.fromJson(json["tax_total"]),
    discountTotal: json["discount_total"] == null ? null : AmountPayable.fromJson(json["discount_total"]),
    redeemablePaymentOptions: json["redeemable_payment_options"] == null ? [] : List<PaymentOption>.from(json["redeemable_payment_options"]!.map((x) => PaymentOption.fromJson(x))),
    paymentOptions: json["payment_options"] == null ? [] : List<PaymentOption>.from(json["payment_options"]!.map((x) => PaymentOption.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "cart_id": cartId,
    "created_at": createdAt?.toIso8601String(),
    "cart_type": cartType,
    "total_units": totalUnits,
    "total_items": totalItems,
    "amount_payable": amountPayable?.toJson(),
    "mrp_savings": mrpSavings?.toJson(),
    "tax_total": taxTotal?.toJson(),
    "discount_total": discountTotal?.toJson(),
    "redeemable_payment_options": redeemablePaymentOptions == null ? [] : List<dynamic>.from(redeemablePaymentOptions!.map((x) => x.toJson())),
    "payment_options": paymentOptions == null ? [] : List<dynamic>.from(paymentOptions!.map((x) => x.toJson())),
  };
}

class AmountPayable {
  String? currency;
  int? centAmount;
  int? fraction;

  AmountPayable({
    this.currency,
    this.centAmount,
    this.fraction,
  });

  factory AmountPayable.fromJson(Map<String, dynamic> json) => AmountPayable(
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

class PaymentOption {
  String? paymentOptionId;
  String? code;
  String? pspId;
  Description? description;

  PaymentOption({
    this.paymentOptionId,
    this.code,
    this.pspId,
    this.description,
  });

  factory PaymentOption.fromJson(Map<String, dynamic> json) => PaymentOption(
    paymentOptionId: json["payment_option_id"],
    code: json["code"],
    pspId: json["psp_id"],
    description: json["description"] == null ? null : Description.fromJson(json["description"]),
  );

  Map<String, dynamic> toJson() => {
    "payment_option_id": paymentOptionId,
    "code": code,
    "psp_id": pspId,
    "description": description?.toJson(),
  };
}

class Description {
  String? label;
  String? text;

  Description({
    this.label,
    this.text,
  });

  factory Description.fromJson(Map<String, dynamic> json) => Description(
    label: json["label"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "text": text,
  };
}
