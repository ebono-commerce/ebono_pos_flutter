import 'dart:convert';

PlaceOrderRequest placeOrderRequestFromJson(String str) => PlaceOrderRequest.fromJson(json.decode(str));

String placeOrderRequestToJson(PlaceOrderRequest data) => json.encode(data.toJson());

class PlaceOrderRequest {
  String? cartId;
  String? phoneNumber;
  String? cartType;
  List<PaymentMethod>? paymentMethods;

  PlaceOrderRequest({
    this.cartId,
    this.phoneNumber,
    this.cartType,
    this.paymentMethods,
  });

  factory PlaceOrderRequest.fromJson(Map<String, dynamic> json) => PlaceOrderRequest(
    cartId: json["cart_id"],
    phoneNumber: json["phone_number"],
    cartType: json["cart_type"],
    paymentMethods: json["payment_methods"] == null ? [] : List<PaymentMethod>.from(json["payment_methods"]!.map((x) => PaymentMethod.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "cart_id": cartId,
    "phone_number": phoneNumber,
    "cart_type": cartType,
    "payment_methods": paymentMethods == null ? [] : List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
  };
}

class PaymentMethod {
  String? paymentOptionId;
  String? pspId;
  String? requestId;
  String? transactionReferenceId;
  double? amount;
  List<MethodDetail>? methodDetail;

  PaymentMethod({
    this.paymentOptionId,
    this.pspId,
    this.requestId,
    this.transactionReferenceId,
    this.amount,
    this.methodDetail,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    paymentOptionId: json["payment_option_id"],
    pspId: json["psp_id"],
    requestId: json["request_id"],
    transactionReferenceId: json["transaction_reference_id"],
    amount: json["amount"],
    methodDetail: json["method_detail"] == null ? [] : List<MethodDetail>.from(json["method_detail"]!.map((x) => MethodDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "payment_option_id": paymentOptionId,
    "psp_id": pspId,
    "request_id": requestId,
    "transaction_reference_id": transactionReferenceId,
    "amount": amount,
    "method_detail": methodDetail == null ? [] : List<dynamic>.from(methodDetail!.map((x) => x.toJson())),
  };
}

class MethodDetail {
  String? key;
  String? value;

  MethodDetail({
    this.key,
    this.value,
  });

  factory MethodDetail.fromJson(Map<String, dynamic> json) => MethodDetail(
    key: json["key"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "value": value,
  };
}
