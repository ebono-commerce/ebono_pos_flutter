class CustomerOrderDetails {
  final String? orderNumber;
  final String? outletId;
  final String? originalOutletId;
  final String? createdAt;
  final String? orderState;
  final String? orderType;
  final Customer? customer;
  final int? totalUnits;
  final int? totalItems;
  final bool isLoading;
  final List<OrderTotals>? orderTotals;

  const CustomerOrderDetails({
    this.orderNumber,
    this.outletId,
    this.originalOutletId,
    this.createdAt,
    this.orderState,
    this.orderType,
    this.customer,
    this.totalUnits,
    this.totalItems,
    this.orderTotals,
    this.isLoading = false,
  });

  Map<String, dynamic> toJSON() {
    return {
      'order_number': orderNumber,
      'outlet_id': outletId,
      'original_outlet_id': originalOutletId,
      'created_at': createdAt,
      'order_state': orderState,
      "isLoading": isLoading,
      'order_type': orderType,
      'customer': customer?.toJSON(),
      'total_units': totalUnits,
      'total_items': totalItems,
      'order_totals': orderTotals?.map((x) => x.toJSON()).toList(),
    };
  }

  factory CustomerOrderDetails.fromJSON(Map<String, dynamic> map) {
    return CustomerOrderDetails(
      orderNumber: map['order_number'],
      outletId: map['outlet_id'],
      originalOutletId: map['original_outlet_id'],
      createdAt: map['created_at'],
      orderState: map['order_state'],
      orderType: map['order_type'],
      isLoading: false,
      customer:
          map['customer'] != null ? Customer.fromJSON(map['customer']) : null,
      totalUnits: map['total_units']?.toInt(),
      totalItems: map['total_items']?.toInt(),
      orderTotals: map['order_totals'] != null
          ? List<OrderTotals>.from(
              map['order_totals'].map((x) => OrderTotals.fromJSON(x)),
            )
          : null,
    );
  }

  CustomerOrderDetails copyWith({
    String? orderNumber,
    String? outletId,
    String? originalOutletId,
    String? createdAt,
    String? orderState,
    String? orderType,
    Customer? customer,
    int? totalUnits,
    int? totalItems,
    bool? isLoading,
    List<OrderTotals>? orderTotals,
  }) {
    return CustomerOrderDetails(
      orderNumber: orderNumber ?? this.orderNumber,
      outletId: outletId ?? this.outletId,
      originalOutletId: originalOutletId ?? this.originalOutletId,
      createdAt: createdAt ?? this.createdAt,
      orderState: orderState ?? this.orderState,
      orderType: orderType ?? this.orderType,
      customer: customer ?? this.customer,
      totalUnits: totalUnits ?? this.totalUnits,
      totalItems: totalItems ?? this.totalItems,
      isLoading: isLoading ?? this.isLoading,
      orderTotals: orderTotals ?? this.orderTotals,
    );
  }
}

class Customer {
  final String? customerId;
  final String? customerGroup;
  final String? customerType;
  final String? customerName;
  final String? emailId;
  final PhoneNumber? phoneNumber;
  final bool? isB2bCustomer;
  final bool? isProxyNumber;

  const Customer({
    this.customerId,
    this.customerGroup,
    this.customerType,
    this.customerName,
    this.emailId,
    this.phoneNumber,
    this.isB2bCustomer,
    this.isProxyNumber,
  });

  Map<String, dynamic> toJSON() {
    return {
      'customer_id': customerId,
      'customer_group': customerGroup,
      'customer_type': customerType,
      'customer_name': customerName,
      'email_id': emailId,
      'phone_number': phoneNumber?.toJSON(),
      'is_b2b_customer': isB2bCustomer,
      "is_proxy_number": isProxyNumber,
    };
  }

  Map<String, dynamic> toReturnPostReqJSON() {
    return {
      'customer_name': customerName,
      'phone_number': phoneNumber?.number,
    };
  }

  factory Customer.fromJSON(Map<String, dynamic> map) {
    return Customer(
      customerId: map['customer_id'],
      customerGroup: map['customer_group'],
      customerType: map['customer_type'],
      customerName: map['customer_name'],
      emailId: map['email_id'],
      isProxyNumber: map['is_proxy_number'],
      phoneNumber: map['phone_number'] != null
          ? PhoneNumber.fromJSON(map['phone_number'])
          : null,
      isB2bCustomer: map['is_b2b_customer'],
    );
  }
}

class PhoneNumber {
  final String? countryCode;
  final String? number;

  const PhoneNumber({this.countryCode, this.number});

  Map<String, dynamic> toJSON() {
    return {
      'country_code': countryCode,
      'number': number,
    };
  }

  factory PhoneNumber.fromJSON(Map<String, dynamic> map) {
    return PhoneNumber(
      countryCode: map['country_code'],
      number: map['number'],
    );
  }
}

class OrderTotals {
  final String? type;
  final int? multiplier;
  final Amount? amount;

  const OrderTotals({this.type, this.multiplier, this.amount});

  Map<String, dynamic> toJSON() {
    return {
      'type': type,
      'multiplier': multiplier,
      'amount': amount?.toJSON(),
    };
  }

  factory OrderTotals.fromJSON(Map<String, dynamic> map) {
    return OrderTotals(
      type: map['type'],
      multiplier: map['multiplier']?.toInt(),
      amount: map['amount'] != null ? Amount.fromJSON(map['amount']) : null,
    );
  }
}

class Amount {
  final String? currency;
  final int? centAmount;
  final int? fraction;

  const Amount({this.currency, this.centAmount, this.fraction});

  Map<String, dynamic> toJSON() {
    return {
      'currency': currency,
      'cent_amount': centAmount,
      'fraction': fraction,
    };
  }

  factory Amount.fromJSON(Map<String, dynamic> map) {
    return Amount(
      currency: map['currency'],
      centAmount: map['cent_amount']?.toInt(),
      fraction: map['fraction']?.toInt(),
    );
  }
}
