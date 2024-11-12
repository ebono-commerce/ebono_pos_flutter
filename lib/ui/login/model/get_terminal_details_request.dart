import 'dart:convert';

GetTerminalDetailsRequest getTerminalDetailsRequestFromJson(String str) => GetTerminalDetailsRequest.fromJson(json.decode(str));

String getTerminalDetailsRequestToJson(GetTerminalDetailsRequest data) => json.encode(data.toJson());

class GetTerminalDetailsRequest {
  String outletId;
  String terminalId;
  String userId;
  String posMode;

  GetTerminalDetailsRequest({
    required this.outletId,
    required this.terminalId,
    required this.userId,
    required this.posMode,
  });

  factory GetTerminalDetailsRequest.fromJson(Map<String, dynamic> json) => GetTerminalDetailsRequest(
    outletId: json["outlet_id"],
    terminalId: json["terminal_id"],
    userId: json["user_id"],
    posMode: json["pos_mode"],
  );

  Map<String, dynamic> toJson() => {
    "outlet_id": outletId,
    "terminal_id": terminalId,
    "user_id": userId,
    "pos_mode": posMode,
  };
}
