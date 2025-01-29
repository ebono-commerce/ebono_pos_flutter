// To parse this JSON data, do
//
//     final customerDetailsResponse = customerDetailsResponseFromJson(jsonString);

import 'dart:convert';

CustomerDetailsResponse customerDetailsResponseFromJson(str) =>
    CustomerDetailsResponse.fromJson(json.decode(str));

String customerDetailsResponseToJson(CustomerDetailsResponse data) =>
    json.encode(data.toJson());

class CustomerDetailsResponse {
  PhoneNumber? phoneNumber;
  dynamic customerName;
  bool? existingCustomer;
  String? customerStatus;
  bool? isCustomerVerificationRequired;

  CustomerDetailsResponse({
    this.phoneNumber,
    this.customerName,
    this.existingCustomer,
    this.customerStatus,
    this.isCustomerVerificationRequired,
  });

  factory CustomerDetailsResponse.fromJson(Map<String, dynamic> json) =>
      CustomerDetailsResponse(
        phoneNumber: json["phone_number"] == null
            ? null
            : PhoneNumber.fromJson(json["phone_number"]),
        customerName: json["customer_name"],
        isCustomerVerificationRequired:
            json["customer_status"] == 'EXISTING_CUSTOMER_VERIFIED'
                ? false
                : true,
        customerStatus: json["customer_status"],
        existingCustomer: json["existing_customer"],
      );

  Map<String, dynamic> toJson() => {
        "phone_number": phoneNumber?.toJson(),
        "customer_name": customerName,
        "is_customer_verification_required": isCustomerVerificationRequired,
        "existing_customer": existingCustomer,
        "customer_status": customerStatus,
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
