// To parse this JSON data, do
//
//     final paytmPaymentInitiateResponse = paytmPaymentInitiateResponseFromJson(jsonString);

import 'dart:convert';

PaytmPaymentInitiateResponse paytmPaymentInitiateResponseFromJson(str) => PaytmPaymentInitiateResponse.fromJson(json.decode(str));

String paytmPaymentInitiateResponseToJson(PaytmPaymentInitiateResponse data) => json.encode(data.toJson());

class PaytmPaymentInitiateResponse {
  Head? head;
  Body? body;

  PaytmPaymentInitiateResponse({
    this.head,
    this.body,
  });

  factory PaytmPaymentInitiateResponse.fromJson(Map<String, dynamic> json) => PaytmPaymentInitiateResponse(
    head: json["head"] == null ? null : Head.fromJson(json["head"]),
    body: json["body"] == null ? null : Body.fromJson(json["body"]),
  );

  Map<String, dynamic> toJson() => {
    "head": head?.toJson(),
    "body": body?.toJson(),
  };
}

class Body {
  String? merchantTransactionId;
  String? paytmMid;
  String? paytmTid;
  ResultInfo? resultInfo;

  Body({
    this.merchantTransactionId,
    this.paytmMid,
    this.paytmTid,
    this.resultInfo,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    merchantTransactionId: json["merchantTransactionId"],
    paytmMid: json["paytmMid"],
    paytmTid: json["paytmTid"],
    resultInfo: json["resultInfo"] == null ? null : ResultInfo.fromJson(json["resultInfo"]),
  );

  Map<String, dynamic> toJson() => {
    "merchantTransactionId": merchantTransactionId,
    "paytmMid": paytmMid,
    "paytmTid": paytmTid,
    "resultInfo": resultInfo?.toJson(),
  };
}

class ResultInfo {
  String? resultStatus;
  String? resultCode;
  String? resultMsg;
  String? resultCodeId;

  ResultInfo({
    this.resultStatus,
    this.resultCode,
    this.resultMsg,
    this.resultCodeId,
  });

  factory ResultInfo.fromJson(Map<String, dynamic> json) => ResultInfo(
    resultStatus: json["resultStatus"],
    resultCode: json["resultCode"],
    resultMsg: json["resultMsg"],
    resultCodeId: json["resultCodeId"],
  );

  Map<String, dynamic> toJson() => {
    "resultStatus": resultStatus,
    "resultCode": resultCode,
    "resultMsg": resultMsg,
    "resultCodeId": resultCodeId,
  };
}

class Head {
  String? requestTimeStamp;
  String? channelId;
  String? checksum;
  String? version;

  Head({
    this.requestTimeStamp,
    this.channelId,
    this.checksum,
    this.version,
  });

  factory Head.fromJson(Map<String, dynamic> json) => Head(
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
