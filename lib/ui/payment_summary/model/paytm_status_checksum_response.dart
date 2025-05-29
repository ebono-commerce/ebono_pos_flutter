// To parse this JSON data, do
//
//     final paytmStatusChecksumResponse = paytmStatusChecksumResponseFromJson(jsonString);

import 'dart:convert';

PaytmStatusChecksumResponse paytmStatusChecksumResponseFromJson(String str) => PaytmStatusChecksumResponse.fromJson(json.decode(str));

String paytmStatusChecksumResponseToJson(PaytmStatusChecksumResponse data) => json.encode(data.toJson());

class PaytmStatusChecksumResponse {
  PaytmStatusPayload? payload;
  String? provider;

  PaytmStatusChecksumResponse({
    this.payload,
    this.provider,
  });

  factory PaytmStatusChecksumResponse.fromJson(Map<String, dynamic> json) => PaytmStatusChecksumResponse(
    payload: json["payload"] == null ? null : PaytmStatusPayload.fromJson(json["payload"]),
    provider: json["provider"],
  );

  Map<String, dynamic> toJson() => {
    "payload": payload?.toJson(),
    "provider": provider,
  };
}

class PaytmStatusPayload {
  PaytmStatusHead? head;
  PaytmStatusBody? body;

  PaytmStatusPayload({
    this.head,
    this.body,
  });

  factory PaytmStatusPayload.fromJson(Map<String, dynamic> json) => PaytmStatusPayload(
    head: json["head"] == null ? null : PaytmStatusHead.fromJson(json["head"]),
    body: json["body"] == null ? null : PaytmStatusBody.fromJson(json["body"]),
  );

  Map<String, dynamic> toJson() => {
    "head": head?.toJson(),
    "body": body?.toJson(),
  };
}

class PaytmStatusBody {
  String? paytmMid;
  String? paytmTid;
  String? transactionDateTime;
  String? merchantTransactionId;

  PaytmStatusBody({
    this.paytmMid,
    this.paytmTid,
    this.transactionDateTime,
    this.merchantTransactionId,
  });

  factory PaytmStatusBody.fromJson(Map<String, dynamic> json) => PaytmStatusBody(
    paytmMid: json["paytmMid"],
    paytmTid: json["paytmTid"],
    transactionDateTime: json["transactionDateTime"],
    merchantTransactionId: json["merchantTransactionId"],
  );

  Map<String, dynamic> toJson() => {
    "paytmMid": paytmMid,
    "paytmTid": paytmTid,
    "transactionDateTime": transactionDateTime,
    "merchantTransactionId": merchantTransactionId,
  };
}

class PaytmStatusHead {
  String? requestTimeStamp;
  String? channelId;
  String? checksum;
  String? version;

  PaytmStatusHead({
    this.requestTimeStamp,
    this.channelId,
    this.checksum,
    this.version,
  });

  factory PaytmStatusHead.fromJson(Map<String, dynamic> json) => PaytmStatusHead(
    requestTimeStamp: json["requestTimeStamp"],
    channelId: json["channelId"],
    checksum: json["checksum"],
    version: json["version"],
  );

  Map<String, dynamic> toJson() => {
    "requestTimeStamp": requestTimeStamp,
    "channelId": channelId,
    "checksum": checksum,
    "version": version,
  };
}
