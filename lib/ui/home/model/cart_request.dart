import 'dart:convert';

CartRequest cartRequestFromJson(dynamic str) =>
    CartRequest.fromJson(json.decode(str));

String cartRequestToJson(CartRequest data) => json.encode(data.toJson());

class CartRequest {
  String? cartId;
  String? phoneNumber;

  CartRequest({this.cartId, this.phoneNumber});

  factory CartRequest.fromJson(Map<String, dynamic> json) => CartRequest(
        cartId: json["cart_id"],
        phoneNumber: json["phone_number"]
      );

  Map<String, dynamic> toJson() =>
      {"cart_id": cartId, if (phoneNumber != null) "phone_number": phoneNumber};
}
