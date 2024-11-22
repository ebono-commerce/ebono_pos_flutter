import 'dart:convert';

PaymentSummaryRequest paymentSummaryRequestFromJson(String str) =>
    PaymentSummaryRequest.fromJson(json.decode(str));

String paymentSummaryRequestToJson(PaymentSummaryRequest data) =>
    json.encode(data.toJson());

class PaymentSummaryRequest {
  String? phoneNumber;
  String? cartId;
  Customer? customer;
  String? cartType;

  PaymentSummaryRequest({
    this.phoneNumber,
    this.cartId,
    this.customer,
    this.cartType,
  });

  factory PaymentSummaryRequest.fromJson(Map<String, dynamic> json) =>
      PaymentSummaryRequest(
        phoneNumber: json["phone_number"],
        cartId: json["cart_id"],
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
        cartType: json["cart_type"],
      );

  Map<String, dynamic> toJson() => {
        "phone_number": phoneNumber,
        "cart_id": cartId,
        if (customer != null) "customer": customer?.toJson(),
        "cart_type": cartType,
      };
}

class Customer {
  String? customerId;

  Customer({
    this.customerId,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        customerId: json["customer_id"],
      );

  Map<String, dynamic> toJson() => {
        "customer_id": customerId,
      };
}
