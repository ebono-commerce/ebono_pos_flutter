// To parse this JSON data, do
//
//     final cartResponse = cartResponseFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

CartResponse cartResponseFromJson(dynamic str) =>
    CartResponse.fromJson(json.decode(str));

String cartResponseToJson(CartResponse data) => json.encode(data.toJson());

class CartResponse {
  String? cartId;
  String? cartType;
  String? outletId;
  double? totalUnits;
  int? totalItems;
  List<CartLine>? cartLines;
  AmountPayable? mrpSavings;
  AmountPayable? amountPayable;
  List<CartAdjustment>? cartAdjustments;
  CartResponseAudit? audit;

  CartResponse({
    this.cartId,
    this.cartType,
    this.outletId,
    this.totalUnits,
    this.totalItems,
    this.cartLines,
    this.mrpSavings,
    this.amountPayable,
    this.cartAdjustments,
    this.audit,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) => CartResponse(
        cartId: json["cart_id"],
        cartType: json["cart_type"],
        outletId: json["outlet_id"],
        totalUnits: json["total_units"]?.toDouble(),
        totalItems: json["total_items"],
        cartLines: json["cart_lines"] == null
            ? []
            : List<CartLine>.from(
                json["cart_lines"]!.map((x) => CartLine.fromJson(x))),
        mrpSavings: json["mrp_savings"] == null
            ? null
            : AmountPayable.fromJson(json["mrp_savings"]),
        amountPayable: json["amount_payable"] == null
            ? null
            : AmountPayable.fromJson(json["amount_payable"]),
        cartAdjustments: json["cart_adjustments"] == null
            ? []
            : List<CartAdjustment>.from(json["cart_adjustments"]!
                .map((x) => CartAdjustment.fromJson(x))),
        audit: json["audit"] == null
            ? null
            : CartResponseAudit.fromJson(json["audit"]),
      );

  Map<String, dynamic> toJson() => {
        "cart_id": cartId,
        "cart_type": cartType,
        "outlet_id": outletId,
        "total_units": totalUnits,
        "total_items": totalItems,
        "cart_lines": cartLines == null
            ? []
            : List<dynamic>.from(cartLines!.map((x) => x.toJson())),
        "mrp_savings": mrpSavings?.toJson(),
        "amount_payable": amountPayable?.toJson(),
        "cart_adjustments": cartAdjustments == null
            ? []
            : List<dynamic>.from(cartAdjustments!.map((x) => x.toJson())),
        "audit": audit?.toJson(),
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

class CartResponseAudit {
  DateTime? createdAt;
  DateTime? lastModifiedAt;

  CartResponseAudit({
    this.createdAt,
    this.lastModifiedAt,
  });

  factory CartResponseAudit.fromJson(Map<String, dynamic> json) =>
      CartResponseAudit(
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        lastModifiedAt: json["last_modified_at"] == null
            ? null
            : DateTime.parse(json["last_modified_at"]),
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt?.toIso8601String(),
        "last_modified_at": lastModifiedAt?.toIso8601String(),
      };
}

class CartAdjustment {
  String? type;
  String? applicability;
  String? reference;
  String? referenceCode;
  String? description;
  int? multiplier;
  bool? taxIncludedInAmount;
  AmountPayable? amount;

  CartAdjustment({
    this.type,
    this.applicability,
    this.reference,
    this.referenceCode,
    this.description,
    this.multiplier,
    this.taxIncludedInAmount,
    this.amount,
  });

  factory CartAdjustment.fromJson(Map<String, dynamic> json) => CartAdjustment(
        type: json["type"],
        applicability: json["applicability"],
        reference: json["reference"],
        referenceCode: json["reference_code"],
        description: json["description"],
        multiplier: json["multiplier"],
        taxIncludedInAmount: json["tax_included_in_amount"],
        amount: json["amount"] == null
            ? null
            : AmountPayable.fromJson(json["amount"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "applicability": applicability,
        "reference": reference,
        "reference_code": referenceCode,
        "description": description,
        "multiplier": multiplier,
        "tax_included_in_amount": taxIncludedInAmount,
        "amount": amount?.toJson(),
      };
}

class CartLine {
  String? cartLineId;
  Item? item;
  bool? isWeighedItem;

  Quantity? quantity;
  AmountPayable? unitPrice;
  AmountPayable? mrp;
  AmountPayable? lineTotal;
  List<String>? applicableCartAdjustments;
  CartLineAudit? audit;
  TextEditingController? controller = TextEditingController();
  FocusNode? focusNode = FocusNode();

  CartLine(
      {this.cartLineId,
      this.item,
      this.isWeighedItem,
      this.quantity,
      this.unitPrice,
      this.mrp,
      this.lineTotal,
      this.applicableCartAdjustments,
      this.audit,
      this.controller,
      this.focusNode});

  factory CartLine.fromJson(Map<String, dynamic> json) => CartLine(
        cartLineId: json["cart_line_id"],
        isWeighedItem: json["is_weighed_item"],
        item: json["item"] == null ? null : Item.fromJson(json["item"]),
        quantity: json["quantity"] == null
            ? null
            : Quantity.fromJson(json["quantity"]),
        unitPrice: json["unit_price"] == null
            ? null
            : AmountPayable.fromJson(json["unit_price"]),
        mrp: json["mrp"] == null ? null : AmountPayable.fromJson(json["mrp"]),
        lineTotal: json["line_total"] == null
            ? null
            : AmountPayable.fromJson(json["line_total"]),
        applicableCartAdjustments: json["applicable_cart_adjustments"] == null
            ? []
            : List<String>.from(
                json["applicable_cart_adjustments"]!.map((x) => x)),
        audit: json["audit"] == null
            ? null
            : CartLineAudit.fromJson(json["audit"]),
      );

  Map<String, dynamic> toJson() => {
        "cart_line_id": cartLineId,
        "is_weighed_item": isWeighedItem,
        "item": item?.toJson(),
        "quantity": quantity?.toJson(),
        "unit_price": unitPrice?.toJson(),
        "mrp": mrp?.toJson(),
        "line_total": lineTotal?.toJson(),
        "applicable_cart_adjustments": applicableCartAdjustments == null
            ? []
            : List<dynamic>.from(applicableCartAdjustments!.map((x) => x)),
        "audit": audit?.toJson(),
      };
}

class CartLineAudit {
  String? apiVersion;
  DateTime? createdAt;
  DateTime? lastModifiedAt;

  CartLineAudit({
    this.apiVersion,
    this.createdAt,
    this.lastModifiedAt,
  });

  factory CartLineAudit.fromJson(Map<String, dynamic> json) => CartLineAudit(
        apiVersion: json["api_version"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        lastModifiedAt: json["last_modified_at"] == null
            ? null
            : DateTime.parse(json["last_modified_at"]),
      );

  Map<String, dynamic> toJson() => {
        "api_version": apiVersion,
        "created_at": createdAt?.toIso8601String(),
        "last_modified_at": lastModifiedAt?.toIso8601String(),
      };
}

class Item {
  String? esin;
  String? saleUom;
  String? ebonoTitle;
  String? primaryImageUrl;
  String? productType;

  Item({
    this.esin,
    this.saleUom,
    this.ebonoTitle,
    this.primaryImageUrl,
    this.productType,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        esin: json["esin"],
        saleUom: json["sale_uom"],
        ebonoTitle: json["ebono_title"],
        primaryImageUrl: json["primary_image_url"],
        productType: json["product_type"],
      );

  Map<String, dynamic> toJson() => {
        "esin": esin,
        "sale_uom": saleUom,
        "ebono_title": ebonoTitle,
        "primary_image_url": primaryImageUrl,
        "product_type": productType,
      };
}

class Quantity {
  double? quantityNumber;
  String? quantityUom;

  Quantity({
    this.quantityNumber,
    this.quantityUom,
  });

  factory Quantity.fromJson(Map<String, dynamic> json) => Quantity(
        quantityNumber: json["quantity_number"]?.toDouble(),
        quantityUom: json["quantity_uom"],
      );

  Map<String, dynamic> toJson() => {
        "quantity_number": quantityNumber,
        "quantity_uom": quantityUom,
      };
}
