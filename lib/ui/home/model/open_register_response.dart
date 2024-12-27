import 'dart:convert';

OpenRegisterResponse openRegisterResponseFromJson(str) => OpenRegisterResponse.fromJson(json.decode(str));

String openRegisterResponseToJson(OpenRegisterResponse data) => json.encode(data.toJson());

class OpenRegisterResponse {
  String? registerId;
  String? registerTransactionId;

  OpenRegisterResponse({
    this.registerId,
    this.registerTransactionId,
  });

  factory OpenRegisterResponse.fromJson(Map<String, dynamic> json) => OpenRegisterResponse(
    registerId: json["register_id"],
    registerTransactionId: json["register_transaction_id"],
  );

  Map<String, dynamic> toJson() => {
    "register_id": registerId,
    "register_transaction_id": registerTransactionId,
  };
}
