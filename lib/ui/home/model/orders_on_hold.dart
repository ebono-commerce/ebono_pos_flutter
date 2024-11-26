// To parse this JSON data, do
//
//     final ordersOnHoldResponse = ordersOnHoldResponseFromJson(jsonString);

import 'dart:convert';

OrdersOnHoldResponse ordersOnHoldResponseFromJson(dynamic str) =>
    OrdersOnHoldResponse.fromJson(json.decode(str));

String ordersOnHoldResponseToJson(OrdersOnHoldResponse data) =>
    json.encode(data.toJson());

class OrdersOnHoldResponse {
  List<OnHoldItems>? data;
  Meta? meta;

  OrdersOnHoldResponse({
    this.data,
    this.meta,
  });

  factory OrdersOnHoldResponse.fromJson(Map<String, dynamic> json) =>
      OrdersOnHoldResponse(
        data: json["data"] == null
            ? []
            : List<OnHoldItems>.from(
                json["data"]!.map((x) => OnHoldItems.fromJson(x))),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "meta": meta?.toJson(),
      };
}

class OnHoldItems {
  String? holdCartId;
  HoldOrderPhoneNumber? phoneNumber;
  HoldOrderCustomer? customer;
  String? createdAt;
  CashierDetails? cashierDetails;

  OnHoldItems({
    this.holdCartId,
    this.phoneNumber,
    this.customer,
    this.createdAt,
    this.cashierDetails,
  });

  factory OnHoldItems.fromJson(Map<String, dynamic> json) => OnHoldItems(
        holdCartId: json["hold_cart_id"],
        phoneNumber: json["phone_number"] == null
            ? null
            : HoldOrderPhoneNumber.fromJson(json["phone_number"]),
        customer: json["customer"] == null
            ? null
            : HoldOrderCustomer.fromJson(json["customer"]),
        createdAt: json["created_at"],
        cashierDetails: json["cashier_details"] == null
            ? null
            : CashierDetails.fromJson(json["cashier_details"]),
      );

  Map<String, dynamic> toJson() => {
        "hold_cart_id": holdCartId,
        "phone_number": phoneNumber?.toJson(),
        "customer": customer?.toJson(),
        "created_at": createdAt,
        "cashier_details": cashierDetails?.toJson(),
      };
}

class CashierDetails {
  String? cashierId;
  String? cashierName;

  CashierDetails({
    this.cashierId,
    this.cashierName,
  });

  factory CashierDetails.fromJson(Map<String, dynamic> json) => CashierDetails(
        cashierId: json["cashier_id"],
        cashierName: json["cashier_name"],
      );

  Map<String, dynamic> toJson() => {
        "cashier_id": cashierId,
        "cashier_name": cashierName,
      };
}

class HoldOrderCustomer {
  String? customerName;

  HoldOrderCustomer({
    this.customerName,
  });

  factory HoldOrderCustomer.fromJson(Map<String, dynamic> json) =>
      HoldOrderCustomer(
        customerName: json["customer_name"],
      );

  Map<String, dynamic> toJson() => {
        "customer_name": customerName,
      };
}

class HoldOrderPhoneNumber {
  String? countryCode;
  String? number;

  HoldOrderPhoneNumber({
    this.countryCode,
    this.number,
  });

  factory HoldOrderPhoneNumber.fromJson(Map<String, dynamic> json) =>
      HoldOrderPhoneNumber(
        countryCode: json["country_code"],
        number: json["number"],
      );

  Map<String, dynamic> toJson() => {
        "country_code": countryCode,
        "number": number,
      };
}

class Meta {
  Pagination? pagination;

  Meta({
    this.pagination,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "pagination": pagination?.toJson(),
      };
}

class Pagination {
  int? currentPage;
  int? pageSize;
  int? totalItems;
  int? totalPages;

  Pagination({
    this.currentPage,
    this.pageSize,
    this.totalItems,
    this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        currentPage: json["current_page"],
        pageSize: json["page_size"],
        totalItems: json["total_items"],
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "page_size": pageSize,
        "total_items": totalItems,
        "total_pages": totalPages,
      };
}
