// To parse this JSON data, do
//
//     final getAuthorisationResponse = getAuthorisationResponseFromJson(jsonString);

import 'dart:convert';

GetAuthorisationResponse getAuthorisationResponseFromJson(String str) => GetAuthorisationResponse.fromJson(json.decode(str));

String getAuthorisationResponseToJson(GetAuthorisationResponse data) => json.encode(data.toJson());

class GetAuthorisationResponse {
  String? userId;

  GetAuthorisationResponse({
    this.userId,
  });

  factory GetAuthorisationResponse.fromJson(Map<String, dynamic> json) => GetAuthorisationResponse(
    userId: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
  };
}
