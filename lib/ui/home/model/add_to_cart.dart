// To parse this JSON data, do
//
//     final addToCartRequest = addToCartRequestFromJson(jsonString);

import 'dart:convert';

AddToCartRequest addToCartRequestFromJson(String str) =>
    AddToCartRequest.fromJson(json.decode(str));

String addToCartRequestToJson(AddToCartRequest data) =>
    json.encode(data.toJson());

class AddToCartRequest {
  List<AddToCartCartLine>? cartLines;

  AddToCartRequest({
    this.cartLines,
  });

  factory AddToCartRequest.fromJson(Map<String, dynamic> json) =>
      AddToCartRequest(
        cartLines: json["cart_lines"] == null
            ? []
            : List<AddToCartCartLine>.from(
                json["cart_lines"]!.map((x) => AddToCartCartLine.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cart_lines": cartLines == null
            ? []
            : List<dynamic>.from(cartLines!.map((x) => x.toJson())),
      };
}

class AddToCartCartLine {
  String? skuCode;
  AddToCartQuantity? quantity;
  String? mrpId;

  AddToCartCartLine({
    this.skuCode,
    this.quantity,
    this.mrpId,
  });

  factory AddToCartCartLine.fromJson(Map<String, dynamic> json) =>
      AddToCartCartLine(
        skuCode: json["sku_code"],
        quantity: json["quantity"] == null
            ? null
            : AddToCartQuantity.fromJson(json["quantity"]),
        mrpId: json["mrp_id"],
      );

  Map<String, dynamic> toJson() => {
        "sku_code": skuCode,
        "quantity": quantity?.toJson(),
        if (mrpId != null) "mrp_id": mrpId,
      };
}

class AddToCartQuantity {
  dynamic quantityNumber;
  bool? isWeighedItem;
  String? quantityUom;

  AddToCartQuantity({
    this.quantityNumber,
    this.quantityUom,
    this.isWeighedItem,
  });

  factory AddToCartQuantity.fromJson(Map<String, dynamic> json) =>
      AddToCartQuantity(
        quantityNumber: json["quantity_number"],
        quantityUom: json["quantity_uom"],
      );

  Map<String, dynamic> toJson() => {
        "quantity_number": isWeighedItem == true
            ? double.tryParse(quantityNumber.toString())
            : quantityNumber,
        "quantity_uom": quantityUom,
      };
}
