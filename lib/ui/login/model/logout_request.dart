// To parse this JSON data, do
//
//     final loginRequest = loginRequestFromJson(jsonString);

import 'dart:convert';

LogoutRequest logoutRequestFromJson(String str) => LogoutRequest.fromJson(json.decode(str));

String logoutRequestToJson(LogoutRequest data) => json.encode(data.toJson());

class LogoutRequest {
  String outletId;
  String terminalId;
  String posMode;

  LogoutRequest({
    required this.outletId,
    required this.terminalId,
    required this.posMode,
  });

  factory LogoutRequest.fromJson(Map<String, dynamic> json) => LogoutRequest(
    outletId: json["outlet_id"],
    terminalId: json["terminal_id"],
    posMode: json["pos_mode"],
  );

  Map<String, dynamic> toJson() => {
    "outlet_id": outletId,
    "terminal_id": terminalId,
    "pos_mode": posMode,
  };
}