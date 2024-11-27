// To parse this JSON data, do
//
//     final ordersOnHoldRequest = ordersOnHoldRequestFromJson(jsonString);

import 'dart:convert';

OrdersOnHoldRequest ordersOnHoldRequestFromJson(dynamic str) =>
    OrdersOnHoldRequest.fromJson(json.decode(str));

String ordersOnHoldRequestToJson(OrdersOnHoldRequest data) =>
    json.encode(data.toJson());

class OrdersOnHoldRequest {
  String? outletId;

  OrdersOnHoldRequest({
    this.outletId,
  });

  factory OrdersOnHoldRequest.fromJson(Map<String, dynamic> json) =>
      OrdersOnHoldRequest(
        outletId: json["outlet_id"],
      );

  Map<String, dynamic> toJson() => {
        "outlet_id": outletId,
      };
}
