// To parse this JSON data, do
//
//     final addToCartRequest = addToCartRequestFromJson(jsonString);

import 'dart:convert';

AddToCartRequest addToCartRequestFromJson(String str) =>
    AddToCartRequest.fromJson(json.decode(str));

String addToCartRequestToJson(AddToCartRequest data) =>
    json.encode(data.toJson());

class AddToCartRequest {
  List<CartLine>? cartLines;

  AddToCartRequest({
    this.cartLines,
  });

  factory AddToCartRequest.fromJson(Map<String, dynamic> json) =>
      AddToCartRequest(
        cartLines: json["cart_lines"] == null
            ? []
            : List<CartLine>.from(
                json["cart_lines"]!.map((x) => CartLine.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cart_lines": cartLines == null
            ? []
            : List<dynamic>.from(cartLines!.map((x) => x.toJson())),
      };
}

class CartLine {
  String? esin;
  Quantity? quantity;
  String? mrpId;

  CartLine({
    this.esin,
    this.quantity,
    this.mrpId,
  });

  factory CartLine.fromJson(Map<String, dynamic> json) => CartLine(
        esin: json["esin"],
        quantity: json["quantity"] == null
            ? null
            : Quantity.fromJson(json["quantity"]),
        mrpId: json["mrp_id"],
      );

  Map<String, dynamic> toJson() => {
        "esin": esin,
        "quantity": quantity?.toJson(),
        "mrp_id": mrpId,
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
