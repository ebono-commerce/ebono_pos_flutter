import 'package:ebono_pos/ui/returns/models/customer_order_model.dart';

class OrderItemsModel {
  final String? orderNumber;
  final Customer? customer;
  final List<OrderLine>? orderLines;

  const OrderItemsModel({this.orderNumber, this.orderLines, this.customer});

  Map<String, dynamic> toJSON() {
    return {
      "order_number": orderNumber,
      'customer': customer?.toJSON(),
      "order_lines": orderLines == null
          ? []
          : List<dynamic>.from(orderLines!.map((x) => x.toJSON())),
    };
  }

  factory OrderItemsModel.fromJSON(Map<String, dynamic> map) {
    return OrderItemsModel(
      orderNumber: map["order_number"],
      customer:
          map['customer'] != null ? Customer.fromJSON(map['customer']) : null,
      orderLines: map["order_lines"] == null
          ? []
          : List<OrderLine>.from(
              map["order_lines"].map((x) => OrderLine.fromJSON(x))),
    );
  }
}

class OrderLine {
  final String? deliveryGroupId;
  final String? orderLineId;
  final dynamic parentLineId;
  final Item? item;
  final bool? isFreeProductPromotion;
  final Quantity? orderQuantity;
  final Quantity? returnableQuantity;
  final bool isSelected;
  final String reason;
  final String returningQuantity;

  const OrderLine({
    this.deliveryGroupId,
    this.orderLineId,
    this.parentLineId,
    this.item,
    this.isFreeProductPromotion,
    this.orderQuantity,
    this.returnableQuantity,
    this.isSelected = false,
    this.reason = '',
    this.returningQuantity = '',
  });

  Map<String, dynamic> toJSON() {
    return {
      "delivery_group_id": deliveryGroupId,
      "order_line_id": orderLineId,
      "parent_line_id": parentLineId,
      "item": item?.toJSON(),
      "is_free_product_promotion": isFreeProductPromotion,
      "order_quantity": orderQuantity?.toJSON(),
      "returnable_quantity": returnableQuantity?.toJSON(),
    };
  }

  factory OrderLine.fromJSON(Map<String, dynamic> map) {
    return OrderLine(
      deliveryGroupId: map["delivery_group_id"],
      orderLineId: map["order_line_id"],
      parentLineId: map["parent_line_id"],
      isSelected: false,
      item: map["item"] == null ? null : Item.fromJSON(map["item"]),
      isFreeProductPromotion: map["is_free_product_promotion"],
      orderQuantity: map["order_quantity"] == null
          ? null
          : Quantity.fromJSON(map["order_quantity"]),
      returnableQuantity: map["returnable_quantity"] == null
          ? null
          : Quantity.fromJSON(map["returnable_quantity"]),
    );
  }

  OrderLine copyWith({
    String? deliveryGroupId,
    String? orderLineId,
    dynamic parentLineId,
    Item? item,
    bool? isFreeProductPromotion,
    Quantity? orderQuantity,
    Quantity? returnableQuantity,
    bool? isSelected,
    String? reason,
    String? returningQuantity,
  }) {
    return OrderLine(
      deliveryGroupId: deliveryGroupId ?? this.deliveryGroupId,
      orderLineId: orderLineId ?? this.orderLineId,
      parentLineId: parentLineId ?? this.parentLineId,
      item: item ?? this.item,
      isFreeProductPromotion:
          isFreeProductPromotion ?? this.isFreeProductPromotion,
      orderQuantity: orderQuantity ?? this.orderQuantity,
      returnableQuantity: returnableQuantity ?? this.returnableQuantity,
      isSelected: isSelected ?? this.isSelected,
      reason: reason ?? this.reason,
      returningQuantity: returningQuantity ?? this.returningQuantity,
    );
  }
}

class Item {
  final String? skuCode;
  final String? skuTitle;
  final String? productPackId;
  final String? packName;
  final String? legacyId;

  Item({
    this.skuCode,
    this.skuTitle,
    this.productPackId,
    this.packName,
    this.legacyId,
  });

  Map<String, dynamic> toJSON() {
    return {
      "sku_code": skuCode,
      "sku_title": skuTitle,
      "product_pack_id": productPackId,
      "pack_name": packName,
      "legacy_id": legacyId,
    };
  }

  factory Item.fromJSON(Map<String, dynamic> map) {
    return Item(
      skuCode: map["sku_code"],
      skuTitle: map["sku_title"],
      productPackId: map["product_pack_id"],
      packName: map["pack_name"],
      legacyId: map["legacy_id"],
    );
  }
}

class Quantity {
  final int? quantityNumber;
  final String? quantityUom;

  Quantity({
    this.quantityNumber,
    this.quantityUom,
  });

  Map<String, dynamic> toJSON() {
    return {
      'quantity_number': quantityNumber,
      'quantity_uom': quantityUom,
    };
  }

  factory Quantity.fromJSON(Map<String, dynamic> map) {
    return Quantity(
      quantityNumber: map['quantity_number']?.toInt(),
      quantityUom: map['quantity_uom'],
    );
  }
}
