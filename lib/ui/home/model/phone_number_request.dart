// To parse this JSON data, do
//
//     final phoneNumberRequest = phoneNumberRequestFromJson(jsonString);

import 'dart:convert';

PhoneNumberRequest phoneNumberRequestFromJson(dynamic str) =>
    PhoneNumberRequest.fromJson(json.decode(str));

String phoneNumberRequestToJson(PhoneNumberRequest data) =>
    json.encode(data.toJson());

class PhoneNumberRequest {
  String? phoneNumber;

  PhoneNumberRequest({
    this.phoneNumber,
  });

  factory PhoneNumberRequest.fromJson(Map<String, dynamic> json) =>
      PhoneNumberRequest(
        phoneNumber: json["phone_number"],
      );

  Map<String, dynamic> toJson() => {
        "phone_number": phoneNumber,
      };
}
