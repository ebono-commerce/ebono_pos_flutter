// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

OrderSummaryResponse orderSummaryResponseFromJson(str) =>
    OrderSummaryResponse.fromJson(json.decode(str));

String orderSummaryResponseToJson(OrderSummaryResponse data) =>
    json.encode(data.toJson());

class OrderSummaryResponse {
  OutletAddress? outletAddress;
  String? invoiceNumber;
  String? invoiceDate;
  String? orderNumber;
  String? outletId;
  String? storeOrderNumber;
  String? orderDate;
  String? paymentMethods;
  Customer? customer;
  List<InvoiceLine>? invoiceLines;
  TaxDetails? taxDetails;
  String? totalsInWords;
  String? quantityTotal;
  String? roundOffTotal;
  String? roundOff;
  DiscountTotal? mrpTotal;
  DiscountTotal? grandTotal;
  DiscountTotal? mrpSavings;
  DiscountTotal? discountTotal;
  DiscountTotal? taxTotal;
  ContactDetails? contactDetails;
  List<String>? termsAndConditions;
  String? additionalDiscountDescription;

  OrderSummaryResponse({
    this.outletAddress,
    this.invoiceNumber,
    this.invoiceDate,
    this.orderNumber,
    this.outletId,
    this.storeOrderNumber,
    this.orderDate,
    this.paymentMethods,
    this.customer,
    this.invoiceLines,
    this.taxDetails,
    this.totalsInWords,
    this.quantityTotal,
    this.roundOffTotal,
    this.roundOff,
    this.grandTotal,
    this.mrpTotal,
    this.mrpSavings,
    this.discountTotal,
    this.taxTotal,
    this.contactDetails,
    this.termsAndConditions,
    this.additionalDiscountDescription,
  });

  factory OrderSummaryResponse.fromJson(Map<String, dynamic> json) =>
      OrderSummaryResponse(
        outletAddress: json["outlet_address"] == null
            ? null
            : OutletAddress.fromJson(json["outlet_address"]),
        invoiceNumber: json["invoice_number"],
        invoiceDate: json["invoice_date"],
        orderNumber: json["order_number"],
        outletId: json["outlet_id"],
        storeOrderNumber: json["store_order_number"],
        additionalDiscountDescription: json['additional_discount_description'],
        orderDate: json["order_date"],
        paymentMethods: json["payment_methods"],
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
        invoiceLines: json["invoice_lines"] == null
            ? []
            : List<InvoiceLine>.from(
                json["invoice_lines"]!.map((x) => InvoiceLine.fromJson(x))),
        taxDetails: json["tax_details"] == null
            ? null
            : TaxDetails.fromJson(json["tax_details"]),
        totalsInWords: json["totals_in_words"],
        quantityTotal: json["quantity_total"],
        roundOffTotal: json["roundOffTotal"],
        roundOff: json["roundoff"],
        grandTotal: json["grand_total"] == null
            ? null
            : DiscountTotal.fromJson(json["grand_total"]),
        mrpTotal: json["mrp_total"] == null
            ? null
            : DiscountTotal.fromJson(json["mrp_total"]),
        mrpSavings: json["mrp_savings"] == null
            ? null
            : DiscountTotal.fromJson(json["mrp_savings"]),
        discountTotal: json["discount_total"] == null
            ? null
            : DiscountTotal.fromJson(json["discount_total"]),
        taxTotal: json["tax_total"] == null
            ? null
            : DiscountTotal.fromJson(json["tax_total"]),
        contactDetails: json["contact_details"] == null
            ? null
            : ContactDetails.fromJson(json["contact_details"]),
        termsAndConditions: json["terms_and_conditions"] == null
            ? []
            : List<String>.from(json["terms_and_conditions"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "outlet_address": outletAddress?.toJson(),
        "invoice_number": invoiceNumber,
        "invoice_date": invoiceDate,
        'additional_discount_description': additionalDiscountDescription,
        "order_number": orderNumber,
        "order_date": orderDate,
        "payment_methods": paymentMethods,
        "customer": customer?.toJson(),
        "invoice_lines": invoiceLines == null
            ? []
            : List<dynamic>.from(invoiceLines!.map((x) => x.toJson())),
        "tax_details": taxDetails?.toJson(),
        "totals_in_words": totalsInWords,
        "quantity_total": quantityTotal,
        "roundOffTotal": roundOffTotal,
        "roundoff": roundOff,
        "grand_total": grandTotal?.toJson(),
        "mrp_total": mrpTotal?.toJson(),
        "mrp_savings": mrpSavings?.toJson(),
        "discount_total": discountTotal?.toJson(),
        "tax_total": taxTotal?.toJson(),
        "contact_details": contactDetails?.toJson(),
        "terms_and_conditions": termsAndConditions == null
            ? []
            : List<dynamic>.from(termsAndConditions!.map((x) => x)),
      };
}

class ContactDetails {
  String? website;
  String? emailId;

  ContactDetails({
    this.website,
    this.emailId,
  });

  factory ContactDetails.fromJson(Map<String, dynamic> json) => ContactDetails(
        website: json["website"],
        emailId: json["email_id"],
      );

  Map<String, dynamic> toJson() => {
        "website": website,
        "email_id": emailId,
      };
}

class Customer {
  String? customerName;
  PhoneNumber? phoneNumber;
  bool isProxyNumber;

  Customer({
    this.customerName,
    this.phoneNumber,
    this.isProxyNumber = false,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        customerName: json["customer_name"],
        phoneNumber: json["phone_number"] == null
            ? null
            : PhoneNumber.fromJson(json["phone_number"]),
        isProxyNumber: json["is_proxy_number"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "customer_name": customerName,
        "phone_number": phoneNumber?.toJson(),
        "isProxyNumber": isProxyNumber,
      };
}

class PhoneNumber {
  String? countryCode;
  String? number;

  PhoneNumber({
    this.countryCode,
    this.number,
  });

  factory PhoneNumber.fromJson(Map<String, dynamic> json) => PhoneNumber(
        countryCode: json["country_code"],
        number: json["number"],
      );

  Map<String, dynamic> toJson() => {
        "country_code": countryCode,
        "number": number,
      };
}

class DiscountTotal {
  String? currency;
  dynamic centAmount;
  int? fraction;

  DiscountTotal({
    this.currency,
    this.centAmount,
    this.fraction,
  });

  factory DiscountTotal.fromJson(Map<String, dynamic> json) => DiscountTotal(
        currency: json["currency"],
        centAmount: json["cent_amount"],
        fraction: json["fraction"],
      );

  Map<String, dynamic> toJson() => {
        "currency": currency,
        "cent_amount": centAmount,
        "fraction": fraction,
      };
}

class InvoiceLine {
  String? skuCode;
  String? skuTitle;
  Quantity? quantity;
  DiscountTotal? unitPrice;
  DiscountTotal? mrp;
  DiscountTotal? discountTotal;
  DiscountTotal? taxTotal;
  DiscountTotal? grandTotal;
  String? taxCode;

  InvoiceLine({
    this.skuCode,
    this.skuTitle,
    this.quantity,
    this.unitPrice,
    this.mrp,
    this.discountTotal,
    this.taxTotal,
    this.grandTotal,
    this.taxCode,
  });

  factory InvoiceLine.fromJson(Map<String, dynamic> json) => InvoiceLine(
        skuCode: json["sku_code"],
        skuTitle: json["sku_title"],
        taxCode: json["tax_code"],
        quantity: json["quantity"] == null
            ? null
            : Quantity.fromJson(json["quantity"]),
        unitPrice: json["unit_price"] == null
            ? null
            : DiscountTotal.fromJson(json["unit_price"]),
        mrp: json["mrp"] == null ? null : DiscountTotal.fromJson(json["mrp"]),
        discountTotal: json["discount_total"] == null
            ? null
            : DiscountTotal.fromJson(json["discount_total"]),
        taxTotal: json["tax_total"] == null
            ? null
            : DiscountTotal.fromJson(json["tax_total"]),
        grandTotal: json["grand_total"] == null
            ? null
            : DiscountTotal.fromJson(json["grand_total"]),
      );

  Map<String, dynamic> toJson() => {
        "sku_code": skuCode,
        "sku_title": skuTitle,
        "quantity": quantity?.toJson(),
        "unit_price": unitPrice?.toJson(),
        "mrp": mrp?.toJson(),
        "discount_total": discountTotal?.toJson(),
        "tax_total": taxTotal?.toJson(),
        "grand_total": grandTotal?.toJson(),
      };
}

class Quantity {
  dynamic quantityNumber;
  String? quantityUom;

  Quantity({
    this.quantityNumber,
    this.quantityUom,
  });

  factory Quantity.fromJson(Map<String, dynamic> json) => Quantity(
        quantityNumber: json["quantity_number"],
        quantityUom: json["quantity_uom"],
      );

  Map<String, dynamic> toJson() => {
        "quantity_number": quantityNumber,
        "quantity_uom": quantityUom,
      };
}

class OutletAddress {
  String? name;
  String? fullAddress;
  PhoneNumber? phoneNumber;
  String? gstinNumber;
  String? fssaiNumber;
  String? fssaiImageURL;

  OutletAddress({
    this.name,
    this.fullAddress,
    this.phoneNumber,
    this.gstinNumber,
    this.fssaiNumber,
    this.fssaiImageURL,
  });

  factory OutletAddress.fromJson(Map<String, dynamic> json) => OutletAddress(
        name: json["name"],
        fullAddress: json["full_address"],
        phoneNumber: json["phone_number"] == null
            ? null
            : PhoneNumber.fromJson(json["phone_number"]),
        gstinNumber: json["gstin_number"],
        fssaiNumber: json["fssai"]?["fssai_number"],
        fssaiImageURL: json["fssai"]?["fssai_image_url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "full_address": fullAddress,
        "phone_number": phoneNumber?.toJson(),
        "gstin_number": gstinNumber,
      };
}

class Fssai {
  final String? number;
  final String? imageUrl;

  const Fssai({
    this.number,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'number': number,
      'imageUrl': imageUrl,
    };
  }

  factory Fssai.fromMap(Map<String, dynamic> map) {
    return Fssai(
      number:
          map['fssai_number'] != null ? map['fssai_number'] as String : null,
      imageUrl: map['fssai_image_url'] != null
          ? map['fssai_image_url'] as String
          : null,
    );
  }
}

class TaxDetails {
  List<TaxesLine>? taxLines;
  TaxesTotals? taxTotals;

  TaxDetails({
    this.taxLines,
    this.taxTotals,
  });

  factory TaxDetails.fromJson(Map<String, dynamic> json) => TaxDetails(
        taxLines: json["tax_lines"] == null
            ? []
            : List<TaxesLine>.from(
                json["tax_lines"]!.map((x) => TaxesLine.fromJson(x))),
        taxTotals: json["tax_totals"] == null
            ? null
            : TaxesTotals.fromJson(json["tax_totals"]),
      );

  Map<String, dynamic> toJson() => {
        "tax_lines": taxLines == null
            ? []
            : List<dynamic>.from(taxLines!.map((x) => x.toJson())),
        "tax_totals": taxTotals?.toJson(),
      };
}

class TaxesLine {
  dynamic taxPercentage;
  dynamic taxValue;
  dynamic cgstValue;
  dynamic cgstPercentage;
  dynamic sgstValue;
  dynamic sgstPercentage;
  dynamic igstValue;
  dynamic igstPercentage;
  dynamic cessValue;
  dynamic cessPercentage;

  TaxesLine({
    this.taxPercentage,
    this.taxValue,
    this.cgstValue,
    this.cgstPercentage,
    this.sgstValue,
    this.sgstPercentage,
    this.igstValue,
    this.igstPercentage,
    this.cessValue,
    this.cessPercentage,
  });

  factory TaxesLine.fromJson(Map<String, dynamic> json) => TaxesLine(
        taxPercentage: json["tax_percentage"],
        taxValue: json["tax_value"],
        cgstValue: json["cgst_value"],
        cgstPercentage: json["cgst_percentage"],
        sgstValue: json["sgst_value"],
        sgstPercentage: json["sgst_percentage"],
        igstValue: json["igst_value"],
        igstPercentage: json["igst_percentage"],
        cessValue: json["cess_value"],
        cessPercentage: json["cess_percentage"],
      );

  Map<String, dynamic> toJson() => {
        "tax_percentage": taxPercentage,
        "tax_value": taxValue,
        "cgst_value": cgstValue,
        "cgst_percentage": cgstPercentage,
        "sgst_value": sgstValue,
        "sgst_percentage": sgstPercentage,
        "igst_value": igstValue,
        "igst_percentage": igstPercentage,
        "cess_value": cessValue,
        "cess_percentage": cessPercentage,
      };
}

class TaxesTotals {
  dynamic totalTax;
  dynamic totalCgst;
  dynamic totalSgst;
  dynamic totalIgst;
  dynamic totalCess;

  TaxesTotals({
    this.totalTax,
    this.totalCgst,
    this.totalSgst,
    this.totalIgst,
    this.totalCess,
  });

  factory TaxesTotals.fromJson(Map<String, dynamic> json) => TaxesTotals(
        totalTax: json["total_tax"],
        totalCgst: json["total_cgst"],
        totalSgst: json["total_sgst"],
        totalIgst: json["total_igst"],
        totalCess: json["total_cess"],
      );

  Map<String, dynamic> toJson() => {
        "total_tax": totalTax,
        "total_cgst": totalCgst,
        "total_sgst": totalSgst,
        "total_igst": totalIgst,
        "total_cess": totalCess,
      };
}
