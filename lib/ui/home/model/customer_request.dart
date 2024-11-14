// To parse this JSON data, do
//
//     final customerRequest = customerRequestFromJson(jsonString);

import 'dart:convert';

CustomerRequest customerRequestFromJson(dynamic str) =>
    CustomerRequest.fromJson(json.decode(str));

String customerRequestToJson(CustomerRequest data) =>
    json.encode(data.toJson());

class CustomerRequest {
  String? phoneNumber;
  String? customerName;

  String? cartType;
  String? outletId;

  CustomerRequest({
    this.phoneNumber,
    this.customerName,
    this.cartType,
    this.outletId,
  });

  factory CustomerRequest.fromJson(Map<String, dynamic> json) =>
      CustomerRequest(
        phoneNumber: json["phone_number"],
        customerName: json["customer_name"],
        cartType: json["cart_type"],
        outletId: json["outlet_id"],
      );

  Map<String, dynamic> toJson() => {
        "phone_number": phoneNumber,
        "customer_name": customerName,
        "cart_type": cartType,
        "outlet_id": outletId,
      };
}
