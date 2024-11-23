// To parse this JSON data, do
//
//     final healthCheckResponse = healthCheckResponseFromJson(jsonString);

import 'dart:convert';

HealthCheckResponse healthCheckResponseFromJson(String str) =>
    HealthCheckResponse.fromJson(json.decode(str));

String healthCheckResponseToJson(HealthCheckResponse data) =>
    json.encode(data.toJson());

class HealthCheckResponse {
  int? statusCode;
  String? status;

  HealthCheckResponse({
    this.statusCode,
    this.status,
  });

  factory HealthCheckResponse.fromJson(Map<String, dynamic> json) =>
      HealthCheckResponse(
        statusCode: json["statusCode"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "status": status,
      };
}
