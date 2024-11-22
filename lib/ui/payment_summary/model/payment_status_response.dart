// To parse this JSON data, do
//
//     final paymentStatusResponse = paymentStatusResponseFromJson(jsonString);

import 'dart:convert';

PaymentStatusResponse paymentStatusResponseFromJson(dynamic str) =>
    PaymentStatusResponse.fromJson(json.decode(str));

String paymentStatusResponseToJson(PaymentStatusResponse data) =>
    json.encode(data.toJson());

class PaymentStatusResponse {
  bool? success;
  String? messageCode;
  String? message;
  String? realCode;
  String? sessionKey;
  String? username;
  List<dynamic>? apps;
  bool? enableRki;
  List<dynamic>? states;
  bool? dccOpted;
  int? cardHolderCurrencyExponent;
  bool? signable;
  bool? voidable;
  bool? refundable;
  int? maximumPayAttemptsAllowed;
  int? maximumSuccessfulPaymentAllowed;
  bool? noExpiryFlag;
  bool? signReqd;
  bool? customerNameAvailable;
  bool? callbackEnabled;
  bool? onlineRefundable;
  bool? manualRefund;
  bool? shouldRoundOffExchangeRate;
  bool? shouldRoundOffConvertedAmount;
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
  bool? twoStepConfirmPreAuth;
  bool? reload;
  bool? redirect;

  PaymentStatusResponse({
    this.success,
    this.messageCode,
    this.message,
    this.realCode,
    this.sessionKey,
    this.username,
    this.apps,
    this.enableRki,
    this.states,
    this.dccOpted,
    this.cardHolderCurrencyExponent,
    this.signable,
    this.voidable,
    this.refundable,
    this.maximumPayAttemptsAllowed,
    this.maximumSuccessfulPaymentAllowed,
    this.noExpiryFlag,
    this.signReqd,
    this.customerNameAvailable,
    this.callbackEnabled,
    this.onlineRefundable,
    this.manualRefund,
    this.shouldRoundOffExchangeRate,
    this.shouldRoundOffConvertedAmount,
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
    this.twoStepConfirmPreAuth,
    this.reload,
    this.redirect,
  });

  factory PaymentStatusResponse.fromJson(Map<String, dynamic> json) =>
      PaymentStatusResponse(
        success: json["success"],
        messageCode: json["messageCode"],
        message: json["message"],
        realCode: json["realCode"],
        sessionKey: json["sessionKey"],
        username: json["username"],
        apps: json["apps"] == null
            ? []
            : List<dynamic>.from(json["apps"]!.map((x) => x)),
        enableRki: json["enableRki"],
        states: json["states"] == null
            ? []
            : List<dynamic>.from(json["states"]!.map((x) => x)),
        dccOpted: json["dccOpted"],
        cardHolderCurrencyExponent: json["cardHolderCurrencyExponent"],
        signable: json["signable"],
        voidable: json["voidable"],
        refundable: json["refundable"],
        maximumPayAttemptsAllowed: json["maximumPayAttemptsAllowed"],
        maximumSuccessfulPaymentAllowed:
            json["maximumSuccessfulPaymentAllowed"],
        noExpiryFlag: json["noExpiryFlag"],
        signReqd: json["signReqd"],
        customerNameAvailable: json["customerNameAvailable"],
        callbackEnabled: json["callbackEnabled"],
        onlineRefundable: json["onlineRefundable"],
        manualRefund: json["manualRefund"],
        shouldRoundOffExchangeRate: json["shouldRoundOffExchangeRate"],
        shouldRoundOffConvertedAmount: json["shouldRoundOffConvertedAmount"],
        tipEnabled: json["tipEnabled"],
        callTc: json["callTC"],
        acquisitionId: json["acquisitionId"],
        acquisitionKey: json["acquisitionKey"],
        processCronOutput: json["processCronOutput"],
        externalDevice: json["externalDevice"],
        tipAdjusted: json["tipAdjusted"],
        txnMetadata: json["txnMetadata"] == null
            ? []
            : List<dynamic>.from(json["txnMetadata"]!.map((x) => x)),
        middlewareStanNumber: json["middlewareStanNumber"],
        otpRequired: json["otpRequired"],
        abstractPaymentStatus: json["abstractPaymentStatus"],
        p2PRequestId: json["p2pRequestId"],
        twoStepConfirmPreAuth: json["twoStepConfirmPreAuth"],
        reload: json["reload"],
        redirect: json["redirect"],
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
        "states":
            states == null ? [] : List<dynamic>.from(states!.map((x) => x)),
        "dccOpted": dccOpted,
        "cardHolderCurrencyExponent": cardHolderCurrencyExponent,
        "signable": signable,
        "voidable": voidable,
        "refundable": refundable,
        "maximumPayAttemptsAllowed": maximumPayAttemptsAllowed,
        "maximumSuccessfulPaymentAllowed": maximumSuccessfulPaymentAllowed,
        "noExpiryFlag": noExpiryFlag,
        "signReqd": signReqd,
        "customerNameAvailable": customerNameAvailable,
        "callbackEnabled": callbackEnabled,
        "onlineRefundable": onlineRefundable,
        "manualRefund": manualRefund,
        "shouldRoundOffExchangeRate": shouldRoundOffExchangeRate,
        "shouldRoundOffConvertedAmount": shouldRoundOffConvertedAmount,
        "tipEnabled": tipEnabled,
        "callTC": callTc,
        "acquisitionId": acquisitionId,
        "acquisitionKey": acquisitionKey,
        "processCronOutput": processCronOutput,
        "externalDevice": externalDevice,
        "tipAdjusted": tipAdjusted,
        "txnMetadata": txnMetadata == null
            ? []
            : List<dynamic>.from(txnMetadata!.map((x) => x)),
        "middlewareStanNumber": middlewareStanNumber,
        "otpRequired": otpRequired,
        "abstractPaymentStatus": abstractPaymentStatus,
        "p2pRequestId": p2PRequestId,
        "twoStepConfirmPreAuth": twoStepConfirmPreAuth,
        "reload": reload,
        "redirect": redirect,
      };
}
