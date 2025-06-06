// To parse this JSON data, do
//
//     final paytmInitiateChecksumResponse = paytmInitiateChecksumResponseFromJson(jsonString);

import 'dart:convert';

PaytmInitiateChecksumResponse paytmInitiateChecksumResponseFromJson(str) => PaytmInitiateChecksumResponse.fromJson(json.decode(str));

String paytmInitiateChecksumResponseToJson(PaytmInitiateChecksumResponse data) => json.encode(data.toJson());

class PaytmInitiateChecksumResponse {
  PaytmInitiatePayload? payload;
  String? provider;

  PaytmInitiateChecksumResponse({
    this.payload,
    this.provider,
  });

  factory PaytmInitiateChecksumResponse.fromJson(Map<String, dynamic> json) => PaytmInitiateChecksumResponse(
    payload: json["payload"] == null ? null : PaytmInitiatePayload.fromJson(json["payload"]),
    provider: json["provider"],
  );

  Map<String, dynamic> toJson() => {
    "payload": payload?.toJson(),
    "provider": provider,
  };
}

class PaytmInitiatePayload {
  PaytmInitiateHead? head;
  PaytmInitiateBody? body;

  PaytmInitiatePayload({
    this.head,
    this.body,
  });

  factory PaytmInitiatePayload.fromJson(Map<String, dynamic> json) => PaytmInitiatePayload(
    head: json["head"] == null ? null : PaytmInitiateHead.fromJson(json["head"]),
    body: json["body"] == null ? null : PaytmInitiateBody.fromJson(json["body"]),
  );

  Map<String, dynamic> toJson() => {
    "head": head?.toJson(),
    "body": body?.toJson(),
  };
}

class PaytmInitiateBody {
  String? paytmMid;
  String? paytmTid;
  String? transactionDateTime;
  String? merchantTransactionId;
  String? transactionAmount;

  PaytmInitiateBody({
    this.paytmMid,
    this.paytmTid,
    this.transactionDateTime,
    this.merchantTransactionId,
    this.transactionAmount,
  });

  factory PaytmInitiateBody.fromJson(Map<String, dynamic> json) => PaytmInitiateBody(
    paytmMid: json["paytmMid"],
    paytmTid: json["paytmTid"],
    transactionDateTime: json["transactionDateTime"],
    merchantTransactionId: json["merchantTransactionId"],
    transactionAmount: json["transactionAmount"],
  );

  Map<String, dynamic> toJson() => {
    "paytmMid": paytmMid,
    "paytmTid": paytmTid,
    "transactionDateTime": transactionDateTime,
    "merchantTransactionId": merchantTransactionId,
    "transactionAmount": transactionAmount,
  };
}

class PaytmInitiateHead {
  String? requestTimeStamp;
  String? channelId;
  String? checksum;
  String? version;

  PaytmInitiateHead({
    this.requestTimeStamp,
    this.channelId,
    this.checksum,
    this.version,
  });

  factory PaytmInitiateHead.fromJson(Map<String, dynamic> json) => PaytmInitiateHead(
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
