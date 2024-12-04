import 'dart:convert';

PaymentStatusResponse paymentStatusResponseFromJson(str) => PaymentStatusResponse.fromJson(json.decode(str));

String paymentStatusResponseToJson(PaymentStatusResponse data) => json.encode(data.toJson());

class PaymentStatusResponse {
  bool? success;
  String? messageCode;
  String? message;
  String? realCode;
  String? sessionKey;
  String? username;
  List<dynamic>? apps;
  bool? enableRki;
  String? tid;
  int? amount;
  int? amountAdditional;
  int? amountOriginal;
  int? amountCashBack;
  String? authCode;
  String? batchNumber;
  String? cardLastFourDigit;
  String? currencyCode;
  String? customerName;
  String? customerMobile;
  String? customerEmail;
  String? customerReceiptUrl;
  String? deviceSerial;
  String? externalRefNumber;
  String? formattedPan;
  String? txnId;
  String? latitude;
  String? longitude;
  String? merchantName;
  String? mid;
  String? nonceStatus;
  String? orgCode;
  String? merchantCode;
  String? payerName;
  String? paymentCardBin;
  String? paymentCardBrand;
  String? paymentCardType;
  String? paymentMode;
  String? pgInvoiceNumber;
  int? postingDate;
  String? processCode;
  String? rrNumber;
  String? settlementStatus;
  String? signatureId;
  String? status;
  List<String>? states;
  String? userMobile;
  String? txnType;
  bool? dccOpted;
  int? cardHolderCurrencyExponent;
  String? userAgreement;
  bool? signable;
  bool? voidable;
  bool? refundable;
  String? chargeSlipDate;
  String? readableChargeSlipDate;
  String? cardTxnTypeDesc;
  int? maximumPayAttemptsAllowed;
  int? maximumSuccessfulPaymentAllowed;
  bool? noExpiryFlag;
  String? dxMode;
  String? receiptUrl;
  bool? signReqd;
  String? txnTypeDesc;
  String? paymentGateway;
  String? acquirerCode;
  int? createdTime;
  bool? customerNameAvailable;
  bool? callbackEnabled;
  bool? onlineRefundable;
  bool? manualRefund;
  int? shiftNo;
  bool? shouldRoundOffExchangeRate;
  bool? shouldRoundOffConvertedAmount;
  int? additionalAmount;
  String? orderNumber;
  String? reverseReferenceNumber;
  int? totalAmount;
  String? displayPan;
  String? nameOnCard;
  String? invoiceNumber;
  String? cardType;
  bool? tipEnabled;
  bool? callTc;
  String? acquisitionId;
  String? acquisitionKey;
  bool? processCronOutput;
  bool? externalDevice;
  bool? tipAdjusted;
  List<dynamic>? txnMetadata;
  int? middlewareStanNumber;
  bool? otpRequired;
  String? abstractPaymentStatus;
  String? p2PRequestId;
  bool? redirect;
  bool? reload;
  bool? twoStepConfirmPreAuth;

  PaymentStatusResponse({
    this.success,
    this.messageCode,
    this.message,
    this.realCode,
    this.sessionKey,
    this.username,
    this.apps,
    this.enableRki,
    this.tid,
    this.amount,
    this.amountAdditional,
    this.amountOriginal,
    this.amountCashBack,
    this.authCode,
    this.batchNumber,
    this.cardLastFourDigit,
    this.currencyCode,
    this.customerName,
    this.customerMobile,
    this.customerEmail,
    this.customerReceiptUrl,
    this.deviceSerial,
    this.externalRefNumber,
    this.formattedPan,
    this.txnId,
    this.latitude,
    this.longitude,
    this.merchantName,
    this.mid,
    this.nonceStatus,
    this.orgCode,
    this.merchantCode,
    this.payerName,
    this.paymentCardBin,
    this.paymentCardBrand,
    this.paymentCardType,
    this.paymentMode,
    this.pgInvoiceNumber,
    this.postingDate,
    this.processCode,
    this.rrNumber,
    this.settlementStatus,
    this.signatureId,
    this.status,
    this.states,
    this.userMobile,
    this.txnType,
    this.dccOpted,
    this.cardHolderCurrencyExponent,
    this.userAgreement,
    this.signable,
    this.voidable,
    this.refundable,
    this.chargeSlipDate,
    this.readableChargeSlipDate,
    this.cardTxnTypeDesc,
    this.maximumPayAttemptsAllowed,
    this.maximumSuccessfulPaymentAllowed,
    this.noExpiryFlag,
    this.dxMode,
    this.receiptUrl,
    this.signReqd,
    this.txnTypeDesc,
    this.paymentGateway,
    this.acquirerCode,
    this.createdTime,
    this.customerNameAvailable,
    this.callbackEnabled,
    this.onlineRefundable,
    this.manualRefund,
    this.shiftNo,
    this.shouldRoundOffExchangeRate,
    this.shouldRoundOffConvertedAmount,
    this.additionalAmount,
    this.orderNumber,
    this.reverseReferenceNumber,
    this.totalAmount,
    this.displayPan,
    this.nameOnCard,
    this.invoiceNumber,
    this.cardType,
    this.tipEnabled,
    this.callTc,
    this.acquisitionId,
    this.acquisitionKey,
    this.processCronOutput,
    this.externalDevice,
    this.tipAdjusted,
    this.txnMetadata,
    this.middlewareStanNumber,
    this.otpRequired,
    this.abstractPaymentStatus,
    this.p2PRequestId,
    this.redirect,
    this.reload,
    this.twoStepConfirmPreAuth,
  });

  factory PaymentStatusResponse.fromJson(Map<String, dynamic> json) => PaymentStatusResponse(
    success: json["success"],
    messageCode: json["messageCode"],
    message: json["message"],
    realCode: json["realCode"],
    sessionKey: json["sessionKey"],
    username: json["username"],
    apps: json["apps"] == null ? [] : List<dynamic>.from(json["apps"]!.map((x) => x)),
    enableRki: json["enableRki"],
    tid: json["tid"],
    amount: json["amount"],
    amountAdditional: json["amountAdditional"],
    amountOriginal: json["amountOriginal"],
    amountCashBack: json["amountCashBack"],
    authCode: json["authCode"],
    batchNumber: json["batchNumber"],
    cardLastFourDigit: json["cardLastFourDigit"],
    currencyCode: json["currencyCode"],
    customerName: json["customerName"],
    customerMobile: json["customerMobile"],
    customerEmail: json["customerEmail"],
    customerReceiptUrl: json["customerReceiptUrl"],
    deviceSerial: json["deviceSerial"],
    externalRefNumber: json["externalRefNumber"],
    formattedPan: json["formattedPan"],
    txnId: json["txnId"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    merchantName: json["merchantName"],
    mid: json["mid"],
    nonceStatus: json["nonceStatus"],
    orgCode: json["orgCode"],
    merchantCode: json["merchantCode"],
    payerName: json["payerName"],
    paymentCardBin: json["paymentCardBin"],
    paymentCardBrand: json["paymentCardBrand"],
    paymentCardType: json["paymentCardType"],
    paymentMode: json["paymentMode"],
    pgInvoiceNumber: json["pgInvoiceNumber"],
    postingDate: json["postingDate"],
    processCode: json["processCode"],
    rrNumber: json["rrNumber"],
    settlementStatus: json["settlementStatus"],
    signatureId: json["signatureId"],
    status: json["status"],
    states: json["states"] == null ? [] : List<String>.from(json["states"]!.map((x) => x)),
    userMobile: json["userMobile"],
    txnType: json["txnType"],
    dccOpted: json["dccOpted"],
    cardHolderCurrencyExponent: json["cardHolderCurrencyExponent"],
    userAgreement: json["userAgreement"],
    signable: json["signable"],
    voidable: json["voidable"],
    refundable: json["refundable"],
    chargeSlipDate: json["chargeSlipDate"],
    readableChargeSlipDate: json["readableChargeSlipDate"],
    cardTxnTypeDesc: json["cardTxnTypeDesc"],
    maximumPayAttemptsAllowed: json["maximumPayAttemptsAllowed"],
    maximumSuccessfulPaymentAllowed: json["maximumSuccessfulPaymentAllowed"],
    noExpiryFlag: json["noExpiryFlag"],
    dxMode: json["dxMode"],
    receiptUrl: json["receiptUrl"],
    signReqd: json["signReqd"],
    txnTypeDesc: json["txnTypeDesc"],
    paymentGateway: json["paymentGateway"],
    acquirerCode: json["acquirerCode"],
    createdTime: json["createdTime"],
    customerNameAvailable: json["customerNameAvailable"],
    callbackEnabled: json["callbackEnabled"],
    onlineRefundable: json["onlineRefundable"],
    manualRefund: json["manualRefund"],
    shiftNo: json["shiftNo"],
    shouldRoundOffExchangeRate: json["shouldRoundOffExchangeRate"],
    shouldRoundOffConvertedAmount: json["shouldRoundOffConvertedAmount"],
    additionalAmount: json["additionalAmount"],
    orderNumber: json["orderNumber"],
    reverseReferenceNumber: json["reverseReferenceNumber"],
    totalAmount: json["totalAmount"],
    displayPan: json["displayPAN"],
    nameOnCard: json["nameOnCard"],
    invoiceNumber: json["invoiceNumber"],
    cardType: json["cardType"],
    tipEnabled: json["tipEnabled"],
    callTc: json["callTC"],
    acquisitionId: json["acquisitionId"],
    acquisitionKey: json["acquisitionKey"],
    processCronOutput: json["processCronOutput"],
    externalDevice: json["externalDevice"],
    tipAdjusted: json["tipAdjusted"],
    txnMetadata: json["txnMetadata"] == null ? [] : List<dynamic>.from(json["txnMetadata"]!.map((x) => x)),
    middlewareStanNumber: json["middlewareStanNumber"],
    otpRequired: json["otpRequired"],
    abstractPaymentStatus: json["abstractPaymentStatus"],
    p2PRequestId: json["p2pRequestId"],
    redirect: json["redirect"],
    reload: json["reload"],
    twoStepConfirmPreAuth: json["twoStepConfirmPreAuth"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "messageCode": messageCode,
    "message": message,
    "realCode": realCode,
    "sessionKey": sessionKey,
    "username": username,
    "apps": apps == null ? [] : List<dynamic>.from(apps!.map((x) => x)),
    "enableRki": enableRki,
    "tid": tid,
    "amount": amount,
    "amountAdditional": amountAdditional,
    "amountOriginal": amountOriginal,
    "amountCashBack": amountCashBack,
    "authCode": authCode,
    "batchNumber": batchNumber,
    "cardLastFourDigit": cardLastFourDigit,
    "currencyCode": currencyCode,
    "customerName": customerName,
    "customerMobile": customerMobile,
    "customerEmail": customerEmail,
    "customerReceiptUrl": customerReceiptUrl,
    "deviceSerial": deviceSerial,
    "externalRefNumber": externalRefNumber,
    "formattedPan": formattedPan,
    "txnId": txnId,
    "latitude": latitude,
    "longitude": longitude,
    "merchantName": merchantName,
    "mid": mid,
    "nonceStatus": nonceStatus,
    "orgCode": orgCode,
    "merchantCode": merchantCode,
    "payerName": payerName,
    "paymentCardBin": paymentCardBin,
    "paymentCardBrand": paymentCardBrand,
    "paymentCardType": paymentCardType,
    "paymentMode": paymentMode,
    "pgInvoiceNumber": pgInvoiceNumber,
    "postingDate": postingDate,
    "processCode": processCode,
    "rrNumber": rrNumber,
    "settlementStatus": settlementStatus,
    "signatureId": signatureId,
    "status": status,
    "states": states == null ? [] : List<dynamic>.from(states!.map((x) => x)),
    "userMobile": userMobile,
    "txnType": txnType,
    "dccOpted": dccOpted,
    "cardHolderCurrencyExponent": cardHolderCurrencyExponent,
    "userAgreement": userAgreement,
    "signable": signable,
    "voidable": voidable,
    "refundable": refundable,
    "chargeSlipDate": chargeSlipDate,
    "readableChargeSlipDate": readableChargeSlipDate,
    "cardTxnTypeDesc": cardTxnTypeDesc,
    "maximumPayAttemptsAllowed": maximumPayAttemptsAllowed,
    "maximumSuccessfulPaymentAllowed": maximumSuccessfulPaymentAllowed,
    "noExpiryFlag": noExpiryFlag,
    "dxMode": dxMode,
    "receiptUrl": receiptUrl,
    "signReqd": signReqd,
    "txnTypeDesc": txnTypeDesc,
    "paymentGateway": paymentGateway,
    "acquirerCode": acquirerCode,
    "createdTime": createdTime,
    "customerNameAvailable": customerNameAvailable,
    "callbackEnabled": callbackEnabled,
    "onlineRefundable": onlineRefundable,
    "manualRefund": manualRefund,
    "shiftNo": shiftNo,
    "shouldRoundOffExchangeRate": shouldRoundOffExchangeRate,
    "shouldRoundOffConvertedAmount": shouldRoundOffConvertedAmount,
    "additionalAmount": additionalAmount,
    "orderNumber": orderNumber,
    "reverseReferenceNumber": reverseReferenceNumber,
    "totalAmount": totalAmount,
    "displayPAN": displayPan,
    "nameOnCard": nameOnCard,
    "invoiceNumber": invoiceNumber,
    "cardType": cardType,
    "tipEnabled": tipEnabled,
    "callTC": callTc,
    "acquisitionId": acquisitionId,
    "acquisitionKey": acquisitionKey,
    "processCronOutput": processCronOutput,
    "externalDevice": externalDevice,
    "tipAdjusted": tipAdjusted,
    "txnMetadata": txnMetadata == null ? [] : List<dynamic>.from(txnMetadata!.map((x) => x)),
    "middlewareStanNumber": middlewareStanNumber,
    "otpRequired": otpRequired,
    "abstractPaymentStatus": abstractPaymentStatus,
    "p2pRequestId": p2PRequestId,
    "redirect": redirect,
    "reload": reload,
    "twoStepConfirmPreAuth": twoStepConfirmPreAuth,
  };
}
