class ScanProductsResponse {
  String? esin;
  String? ebonoTitle;
  int? packOf;
  bool? isWeighedItem;
  String? productType;
  List<PriceList>? priceList;
  List<dynamic>? bundleConfiguration;
  String? mediaUrl;
  FreebieInfo? freebieInfo;
  bool? isActive;

  ScanProductsResponse({
    this.esin,
    this.ebonoTitle,
    this.packOf,
    this.isWeighedItem,
    this.productType,
    this.priceList,
    this.bundleConfiguration,
    this.mediaUrl,
    this.freebieInfo,
    this.isActive,
  });
}

class FreebieInfo {
  FreebieInfo();
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
}
