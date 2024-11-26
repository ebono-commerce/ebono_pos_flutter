// To parse this JSON data, do
//
//     final openRegisterResponse = openRegisterResponseFromJson(jsonString);

import 'dart:convert';

OpenRegisterResponse openRegisterResponseFromJson(dynamic str) =>
    OpenRegisterResponse.fromJson(json.decode(str));

String openRegisterResponseToJson(OpenRegisterResponse data) =>
    json.encode(data.toJson());

class OpenRegisterResponse {
  String? registerId;

  OpenRegisterResponse({
    this.registerId,
  });

  factory OpenRegisterResponse.fromJson(Map<String, dynamic> json) =>
      OpenRegisterResponse(
        registerId: json["register_id"],
      );

  Map<String, dynamic> toJson() => {
        "register_id": registerId,
      };
}
