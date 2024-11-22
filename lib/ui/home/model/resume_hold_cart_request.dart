// To parse this JSON data, do
//
//     final resumeHoldCartRequest = resumeHoldCartRequestFromJson(jsonString);

import 'dart:convert';

ResumeHoldCartRequest resumeHoldCartRequestFromJson(dynamic str) =>
    ResumeHoldCartRequest.fromJson(json.decode(str));

String resumeHoldCartRequestToJson(ResumeHoldCartRequest data) =>
    json.encode(data.toJson());

class ResumeHoldCartRequest {
  String? holdCartId;
  String? terminalId;

  ResumeHoldCartRequest({
    this.holdCartId,
    this.terminalId,
  });

  factory ResumeHoldCartRequest.fromJson(Map<String, dynamic> json) =>
      ResumeHoldCartRequest(
        holdCartId: json["hold_cart_id"],
        terminalId: json["terminal_id"],
      );

  Map<String, dynamic> toJson() => {
        "hold_cart_id": holdCartId,
        "terminal_id": terminalId,
      };
}
