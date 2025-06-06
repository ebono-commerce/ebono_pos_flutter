// To parse this JSON data, do
//
//     final paytmPaymentStatusResponse = paytmPaymentStatusResponseFromJson(jsonString);

import 'dart:convert';

PaytmPaymentStatusResponse paytmPaymentStatusResponseFromJson(String str) => PaytmPaymentStatusResponse.fromJson(json.decode(str));

String paytmPaymentStatusResponseToJson(PaytmPaymentStatusResponse data) => json.encode(data.toJson());

class PaytmPaymentStatusResponse {
  Head? head;
  Body? body;

  PaytmPaymentStatusResponse({
    this.head,
    this.body,
  });

  factory PaytmPaymentStatusResponse.fromJson(Map<String, dynamic> json) => PaytmPaymentStatusResponse(
    head: json["head"] == null ? null : Head.fromJson(json["head"]),
    body: json["body"] == null ? null : Body.fromJson(json["body"]),
  );

  Map<String, dynamic> toJson() => {
    "head": head?.toJson(),
    "body": body?.toJson(),
  };
}

class Body {
  String? paytmMid;
  String? paytmTid;
  String? transactionDateTime;
  String? merchantTransactionId;
  String? merchantReferenceNo;
  String? transactionAmount;
  String? acquirementId;
  String? retrievalReferenceNo;
  String? authCode;
  String? issuerMaskCardNo;
  String? issuingBankName;
  String? bankResponseCode;
  String? bankResponseMessage;
  String? bankMid;
  String? bankTid;
  ResultInfo? resultInfo;
  dynamic merchantExtendedInfo;
  dynamic extendedInfo;
  String? aid;
  String? payMethod;
  String? cardType;
  String? cardScheme;
  String? acquiringBank;
  ProductDetails? productDetails;
  EmiDetails? emiDetails;
  CashbackDetails? cashbackDetails;

  Body({
    this.paytmMid,
    this.paytmTid,
    this.transactionDateTime,
    this.merchantTransactionId,
    this.merchantReferenceNo,
    this.transactionAmount,
    this.acquirementId,
    this.retrievalReferenceNo,
    this.authCode,
    this.issuerMaskCardNo,
    this.issuingBankName,
    this.bankResponseCode,
    this.bankResponseMessage,
    this.bankMid,
    this.bankTid,
    this.resultInfo,
    this.merchantExtendedInfo,
    this.extendedInfo,
    this.aid,
    this.payMethod,
    this.cardType,
    this.cardScheme,
    this.acquiringBank,
    this.productDetails,
    this.emiDetails,
    this.cashbackDetails,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    paytmMid: json["paytmMid"],
    paytmTid: json["paytmTid"],
    transactionDateTime: json["transactionDateTime"],
    merchantTransactionId: json["merchantTransactionId"],
    merchantReferenceNo: json["merchantReferenceNo"],
    transactionAmount: json["transactionAmount"],
    acquirementId: json["acquirementId"],
    retrievalReferenceNo: json["retrievalReferenceNo"],
    authCode: json["authCode"],
    issuerMaskCardNo: json["issuerMaskCardNo"],
    issuingBankName: json["issuingBankName"],
    bankResponseCode: json["bankResponseCode"],
    bankResponseMessage: json["bankResponseMessage"],
    bankMid: json["bankMid"],
    bankTid: json["bankTid"],
    resultInfo: json["resultInfo"] == null ? null : ResultInfo.fromJson(json["resultInfo"]),
    merchantExtendedInfo: json["merchantExtendedInfo"],
    extendedInfo: json["extendedInfo"],
    aid: json["aid"],
    payMethod: json["payMethod"],
    cardType: json["cardType"],
    cardScheme: json["cardScheme"],
    acquiringBank: json["acquiringBank"],
    productDetails: json["productDetails"] == null ? null : ProductDetails.fromJson(json["productDetails"]),
    emiDetails: json["emiDetails"] == null ? null : EmiDetails.fromJson(json["emiDetails"]),
    cashbackDetails: json["cashbackDetails"] == null ? null : CashbackDetails.fromJson(json["cashbackDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "paytmMid": paytmMid,
    "paytmTid": paytmTid,
    "transactionDateTime": transactionDateTime,
    "merchantTransactionId": merchantTransactionId,
    "merchantReferenceNo": merchantReferenceNo,
    "transactionAmount": transactionAmount,
    "acquirementId": acquirementId,
    "retrievalReferenceNo": retrievalReferenceNo,
    "authCode": authCode,
    "issuerMaskCardNo": issuerMaskCardNo,
    "issuingBankName": issuingBankName,
    "bankResponseCode": bankResponseCode,
    "bankResponseMessage": bankResponseMessage,
    "bankMid": bankMid,
    "bankTid": bankTid,
    "resultInfo": resultInfo?.toJson(),
    "merchantExtendedInfo": merchantExtendedInfo,
    "extendedInfo": extendedInfo,
    "aid": aid,
    "payMethod": payMethod,
    "cardType": cardType,
    "cardScheme": cardScheme,
    "acquiringBank": acquiringBank,
    "productDetails": productDetails?.toJson(),
    "emiDetails": emiDetails?.toJson(),
    "cashbackDetails": cashbackDetails?.toJson(),
  };
}

class CashbackDetails {
  String? bankOfferApplied;
  String? bankOfferType;
  String? bankOfferAmount;
  String? subventionCreated;
  String? subventionType;
  String? subventionOfferAmount;

  CashbackDetails({
    this.bankOfferApplied,
    this.bankOfferType,
    this.bankOfferAmount,
    this.subventionCreated,
    this.subventionType,
    this.subventionOfferAmount,
  });

  factory CashbackDetails.fromJson(Map<String, dynamic> json) => CashbackDetails(
    bankOfferApplied: json["bankOfferApplied"],
    bankOfferType: json["bankOfferType"],
    bankOfferAmount: json["bankOfferAmount"],
    subventionCreated: json["subventionCreated"],
    subventionType: json["subventionType"],
    subventionOfferAmount: json["subventionOfferAmount"],
  );

  Map<String, dynamic> toJson() => {
    "bankOfferApplied": bankOfferApplied,
    "bankOfferType": bankOfferType,
    "bankOfferAmount": bankOfferAmount,
    "subventionCreated": subventionCreated,
    "subventionType": subventionType,
    "subventionOfferAmount": subventionOfferAmount,
  };
}

class EmiDetails {
  String? txnType;
  String? baseAmount;
  String? tenure;
  String? emiInterestRate;
  String? emiMonthlyAmount;
  String? emiTotalAmount;

  EmiDetails({
    this.txnType,
    this.baseAmount,
    this.tenure,
    this.emiInterestRate,
    this.emiMonthlyAmount,
    this.emiTotalAmount,
  });

  factory EmiDetails.fromJson(Map<String, dynamic> json) => EmiDetails(
    txnType: json["txnType"],
    baseAmount: json["baseAmount"],
    tenure: json["tenure"],
    emiInterestRate: json["emiInterestRate"],
    emiMonthlyAmount: json["emiMonthlyAmount"],
    emiTotalAmount: json["emiTotalAmount"],
  );

  Map<String, dynamic> toJson() => {
    "txnType": txnType,
    "baseAmount": baseAmount,
    "tenure": tenure,
    "emiInterestRate": emiInterestRate,
    "emiMonthlyAmount": emiMonthlyAmount,
    "emiTotalAmount": emiTotalAmount,
  };
}

class ProductDetails {
  String? manufacturer;
  String? category;
  String? productSerialNoType;
  String? productSerialNoValue;
  String? productCode;
  String? modelName;

  ProductDetails({
    this.manufacturer,
    this.category,
    this.productSerialNoType,
    this.productSerialNoValue,
    this.productCode,
    this.modelName,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) => ProductDetails(
    manufacturer: json["manufacturer"],
    category: json["category"],
    productSerialNoType: json["productSerialNoType"],
    productSerialNoValue: json["productSerialNoValue"],
    productCode: json["productCode"],
    modelName: json["modelName"],
  );

  Map<String, dynamic> toJson() => {
    "manufacturer": manufacturer,
    "category": category,
    "productSerialNoType": productSerialNoType,
    "productSerialNoValue": productSerialNoValue,
    "productCode": productCode,
    "modelName": modelName,
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
  String? responseTimestamp;
  String? channelId;
  String? version;
  String? checksum;

  Head({
    this.responseTimestamp,
    this.channelId,
    this.version,
    this.checksum,
  });

  factory Head.fromJson(Map<String, dynamic> json) => Head(
    responseTimestamp: json["responseTimestamp"],
    channelId: json["channelId"],
    version: json["version"],
    checksum: json["checksum"],
  );

  Map<String, dynamic> toJson() => {
    "responseTimestamp": responseTimestamp,
    "channelId": channelId,
    "version": version,
    "checksum": checksum,
  };
}
