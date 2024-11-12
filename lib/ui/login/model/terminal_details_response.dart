// To parse this JSON data, do
//
//     final terminalDetailsResponse = terminalDetailsResponseFromJson(jsonString);

import 'dart:convert';

TerminalDetailsResponse terminalDetailsResponseFromJson(String str) =>
    TerminalDetailsResponse.fromJson(json.decode(str));

String terminalDetailsResponseToJson(TerminalDetailsResponse data) =>
    json.encode(data.toJson());

class TerminalDetailsResponse {
  RegisterDetails registerDetails;
  OutletDetails outletDetails;
  TerminalDetails terminalDetails;

  TerminalDetailsResponse({
    required this.registerDetails,
    required this.outletDetails,
    required this.terminalDetails,
  });

  factory TerminalDetailsResponse.fromJson(Map<String, dynamic> json) =>
      TerminalDetailsResponse(
        registerDetails: RegisterDetails.fromJson(json["register_details"]),
        outletDetails: OutletDetails.fromJson(json["outlet_details"]),
        terminalDetails: TerminalDetails.fromJson(json["terminal_details"]),
      );

  Map<String, dynamic> toJson() => {
        "register_details": registerDetails.toJson(),
        "outlet_details": outletDetails.toJson(),
        "terminal_details": terminalDetails.toJson(),
      };
}

class OutletDetails {
  String outletId;
  String name;
  String zoneId;
  String zoneShortCode;
  AllowedPosIps allowedPosIps;
  String outletCustomerProxyPhoneNumber;
  String quantityEditMode;
  String lineDeleteMode;
  String enableHoldCartMode;
  String priceEditMode;
  String salesAssociateLink;
  bool isActive;

  OutletDetails({
    required this.outletId,
    required this.name,
    required this.zoneId,
    required this.zoneShortCode,
    required this.allowedPosIps,
    required this.outletCustomerProxyPhoneNumber,
    required this.quantityEditMode,
    required this.lineDeleteMode,
    required this.enableHoldCartMode,
    required this.priceEditMode,
    required this.salesAssociateLink,
    required this.isActive,
  });

  factory OutletDetails.fromJson(Map<String, dynamic> json) => OutletDetails(
        outletId: json["outlet_id"],
        name: json["name"],
        zoneId: json["zone_id"],
        zoneShortCode: json["zone_short_code"],
        allowedPosIps: AllowedPosIps.fromJson(json["allowed_pos_ips"]),
        outletCustomerProxyPhoneNumber:
            json["outlet_customer_proxy_phone_number"],
        quantityEditMode: json["quantity_edit_mode"],
        lineDeleteMode: json["line_delete_mode"],
        enableHoldCartMode: json["enable_hold_cart_mode"],
        priceEditMode: json["price_edit_mode"],
        salesAssociateLink: json["sales_associate_link"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "outlet_id": outletId,
        "name": name,
        "zone_id": zoneId,
        "zone_short_code": zoneShortCode,
        "allowed_pos_ips": allowedPosIps.toJson(),
        "outlet_customer_proxy_phone_number": outletCustomerProxyPhoneNumber,
        "quantity_edit_mode": quantityEditMode,
        "line_delete_mode": lineDeleteMode,
        "enable_hold_cart_mode": enableHoldCartMode,
        "price_edit_mode": priceEditMode,
        "sales_associate_link": salesAssociateLink,
        "is_active": isActive,
      };
}

class AllowedPosIps {
  List<String> allowedIpList;
  List<String> allowedIpRange;
  String enableIpRestriction;

  AllowedPosIps({
    required this.allowedIpList,
    required this.allowedIpRange,
    required this.enableIpRestriction,
  });

  factory AllowedPosIps.fromJson(Map<String, dynamic> json) => AllowedPosIps(
        allowedIpList: List<String>.from(json["allowed_ip_list"].map((x) => x)),
        allowedIpRange:
            List<String>.from(json["allowed_ip_range"].map((x) => x)),
        enableIpRestriction: json["enable_ip_restriction"],
      );

  Map<String, dynamic> toJson() => {
        "allowed_ip_list": List<dynamic>.from(allowedIpList.map((x) => x)),
        "allowed_ip_range": List<dynamic>.from(allowedIpRange.map((x) => x)),
        "enable_ip_restriction": enableIpRestriction,
      };
}

class RegisterDetails {
  String registerId;

  RegisterDetails({
    required this.registerId,
  });

  factory RegisterDetails.fromJson(Map<String, dynamic> json) =>
      RegisterDetails(
        registerId: json["register_id"],
      );

  Map<String, dynamic> toJson() => {
        "register_id": registerId,
      };
}

class TerminalDetails {
  String terminalId;
  String terminalName;
  String status;
  bool isEdcIntegrated;
  bool isWeighingScaleIntegrated;
  List<EdcDevice> edcDevices;
  PrinterDevice printerDevice;
  bool isActive;

  TerminalDetails({
    required this.terminalId,
    required this.terminalName,
    required this.status,
    required this.isEdcIntegrated,
    required this.isWeighingScaleIntegrated,
    required this.edcDevices,
    required this.printerDevice,
    required this.isActive,
  });

  factory TerminalDetails.fromJson(Map<String, dynamic> json) =>
      TerminalDetails(
        terminalId: json["terminal_id"],
        terminalName: json["terminal_name"],
        status: json["status"],
        isEdcIntegrated: json["is_edc_integrated"],
        isWeighingScaleIntegrated: json["is_weighing_scale_integrated"],
        edcDevices: List<EdcDevice>.from(
            json["edc_devices"].map((x) => EdcDevice.fromJson(x))),
        printerDevice: PrinterDevice.fromJson(json["printer_device"]),
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "terminal_id": terminalId,
        "terminal_name": terminalName,
        "status": status,
        "is_edc_integrated": isEdcIntegrated,
        "is_weighing_scale_integrated": isWeighingScaleIntegrated,
        "edc_devices": List<dynamic>.from(edcDevices.map((x) => x.toJson())),
        "printer_device": printerDevice.toJson(),
        "is_active": isActive,
      };
}

class EdcDevice {
  String pspId;
  String deviceType;
  String appKey;
  String username;
  String deviceId;

  EdcDevice({
    required this.pspId,
    required this.deviceType,
    required this.appKey,
    required this.username,
    required this.deviceId,
  });

  factory EdcDevice.fromJson(Map<String, dynamic> json) => EdcDevice(
        pspId: json["psp_id"],
        deviceType: json["device_type"],
        appKey: json["app_key"],
        username: json["username"],
        deviceId: json["device_id"],
      );

  Map<String, dynamic> toJson() => {
        "psp_id": pspId,
        "device_type": deviceType,
        "app_key": appKey,
        "username": username,
        "device_id": deviceId,
      };
}

class PrinterDevice {
  String printerType;

  PrinterDevice({
    required this.printerType,
  });

  factory PrinterDevice.fromJson(Map<String, dynamic> json) => PrinterDevice(
        printerType: json["printer_type"],
      );

  Map<String, dynamic> toJson() => {
        "printer_type": printerType,
      };
}
