// To parse this JSON data, do
//
//     final overRidePriceRequest = overRidePriceRequestFromJson(jsonString);

import 'dart:convert';

OverRidePriceRequest overRidePriceRequestFromJson(String str) => OverRidePriceRequest.fromJson(json.decode(str));

String overRidePriceRequestToJson(OverRidePriceRequest data) => json.encode(data.toJson());

class OverRidePriceRequest {
  String? cartId;
  Metadata? metadata;
  List<OverrideCartLine>? cartLines;

  OverRidePriceRequest({
    this.cartId,
    this.metadata,
    this.cartLines,
  });

  factory OverRidePriceRequest.fromJson(Map<String, dynamic> json) => OverRidePriceRequest(
    cartId: json["cart_id"],
    metadata: json["metadata"] == null ? null : Metadata.fromJson(json["metadata"]),
    cartLines: json["cart_lines"] == null ? [] : List<OverrideCartLine>.from(json["cart_lines"]!.map((x) => OverrideCartLine.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "cart_id": cartId,
    "metadata": metadata?.toJson(),
    "cart_lines": cartLines == null ? [] : List<dynamic>.from(cartLines!.map((x) => x.toJson())),
  };
}

class OverrideCartLine {
  String? cartLineId;
  UnitPrice? unitPrice;

  OverrideCartLine({
    this.cartLineId,
    this.unitPrice,
  });

  factory OverrideCartLine.fromJson(Map<String, dynamic> json) => OverrideCartLine(
    cartLineId: json["cart_line_id"],
    unitPrice: json["unit_price"] == null ? null : UnitPrice.fromJson(json["unit_price"]),
  );

  Map<String, dynamic> toJson() => {
    "cart_line_id": cartLineId,
    "unit_price": unitPrice?.toJson(),
  };
}

class UnitPrice {
  int? centAmount;
  String? currency;
  int? fraction;

  UnitPrice({
    this.centAmount,
    this.currency,
    this.fraction,
  });

  factory UnitPrice.fromJson(Map<String, dynamic> json) => UnitPrice(
    centAmount: json["cent_amount"],
    currency: json["currency"],
    fraction: json["fraction"],
  );

  Map<String, dynamic> toJson() => {
    "cent_amount": centAmount,
    "currency": currency,
    "fraction": fraction,
  };
}

class Metadata {
  String? overrideApproverUserId;

  Metadata({
    this.overrideApproverUserId,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
    overrideApproverUserId: json["override_approver_user_id"],
  );

  Map<String, dynamic> toJson() => {
    "override_approver_user_id": overrideApproverUserId,
  };
}
