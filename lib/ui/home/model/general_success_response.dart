// To parse this JSON data, do
//
//     final generalSuccessResponse = generalSuccessResponseFromJson(jsonString);

import 'dart:convert';

GeneralSuccessResponse generalSuccessResponseFromJson(dynamic str) =>
    GeneralSuccessResponse.fromJson(json.decode(str));

String generalSuccessResponseToJson(GeneralSuccessResponse data) =>
    json.encode(data.toJson());

class GeneralSuccessResponse {
  bool? success;

  GeneralSuccessResponse({
    this.success,
  });

  factory GeneralSuccessResponse.fromJson(Map<String, dynamic> json) =>
      GeneralSuccessResponse(
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
      };
}
