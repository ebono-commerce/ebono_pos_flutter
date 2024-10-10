// Define a data class to represent the parsed JSON data
class InvoiceData {
  final String invoiceNumber;
  final String orderNumber;
  final String sellerAddress;
  final String billingAddress;
  final String shipAddress;
  final PriceInfo priceInfo;
  final List<InvoiceLine> invoiceLinesDetails;
  final TermsAndConditions termsAndConditions;

  InvoiceData({
    required this.invoiceNumber,
    required this.orderNumber,
    required this.sellerAddress,
    required this.billingAddress,
    required this.shipAddress,
    required this.priceInfo,
    required this.invoiceLinesDetails,
    required this.termsAndConditions,
  });

  // Factory constructor to convert from JSON
  factory InvoiceData.fromJson(Map<String, dynamic> json) {
    return InvoiceData(
      invoiceNumber: json['invoice_number'],
      orderNumber: json['order_number'],
      sellerAddress: json['seller_address'],
      billingAddress: json['billing_address'],
      shipAddress: json['ship_address'],
      priceInfo: PriceInfo.fromJson(json['price_info']),
      invoiceLinesDetails: (json['invoice_lines_details'] as List)
          .map((e) => InvoiceLine.fromJson(e))
          .toList(),
      termsAndConditions: TermsAndConditions.fromJson(json['terms_and_conditions']),
    );
  }
}

// Define supporting data classes for nested JSON structures
class PriceInfo {
  final double itemTotal;
  final dynamic discTotal;
  final double taxTotal;
  final String totalInvoiceAmount;
  final String inWords;

  PriceInfo({
    required this.itemTotal,
    required this.discTotal,
    required this.taxTotal,
    required this.totalInvoiceAmount,
    required this.inWords,
  });

  factory PriceInfo.fromJson(Map<String, dynamic> json) {
    return PriceInfo(
      itemTotal: json['item_total'],
      discTotal: json['disc_total'],
      taxTotal: json['tax_total'],
      totalInvoiceAmount: json['total_invoice_amount'],
      inWords: json['in_words'],
    );
  }
}

class InvoiceLine {
  final String description;
  final String qty;
  final String unitRate;
  final String unitTotalAmount;
  final String unitTotalDiscount;
  final String unitTotalTax;
  final String unitLineTotal;

  InvoiceLine({
    required this.description,
    required this.qty,
    required this.unitRate,
    required this.unitTotalAmount,
    required this.unitTotalDiscount,
    required this.unitTotalTax,
    required this.unitLineTotal,
  });

  factory InvoiceLine.fromJson(Map<String, dynamic> json) {
    return InvoiceLine(
      description: json['description'],
      qty: json['qty'],
      unitRate: json['unit_rate'],
      unitTotalAmount: json['unit_total_amount'],
      unitTotalDiscount: json['unit_total_discount'],
      unitTotalTax: json['unit_total_tax'],
      unitLineTotal: json['unit_line_total'],
    );
  }
}

class TermsAndConditions {
  final List<String> tc;

  TermsAndConditions({required this.tc});

  factory TermsAndConditions.fromJson(Map<String, dynamic> json) {
    return TermsAndConditions(
      tc: List<String>.from(json['T&C']),
    );
  }
}