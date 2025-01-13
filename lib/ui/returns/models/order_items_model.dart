import 'package:ebono_pos/ui/returns/models/customer_order_model.dart';

class OrderItemsModel {
  final String? orderNumber;
  final String? deliveryGroupId;
  final Customer? customer;
  final List<OrderLine>? orderLines;
  final List<String> refundModes;

  const OrderItemsModel({
    this.orderNumber,
    this.orderLines,
    this.customer,
    this.deliveryGroupId,
    this.refundModes = const <String>[],
  });

  Map<String, dynamic> toJSON() {
    return {
      "order_number": orderNumber,
      'customer': customer?.toJSON(),
      "order_lines": orderLines == null
          ? []
          : List<dynamic>.from(orderLines!.map((x) => x.toJSON())),
    };
  }

  Map<String, dynamic> toReturnPostReqJSON() {
    return {
      "order_number": orderNumber,
      "delivery_group_id": deliveryGroupId,
      "customer": customer?.toReturnPostReqJSON(),
      "order_lines": orderLines == null
          ? []
          : List<dynamic>.from(orderLines!.map((x) => x.toReturnPostJSON())),
      "refund_mode": "WALLET",
    };
  }

  factory OrderItemsModel.fromJSON(Map<String, dynamic> map) {
    return OrderItemsModel(
      orderNumber: map["order_number"],
      deliveryGroupId: map["delivery_group_id"] ?? 'NA',
      customer:
          map['customer'] != null ? Customer.fromJSON(map['customer']) : null,
      orderLines: map["order_lines"] == null
          ? []
          : List<OrderLine>.from(
              map["order_lines"].map((x) => OrderLine.fromJSON(x))),
      refundModes: List<String>.from(map['return_modes'] ?? []),
    );
  }

  OrderItemsModel copyWith({
    String? orderNumber,
    Customer? customer,
    String? deliveryGroupId,
    List<OrderLine>? orderLines,
  }) {
    return OrderItemsModel(
      orderNumber: orderNumber ?? this.orderNumber,
      deliveryGroupId: deliveryGroupId ?? this.deliveryGroupId,
      customer: customer ?? this.customer,
      orderLines: orderLines ?? this.orderLines,
    );
  }
}

class OrderLine {
  final String? orderLineId;
  final dynamic parentLineId;
  final Item? item;
  final bool? isFreeProductPromotion;
  final Quantity? orderQuantity;
  final Quantity? returnableQuantity;
  final bool isSelected;
  final String? returnReason;
  final String returningQuantity;

  const OrderLine({
    this.orderLineId,
    this.parentLineId,
    this.item,
    this.isFreeProductPromotion,
    this.orderQuantity,
    this.returnableQuantity,
    this.isSelected = false,
    this.returnReason,
    this.returningQuantity = '1',
  });

  Map<String, dynamic> toJSON() {
    return {
      "order_line_id": orderLineId,
      "parent_line_id": parentLineId,
      "item": item?.toJSON(),
      "isSelected": isSelected,
      "is_free_product_promotion": isFreeProductPromotion,
      "order_quantity": orderQuantity?.toJSON(),
      "returnable_quantity": returnableQuantity?.toJSON(),
    };
  }

  Map<String, dynamic> toReturnPostJSON() {
    return {
      "order_line_id": orderLineId,
      "returnable_quantity": {
        'quantity_number': returningQuantity,
        'quantity_uom': returnableQuantity!.quantityUom,
      },
      "return_reason": returnReason,
    };
  }

  factory OrderLine.fromJSON(Map<String, dynamic> map) {
    return OrderLine(
      orderLineId: map["order_line_id"],
      parentLineId: map["parent_line_id"],
      isSelected: false,
      returnReason: '',
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
    String? orderLineId,
    dynamic parentLineId,
    Item? item,
    bool? isFreeProductPromotion,
    Quantity? orderQuantity,
    Quantity? returnableQuantity,
    bool? isSelected,
    String? returnReason,
    String? returningQuantity,
  }) {
    return OrderLine(
      orderLineId: orderLineId ?? this.orderLineId,
      parentLineId: parentLineId ?? this.parentLineId,
      item: item ?? this.item,
      isFreeProductPromotion:
          isFreeProductPromotion ?? this.isFreeProductPromotion,
      orderQuantity: orderQuantity ?? this.orderQuantity,
      returnableQuantity: returnableQuantity ?? this.returnableQuantity,
      isSelected: isSelected ?? this.isSelected,
      returnReason: returnReason ?? this.returnReason,
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
