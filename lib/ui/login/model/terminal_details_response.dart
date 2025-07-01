import 'dart:convert';

TerminalDetailsResponse terminalDetailsResponseFromJson(String str) =>
    TerminalDetailsResponse.fromJson(json.decode(str));

String terminalDetailsResponseToJson(TerminalDetailsResponse data) =>
    json.encode(data.toJson());

class TerminalDetailsResponse {
  RegisterDetails? registerDetails;
  OutletDetails? outletDetails;
  TerminalDetails? terminalDetails;

  TerminalDetailsResponse({
    this.registerDetails,
    this.outletDetails,
    this.terminalDetails,
  });

  factory TerminalDetailsResponse.fromJson(Map<String, dynamic> json) =>
      TerminalDetailsResponse(
        registerDetails: json["register_details"] == null
            ? null
            : RegisterDetails.fromJson(json["register_details"]),
        outletDetails: json["outlet_details"] == null
            ? null
            : OutletDetails.fromJson(json["outlet_details"]),
        terminalDetails: json["terminal_details"] == null
            ? null
            : TerminalDetails.fromJson(json["terminal_details"]),
      );

  Map<String, dynamic> toJson() => {
        "register_details": registerDetails?.toJson(),
        "outlet_details": outletDetails?.toJson(),
        "terminal_details": terminalDetails?.toJson(),
      };
}

class OutletDetails {
  String? outletId;
  String? name;
  String? zoneId;
  String? zoneShortCode;
  AllowedPosIps? allowedPosIps;
  String? outletCustomerProxyPhoneNumber;
  String? quantityEditMode;
  String? lineDeleteMode;
  String? enableHoldCartMode;
  String? priceEditMode;
  String? salesAssociateLink;
  String? mandateRegisterCloseOnLogout;
  bool? isDigitalInvoiceEnabled;
  bool? isActive;
  List<AllowedPaymentMode>? allowedPaymentModes;

  OutletDetails({
    this.outletId,
    this.name,
    this.zoneId,
    this.zoneShortCode,
    this.allowedPosIps,
    this.outletCustomerProxyPhoneNumber,
    this.quantityEditMode,
    this.lineDeleteMode,
    this.enableHoldCartMode,
    this.priceEditMode,
    this.salesAssociateLink,
    this.mandateRegisterCloseOnLogout,
    this.isDigitalInvoiceEnabled,
    this.isActive,
    this.allowedPaymentModes,
  });

  factory OutletDetails.fromJson(Map<String, dynamic> json) => OutletDetails(
        outletId: json["outlet_id"],
        name: json["name"],
        zoneId: json["zone_id"],
        zoneShortCode: json["zone_short_code"],
        allowedPosIps: json["allowed_pos_ips"] == null
            ? null
            : AllowedPosIps.fromJson(json["allowed_pos_ips"]),
        outletCustomerProxyPhoneNumber:
            json["outlet_customer_proxy_phone_number"],
        quantityEditMode: json["quantity_edit_mode"],
        lineDeleteMode: json["line_delete_mode"],
        enableHoldCartMode: json["enable_hold_cart_mode"],
        priceEditMode: json["price_edit_mode"],
        salesAssociateLink: json["sales_associate_link"],
        isDigitalInvoiceEnabled: json["is_digital_invoice_enabled"],
        mandateRegisterCloseOnLogout: json["mandate_register_close_on_logout"],
        isActive: json["is_active"],
        allowedPaymentModes: json["allowed_payment_modes"] == null
            ? []
            : List<AllowedPaymentMode>.from(json["allowed_payment_modes"]!
                .map((x) => AllowedPaymentMode.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "outlet_id": outletId,
        "name": name,
        "zone_id": zoneId,
        "zone_short_code": zoneShortCode,
        "allowed_pos_ips": allowedPosIps?.toJson(),
        "outlet_customer_proxy_phone_number": outletCustomerProxyPhoneNumber,
        "quantity_edit_mode": quantityEditMode,
        "line_delete_mode": lineDeleteMode,
        "enable_hold_cart_mode": enableHoldCartMode,
        "price_edit_mode": priceEditMode,
        "sales_associate_link": salesAssociateLink,
        "is_active": isActive,
        "allowed_payment_modes": allowedPaymentModes == null
            ? []
            : List<dynamic>.from(allowedPaymentModes!.map((x) => x.toJson())),
      };
}

class AllowedPosIps {
  List<dynamic>? allowedIpList;
  List<dynamic>? allowedIpRange;
  bool? enableIpRestriction;

  AllowedPosIps({
    this.allowedIpList,
    this.allowedIpRange,
    this.enableIpRestriction,
  });

  factory AllowedPosIps.fromJson(Map<String, dynamic> json) => AllowedPosIps(
        allowedIpList: json["allowed_ip_list"] == null
            ? []
            : List<dynamic>.from(json["allowed_ip_list"]!.map((x) => x)),
        allowedIpRange: json["allowed_ip_range"] == null
            ? []
            : List<dynamic>.from(json["allowed_ip_range"]!.map((x) => x)),
        enableIpRestriction: json["enable_ip_restriction"],
      );

  Map<String, dynamic> toJson() => {
        "allowed_ip_list": allowedIpList == null
            ? []
            : List<dynamic>.from(allowedIpList!.map((x) => x)),
        "allowed_ip_range": allowedIpRange == null
            ? []
            : List<dynamic>.from(allowedIpRange!.map((x) => x)),
        "enable_ip_restriction": enableIpRestriction,
      };
}

class RegisterDetails {
  String? registerId;
  String? registerTransactionId;

  RegisterDetails({
    this.registerId,
    this.registerTransactionId,
  });

  factory RegisterDetails.fromJson(Map<String, dynamic> json) =>
      RegisterDetails(
        registerId: json["register_id"],
        registerTransactionId: json["register_transaction_id"],
      );

  Map<String, dynamic> toJson() => {
        "register_id": registerId,
        "register_transaction_id": registerTransactionId,
      };
}

class TerminalDetails {
  String? terminalId;
  String? terminalName;
  String? status;
  bool? isEdcIntegrated;
  bool? isWeighingScaleIntegrated;
  List<EdcDevice>? edcDevices;
  PrinterDevice? printerDevice;
  bool? isActive;
  String? returnsEnabledMode;

  TerminalDetails({
    this.terminalId,
    this.terminalName,
    this.status,
    this.isEdcIntegrated,
    this.isWeighingScaleIntegrated,
    this.edcDevices,
    this.printerDevice,
    this.isActive,
    this.returnsEnabledMode,
  });

  factory TerminalDetails.fromJson(Map<String, dynamic> json) =>
      TerminalDetails(
          terminalId: json["terminal_id"],
          terminalName: json["terminal_name"],
          status: json["status"],
          isEdcIntegrated: json["is_edc_integrated"],
          isWeighingScaleIntegrated: json["is_weighing_scale_integrated"],
          edcDevices: json["edc_device"] == null
              ? []
              : List<EdcDevice>.from(
                  json["edc_device"]!.map((x) => EdcDevice.fromJson(x))),
          printerDevice: json["printer_device"] == null
              ? null
              : PrinterDevice.fromJson(json["printer_device"]),
          isActive: json["is_active"],
          returnsEnabledMode: json["returns_enabled_mode"] ?? 'ENABLED');

  Map<String, dynamic> toJson() => {
        "terminal_id": terminalId,
        "terminal_name": terminalName,
        "status": status,
        "is_edc_integrated": isEdcIntegrated,
        "is_weighing_scale_integrated": isWeighingScaleIntegrated,
        "edc_device": edcDevices == null
            ? []
            : List<dynamic>.from(edcDevices!.map((x) => x.toJson())),
        "printer_device": printerDevice?.toJson(),
        "is_active": isActive,
      };
}

class EdcDevice {
  String? pspId;
  String? appKey;
  String? username;
  String? deviceId;
  String? deviceType;
  String? provider;

  EdcDevice({
    this.pspId,
    this.appKey,
    this.username,
    this.deviceId,
    this.deviceType,
    this.provider,
  });

  factory EdcDevice.fromJson(Map<String, dynamic> json) => EdcDevice(
        pspId: json["psp_id"],
        appKey: json["app_key"],
        username: json["username"],
        deviceId: json["device_id"],
        deviceType: json["device_type"],
        provider: json["provider"],
      );

  Map<String, dynamic> toJson() => {
        "psp_id": pspId,
        "app_key": appKey,
        "username": username,
        "device_id": deviceId,
        "device_type": deviceType,
        "provider": provider,
      };
}

class PrinterDevice {
  String? printerType;

  PrinterDevice({
    this.printerType,
  });

  factory PrinterDevice.fromJson(Map<String, dynamic> json) => PrinterDevice(
        printerType: json["printer_type"],
      );

  Map<String, dynamic> toJson() => {
        "printer_type": printerType,
      };
}

class AllowedPaymentMode {
  String? paymentOptionId;
  String? paymentOptionCode;
  String? pspId;
  String? pspName;

  AllowedPaymentMode({
    this.paymentOptionId,
    this.paymentOptionCode,
    this.pspId,
    this.pspName,
  });

  factory AllowedPaymentMode.fromJson(Map<String, dynamic> json) =>
      AllowedPaymentMode(
        paymentOptionId: json["payment_option_id"],
        paymentOptionCode: json["payment_option_code"],
        pspId: json["psp_id"],
        pspName: json["psp_name"],
      );

  Map<String, dynamic> toJson() => {
        "payment_option_id": paymentOptionId,
        "payment_option_code": paymentOptionCode,
        "psp_id": pspId,
        "psp_name": pspName,
      };
}
