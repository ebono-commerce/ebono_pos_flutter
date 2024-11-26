// To parse this JSON data, do
//
//     final registerOpenRequest = registerOpenRequestFromJson(jsonString);

import 'dart:convert';

RegisterOpenRequest registerOpenRequestFromJson(dynamic str) =>
    RegisterOpenRequest.fromJson(json.decode(str));

String registerOpenRequestToJson(RegisterOpenRequest data) =>
    json.encode(data.toJson());

class RegisterOpenRequest {
  String? outletId;
  String? terminalId;
  String? userId;
  int? floatCash;

  RegisterOpenRequest({
    this.outletId,
    this.terminalId,
    this.userId,
    this.floatCash,
  });

  factory RegisterOpenRequest.fromJson(Map<String, dynamic> json) =>
      RegisterOpenRequest(
        outletId: json["outlet_id"],
        terminalId: json["terminal_id"],
        userId: json["user_id"],
        floatCash: json["float_cash"],
      );

  Map<String, dynamic> toJson() => {
        "outlet_id": outletId,
        "terminal_id": terminalId,
        "user_id": userId,
        "float_cash": floatCash,
      };
}
