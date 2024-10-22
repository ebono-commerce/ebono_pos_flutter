// To parse this JSON data, do
//
//     final customerResponse = customerResponseFromJson(jsonString);

import 'dart:convert';

CustomerResponse customerResponseFromJson(String str) =>
    CustomerResponse.fromJson(json.decode(str));

String customerResponseToJson(CustomerResponse data) =>
    json.encode(data.toJson());

class CustomerResponse {
  String? cartId;
  PhoneNumber? phoneNumber;
  String? customerName;
  LoyaltyPoints? walletBalance;
  LoyaltyPoints? loyaltyPoints;

  CustomerResponse({
    this.cartId,
    this.phoneNumber,
    this.customerName,
    this.walletBalance,
    this.loyaltyPoints,
  });

  factory CustomerResponse.fromJson(Map<String, dynamic> json) =>
      CustomerResponse(
        cartId: json["cart_id"],
        phoneNumber: json["phone_number"] == null
            ? null
            : PhoneNumber.fromJson(json["phone_number"]),
        customerName: json["customer_name"],
        walletBalance: json["wallet_balance"] == null
            ? null
            : LoyaltyPoints.fromJson(json["wallet_balance"]),
        loyaltyPoints: json["loyalty_points"] == null
            ? null
            : LoyaltyPoints.fromJson(json["loyalty_points"]),
      );

  Map<String, dynamic> toJson() => {
        "cart_id": cartId,
        "phone_number": phoneNumber?.toJson(),
        "customer_name": customerName,
        "wallet_balance": walletBalance?.toJson(),
        "loyalty_points": loyaltyPoints?.toJson(),
      };
}

class LoyaltyPoints {
  int? centAmount;
  String? currency;
  int? fraction;

  LoyaltyPoints({
    this.centAmount,
    this.currency,
    this.fraction,
  });

  factory LoyaltyPoints.fromJson(Map<String, dynamic> json) => LoyaltyPoints(
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

class PhoneNumber {
  String? countryCode;
  String? number;

  PhoneNumber({
    this.countryCode,
    this.number,
  });

  factory PhoneNumber.fromJson(Map<String, dynamic> json) => PhoneNumber(
        countryCode: json["country_code"],
        number: json["number"],
      );

  Map<String, dynamic> toJson() => {
        "country_code": countryCode,
        "number": number,
      };
}
