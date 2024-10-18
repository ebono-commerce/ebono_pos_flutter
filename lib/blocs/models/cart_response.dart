// To parse this JSON data, do
//
//     final cartResponse = cartResponseFromJson(jsonString);

import 'dart:convert';

CartResponse cartResponseFromJson(String str) =>
    CartResponse.fromJson(json.decode(str));

String cartResponseToJson(CartResponse data) => json.encode(data.toJson());

class CartResponse {
  String? cartId;
  String? cartType;
  List<CartLine>? cartLines;
  List<CartTotal>? cartTotals;
  Audit? audit;

  CartResponse({
    this.cartId,
    this.cartType,
    this.cartLines,
    this.cartTotals,
    this.audit,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) => CartResponse(
        cartId: json["cart_id"],
        cartType: json["cart_type"],
        cartLines: json["cart_lines"] == null
            ? []
            : List<CartLine>.from(
                json["cart_lines"]!.map((x) => CartLine.fromJson(x))),
        cartTotals: json["cart_totals"] == null
            ? []
            : List<CartTotal>.from(
                json["cart_totals"]!.map((x) => CartTotal.fromJson(x))),
        audit: json["audit"] == null ? null : Audit.fromJson(json["audit"]),
      );

  Map<String, dynamic> toJson() => {
        "cart_id": cartId,
        "cart_type": cartType,
        "cart_lines": cartLines == null
            ? []
            : List<dynamic>.from(cartLines!.map((x) => x.toJson())),
        "cart_totals": cartTotals == null
            ? []
            : List<dynamic>.from(cartTotals!.map((x) => x.toJson())),
        "audit": audit?.toJson(),
      };
}

class Audit {
  DateTime? createdAt;
  DateTime? lastModifiedAt;

  Audit({
    this.createdAt,
    this.lastModifiedAt,
  });

  factory Audit.fromJson(Map<String, dynamic> json) => Audit(
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

class CartLine {
  String? cartLineId;
  Item? item;
  Quantity? quantity;
  Mrp? unitPrice;
  Mrp? mrp;
  List<CartTotal>? cartLineTotals;

  CartLine({
    this.cartLineId,
    this.item,
    this.quantity,
    this.unitPrice,
    this.mrp,
    this.cartLineTotals,
  });

  factory CartLine.fromJson(Map<String, dynamic> json) => CartLine(
        cartLineId: json["cart_line_id"],
        item: json["item"] == null ? null : Item.fromJson(json["item"]),
        quantity: json["quantity"] == null
            ? null
            : Quantity.fromJson(json["quantity"]),
        unitPrice: json["unit_price"] == null
            ? null
            : Mrp.fromJson(json["unit_price"]),
        mrp: json["mrp"] == null ? null : Mrp.fromJson(json["mrp"]),
        cartLineTotals: json["cart_line_totals"] == null
            ? []
            : List<CartTotal>.from(
                json["cart_line_totals"]!.map((x) => CartTotal.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cart_line_id": cartLineId,
        "item": item?.toJson(),
        "quantity": quantity?.toJson(),
        "unit_price": unitPrice?.toJson(),
        "mrp": mrp?.toJson(),
        "cart_line_totals": cartLineTotals == null
            ? []
            : List<dynamic>.from(cartLineTotals!.map((x) => x.toJson())),
      };
}

class CartTotal {
  String? type;
  Mrp? amount;
  int? multiplier;

  CartTotal({
    this.type,
    this.amount,
    this.multiplier,
  });

  factory CartTotal.fromJson(Map<String, dynamic> json) => CartTotal(
        type: json["type"],
        amount: json["amount"] == null ? null : Mrp.fromJson(json["amount"]),
        multiplier: json["multiplier"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "amount": amount?.toJson(),
        "multiplier": multiplier,
      };
}

class Mrp {
  Currency? currency;
  int? centAmount;
  int? fraction;

  Mrp({
    this.currency,
    this.centAmount,
    this.fraction,
  });

  factory Mrp.fromJson(Map<String, dynamic> json) => Mrp(
        currency: currencyValues.map[json["currency"]]!,
        centAmount: json["cent_amount"],
        fraction: json["fraction"],
      );

  Map<String, dynamic> toJson() => {
        "currency": currencyValues.reverse[currency],
        "cent_amount": centAmount,
        "fraction": fraction,
      };
}

enum Currency { INR }

final currencyValues = EnumValues({"INR": Currency.INR});

class Item {
  String? esin;
  String? ebonoTitle;
  String? productType;

  Item({
    this.esin,
    this.ebonoTitle,
    this.productType,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        esin: json["esin"],
        ebonoTitle: json["ebono_title"],
        productType: json["product_type"],
      );

  Map<String, dynamic> toJson() => {
        "esin": esin,
        "ebono_title": ebonoTitle,
        "product_type": productType,
      };
}

class Quantity {
  int? quantityNumber;

  Quantity({
    this.quantityNumber,
  });

  factory Quantity.fromJson(Map<String, dynamic> json) => Quantity(
        quantityNumber: json["quantity_number"],
      );

  Map<String, dynamic> toJson() => {
        "quantity_number": quantityNumber,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
