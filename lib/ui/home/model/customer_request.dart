// To parse this JSON data, do
//
//     final customerRequest = customerRequestFromJson(jsonString);

import 'dart:convert';

CustomerRequest customerRequestFromJson(String str) =>
    CustomerRequest.fromJson(json.decode(str));

String customerRequestToJson(CustomerRequest data) =>
    json.encode(data.toJson());

class CustomerRequest {
  String phoneNumber;
  String cartType;
  String outletId;

  CustomerRequest({
    required this.phoneNumber,
    required this.cartType,
    required this.outletId,
  });

  factory CustomerRequest.fromJson(Map<String, dynamic> json) =>
      CustomerRequest(
        phoneNumber: json["phone_number"],
        cartType: json["cart_type"],
        outletId: json["outlet_id"],
      );

  Map<String, dynamic> toJson() => {
        "phone_number": phoneNumber,
        "cart_type": cartType,
        "outlet_id": outletId,
      };
}
