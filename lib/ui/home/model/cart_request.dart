// To parse this JSON data, do
//
//     final cartRequest = cartRequestFromJson(jsonString);

import 'dart:convert';

CartRequest cartRequestFromJson(dynamic str) =>
    CartRequest.fromJson(json.decode(str));

String cartRequestToJson(CartRequest data) => json.encode(data.toJson());

class CartRequest {
  String cartId;

  CartRequest({
    required this.cartId,
  });

  factory CartRequest.fromJson(Map<String, dynamic> json) => CartRequest(
        cartId: json["cart_id"],
      );

  Map<String, dynamic> toJson() => {
        "cart_id": cartId,
      };
}
