// To parse this JSON data, do
//
//     final scanProductsResponse = scanProductsResponseFromJson(jsonString);

import 'dart:convert';

ScanProductsResponse scanProductsResponseFromJson(String str) =>
    ScanProductsResponse.fromJson(json.decode(str));

String scanProductsResponseToJson(ScanProductsResponse data) =>
    json.encode(data.toJson());

class ScanProductsResponse {
  String? skuCode;
  String? salesUom;
  String? skuTitle;
  int? packOf;
  bool? isWeighedItem;
  String? productType;
  List<PriceList>? priceList;
  List<dynamic>? bundleConfiguration;
  String? mediaUrl;
  FreebieInfo? freebieInfo;
  bool? isActive;
  bool isError;

  ScanProductsResponse({
    this.skuCode,
    this.salesUom,
    this.skuTitle,
    this.packOf,
    this.isWeighedItem,
    this.productType,
    this.priceList,
    this.bundleConfiguration,
    this.mediaUrl,
    this.freebieInfo,
    this.isActive,
    this.isError = false,
  });

  factory ScanProductsResponse.fromJson(Map<String, dynamic> json) =>
      ScanProductsResponse(
        skuCode: json["sku_code"],
        salesUom: json["sale_uom"],
        skuTitle: json["sku_title"],
        packOf: json["pack_of"],
        isWeighedItem: json["is_weighed_item"],
        productType: json["product_type"],
        priceList: json["price_list"] == null
            ? []
            : List<PriceList>.from(
                json["price_list"]!.map((x) => PriceList.fromJson(x))),
        bundleConfiguration: json["bundle_configuration"] == null
            ? []
            : List<dynamic>.from(json["bundle_configuration"]!.map((x) => x)),
        mediaUrl: json["media_url"],
        freebieInfo: json["freebie_info"] == null
            ? null
            : FreebieInfo.fromJson(json["freebie_info"]),
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "sku_code": skuCode,
        "sale_uom": salesUom,
        "sku_title": skuTitle,
        "pack_of": packOf,
        "is_weighed_item": isWeighedItem,
        "product_type": productType,
        "price_list": priceList == null
            ? []
            : List<dynamic>.from(priceList!.map((x) => x.toJson())),
        "bundle_configuration": bundleConfiguration == null
            ? []
            : List<dynamic>.from(bundleConfiguration!.map((x) => x)),
        "media_url": mediaUrl,
        "freebie_info": freebieInfo?.toJson(),
        "is_active": isActive,
      };
}

class FreebieInfo {
  FreebieInfo();

  factory FreebieInfo.fromJson(Map<String, dynamic> json) => FreebieInfo();

  Map<String, dynamic> toJson() => {};
}

class PriceList {
  String? mrpId;
  Mrp? mrp;
  Mrp? sellingPrice;

  PriceList({
    this.mrpId,
    this.mrp,
    this.sellingPrice,
  });

  factory PriceList.fromJson(Map<String, dynamic> json) => PriceList(
        mrpId: json["mrp_id"],
        mrp: json["mrp"] == null ? null : Mrp.fromJson(json["mrp"]),
        sellingPrice: json["selling_price"] == null
            ? null
            : Mrp.fromJson(json["selling_price"]),
      );

  Map<String, dynamic> toJson() => {
        "mrp_id": mrpId,
        "mrp": mrp?.toJson(),
        "selling_price": sellingPrice?.toJson(),
      };
}

class Mrp {
  int? centAmount;
  int? fraction;
  String? currency;

  Mrp({
    this.centAmount,
    this.fraction,
    this.currency,
  });

  factory Mrp.fromJson(Map<String, dynamic> json) => Mrp(
        centAmount: json["cent_amount"],
        fraction: json["fraction"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "cent_amount": centAmount,
        "fraction": fraction,
        "currency": currency,
      };
}
