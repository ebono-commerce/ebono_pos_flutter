// To parse this JSON data, do
//
//     final paymentSummaryResponse = paymentSummaryResponseFromJson(jsonString);

import 'dart:convert';

PaymentSummaryResponse paymentSummaryResponseFromJson(str) => PaymentSummaryResponse.fromJson(json.decode(str));

String paymentSummaryResponseToJson(PaymentSummaryResponse data) => json.encode(data.toJson());

class PaymentSummaryResponse {
  String? cartId;
  String? orderNumber;
  String? invoiceNumber;
  DateTime? createdAt;
  String? cartType;
  dynamic totalUnits;
  int? totalItems;
  AmountPayable? itemTotal;
  AmountPayable? amountPayable;
  AmountPayable? mrpSavings;
  AmountPayable? totalSavings;
  AmountPayable? taxTotal;
  AmountPayable? discountTotal;
  AmountPayable? redeemedWalletAmount;
  List<RedeemablePaymentOption>? redeemablePaymentOptions;
  List<PaymentOption>? paymentOptions;

  PaymentSummaryResponse({
    this.cartId,
    this.orderNumber,
    this.invoiceNumber,
    this.createdAt,
    this.cartType,
    this.totalUnits,
    this.totalItems,
    this.itemTotal,
    this.amountPayable,
    this.mrpSavings,
    this.totalSavings,
    this.taxTotal,
    this.discountTotal,
    this.redeemedWalletAmount,
    this.redeemablePaymentOptions,
    this.paymentOptions,
  });

  factory PaymentSummaryResponse.fromJson(Map<String, dynamic> json) => PaymentSummaryResponse(
    cartId: json["cart_id"],
    orderNumber: json["order_number"],
    invoiceNumber: json["invoice_number"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    cartType: json["cart_type"],
    totalUnits: json["total_units"]?.toDouble(),
    totalItems: json["total_items"],
    itemTotal: json["item_total"]  == null ? null : AmountPayable.fromJson(json["item_total"]),
    amountPayable: json["amount_payable"] == null ? null : AmountPayable.fromJson(json["amount_payable"]),
    mrpSavings: json["mrp_savings"] == null ? null : AmountPayable.fromJson(json["mrp_savings"]),
    totalSavings: json["total_savings"] == null ? null : AmountPayable.fromJson(json["total_savings"]),
    taxTotal: json["tax_total"] == null ? null : AmountPayable.fromJson(json["tax_total"]),
    discountTotal: json["discount_total"] == null ? null : AmountPayable.fromJson(json["discount_total"]),
    redeemedWalletAmount: json["redeemed_wallet_amount"] == null ? null : AmountPayable.fromJson(json["redeemed_wallet_amount"]),
    redeemablePaymentOptions: json["redeemable_payment_options"] == null ? [] : List<RedeemablePaymentOption>.from(json["redeemable_payment_options"]!.map((x) => RedeemablePaymentOption.fromJson(x))),
    paymentOptions: json["payment_options"] == null ? [] : List<PaymentOption>.from(json["payment_options"]!.map((x) => PaymentOption.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "cart_id": cartId,
    "order_number":orderNumber,
    "invoice_number": invoiceNumber,
    "created_at": createdAt?.toIso8601String(),
    "cart_type": cartType,
    "total_units": totalUnits,
    "total_items": totalItems,
    "item_total": itemTotal?.toJson(),
    "amount_payable": amountPayable?.toJson(),
    "mrp_savings": mrpSavings?.toJson(),
    "tax_total": taxTotal?.toJson(),
    "total_savings": totalSavings?.toJson(),
    "discount_total": discountTotal?.toJson(),
    "redeemed_wallet_amount": redeemedWalletAmount?.toJson(),
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

class RedeemablePaymentOption {
  String? paymentOptionId;
  String? code;
  String? pspId;
  Description? description;
  String? availableBalance;
  String? applicableBalance;

  RedeemablePaymentOption({
    this.paymentOptionId,
    this.code,
    this.pspId,
    this.description,
    this.availableBalance,
    this.applicableBalance,
  });

  factory RedeemablePaymentOption.fromJson(Map<String, dynamic> json) => RedeemablePaymentOption(
    paymentOptionId: json["payment_option_id"],
    code: json["code"],
    pspId: json["psp_id"],
    description: json["description"] == null ? null : Description.fromJson(json["description"]),
    availableBalance: json["available_balance"],
    applicableBalance: json["applicable_balance"],
  );

  Map<String, dynamic> toJson() => {
    "payment_option_id": paymentOptionId,
    "code": code,
    "psp_id": pspId,
    "description": description?.toJson(),
    "available_balance": availableBalance,
    "applicable_balance": applicableBalance,
  };
}
