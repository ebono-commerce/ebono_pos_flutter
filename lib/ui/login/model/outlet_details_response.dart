import 'dart:convert';

OutletDetailsResponse outletDetailsResponseFromJson(str) => OutletDetailsResponse.fromJson(json.decode(str));

String outletDetailsResponseToJson(OutletDetailsResponse data) => json.encode(data.toJson());

class OutletDetailsResponse {
  String? outletId;
  Address? address;
  String? gstin;
  Fssai? fssai;
  List<Email>? emails;
  List<PhoneNumber>? phoneNumbers;
  Calendar? calendar;
  String? outletGrading;
  AllowedPosIps? allowedPosIps;
  String? outletCustomerProxyPhoneNumber;
  List<String>? allowedPosModes;
  String? quantityEditMode;
  String? lineDeleteMode;
  String? enableHoldCartMode;
  String? priceEditMode;
  String? salesAssociateLink;
  String? mandateRegisterCloseOnLogout;
  List<Terminal>? terminals;
  bool? isActive;

  OutletDetailsResponse({
    this.outletId,
    this.address,
    this.gstin,
    this.fssai,
    this.emails,
    this.phoneNumbers,
    this.calendar,
    this.outletGrading,
    this.allowedPosIps,
    this.outletCustomerProxyPhoneNumber,
    this.allowedPosModes,
    this.quantityEditMode,
    this.lineDeleteMode,
    this.enableHoldCartMode,
    this.priceEditMode,
    this.salesAssociateLink,
    this.mandateRegisterCloseOnLogout,
    this.terminals,
    this.isActive,
  });

  factory OutletDetailsResponse.fromJson(Map<String, dynamic> json) => OutletDetailsResponse(
    outletId: json["outlet_id"],
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
    gstin: json["gstin"],
    fssai: json["fssai"] == null ? null : Fssai.fromJson(json["fssai"]),
    emails: json["emails"] == null ? [] : List<Email>.from(json["emails"]!.map((x) => Email.fromJson(x))),
    phoneNumbers: json["phone_numbers"] == null ? [] : List<PhoneNumber>.from(json["phone_numbers"]!.map((x) => PhoneNumber.fromJson(x))),
    calendar: json["calendar"] == null ? null : Calendar.fromJson(json["calendar"]),
    outletGrading: json["outlet_grading"],
    allowedPosIps: json["allowed_pos_ips"] == null ? null : AllowedPosIps.fromJson(json["allowed_pos_ips"]),
    outletCustomerProxyPhoneNumber: json["outlet_customer_proxy_phone_number"],
    allowedPosModes: json["allowed_pos_modes"] == null ? [] : List<String>.from(json["allowed_pos_modes"]!.map((x) => x)),
    quantityEditMode: json["quantity_edit_mode"],
    lineDeleteMode: json["line_delete_mode"],
    enableHoldCartMode: json["enable_hold_cart_mode"],
    priceEditMode: json["price_edit_mode"],
    salesAssociateLink: json["sales_associate_link"],
    mandateRegisterCloseOnLogout: json["mandate_register_close_on_logout"],
    terminals: json["terminals"] == null ? [] : List<Terminal>.from(json["terminals"]!.map((x) => Terminal.fromJson(x))),
    isActive: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "outlet_id": outletId,
    "address": address?.toJson(),
    "gstin": gstin,
    "fssai": fssai?.toJson(),
    "emails": emails == null ? [] : List<dynamic>.from(emails!.map((x) => x.toJson())),
    "phone_numbers": phoneNumbers == null ? [] : List<dynamic>.from(phoneNumbers!.map((x) => x.toJson())),
    "calendar": calendar?.toJson(),
    "outlet_grading": outletGrading,
    "allowed_pos_ips": allowedPosIps?.toJson(),
    "outlet_customer_proxy_phone_number": outletCustomerProxyPhoneNumber,
    "allowed_pos_modes": allowedPosModes == null ? [] : List<dynamic>.from(allowedPosModes!.map((x) => x)),
    "quantity_edit_mode": quantityEditMode,
    "line_delete_mode": lineDeleteMode,
    "enable_hold_cart_mode": enableHoldCartMode,
    "price_edit_mode": priceEditMode,
    "sales_associate_link": salesAssociateLink,
    "mandate_register_close_on_logout": mandateRegisterCloseOnLogout,
    "terminals": terminals == null ? [] : List<dynamic>.from(terminals!.map((x) => x.toJson())),
    "is_active": isActive,
  };
}

class Address {
  String? addressLine1;
  String? addressLine2;
  String? addressLine3;
  String? landmark;
  String? municipal;
  String? city;
  String? stateCode;
  String? state;
  String? countryCode;
  String? country;
  String? postCode;
  GeoLocation? geoLocation;

  Address({
    this.addressLine1,
    this.addressLine2,
    this.addressLine3,
    this.landmark,
    this.municipal,
    this.city,
    this.stateCode,
    this.state,
    this.countryCode,
    this.country,
    this.postCode,
    this.geoLocation,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    addressLine1: json["address_line1"],
    addressLine2: json["address_line2"],
    addressLine3: json["address_line3"],
    landmark: json["landmark"],
    municipal: json["municipal"],
    city: json["city"],
    stateCode: json["state_code"],
    state: json["state"],
    countryCode: json["country_code"],
    country: json["country"],
    postCode: json["post_code"],
    geoLocation: json["geo_location"] == null ? null : GeoLocation.fromJson(json["geo_location"]),
  );

  Map<String, dynamic> toJson() => {
    "address_line1": addressLine1,
    "address_line2": addressLine2,
    "address_line3": addressLine3,
    "landmark": landmark,
    "municipal": municipal,
    "city": city,
    "state_code": stateCode,
    "state": state,
    "country_code": countryCode,
    "country": country,
    "post_code": postCode,
    "geo_location": geoLocation?.toJson(),
  };
}

class GeoLocation {
  double? latitude;
  double? longitude;

  GeoLocation({
    this.latitude,
    this.longitude,
  });

  factory GeoLocation.fromJson(Map<String, dynamic> json) => GeoLocation(
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
  };
}

class AllowedPosIps {
  bool? enableIpRestriction;
  List<dynamic>? allowedIpList;
  List<dynamic>? allowedIpRange;

  AllowedPosIps({
    this.enableIpRestriction,
    this.allowedIpList,
    this.allowedIpRange,
  });

  factory AllowedPosIps.fromJson(Map<String, dynamic> json) => AllowedPosIps(
    enableIpRestriction: json["enable_ip_restriction"],
    allowedIpList: json["allowed_ip_list"] == null ? [] : List<dynamic>.from(json["allowed_ip_list"]!.map((x) => x)),
    allowedIpRange: json["allowed_ip_range"] == null ? [] : List<dynamic>.from(json["allowed_ip_range"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "enable_ip_restriction": enableIpRestriction,
    "allowed_ip_list": allowedIpList == null ? [] : List<dynamic>.from(allowedIpList!.map((x) => x)),
    "allowed_ip_range": allowedIpRange == null ? [] : List<dynamic>.from(allowedIpRange!.map((x) => x)),
  };
}

class Calendar {
  String? weekStartFrom;
  String? storeOpeningTime;
  String? storeClosingTime;
  List<String>? weeklyHolidays;
  List<dynamic>? holidays;

  Calendar({
    this.weekStartFrom,
    this.storeOpeningTime,
    this.storeClosingTime,
    this.weeklyHolidays,
    this.holidays,
  });

  factory Calendar.fromJson(Map<String, dynamic> json) => Calendar(
    weekStartFrom: json["week_start_from"],
    storeOpeningTime: json["store_opening_time"],
    storeClosingTime: json["store_closing_time"],
    weeklyHolidays: json["weekly_holidays"] == null ? [] : List<String>.from(json["weekly_holidays"]!.map((x) => x)),
    holidays: json["holidays"] == null ? [] : List<dynamic>.from(json["holidays"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "week_start_from": weekStartFrom,
    "store_opening_time": storeOpeningTime,
    "store_closing_time": storeClosingTime,
    "weekly_holidays": weeklyHolidays == null ? [] : List<dynamic>.from(weeklyHolidays!.map((x) => x)),
    "holidays": holidays == null ? [] : List<dynamic>.from(holidays!.map((x) => x)),
  };
}

class Email {
  String? type;
  String? emailId;

  Email({
    this.type,
    this.emailId,
  });

  factory Email.fromJson(Map<String, dynamic> json) => Email(
    type: json["type"],
    emailId: json["email_id"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "email_id": emailId,
  };
}

class Fssai {
  String? fssaiNumber;
  String? fssaiImageUrl;

  Fssai({
    this.fssaiNumber,
    this.fssaiImageUrl,
  });

  factory Fssai.fromJson(Map<String, dynamic> json) => Fssai(
    fssaiNumber: json["fssai_number"],
    fssaiImageUrl: json["fssai_image_url"],
  );

  Map<String, dynamic> toJson() => {
    "fssai_number": fssaiNumber,
    "fssai_image_url": fssaiImageUrl,
  };
}

class PhoneNumber {
  String? type;
  String? countryCode;
  String? number;
  bool? availability;

  PhoneNumber({
    this.type,
    this.countryCode,
    this.number,
    this.availability,
  });

  factory PhoneNumber.fromJson(Map<String, dynamic> json) => PhoneNumber(
    type: json["type"],
    countryCode: json["country_code"],
    number: json["number"],
    availability: json["availability"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "country_code": countryCode,
    "number": number,
    "availability": availability,
  };
}

class Terminal {
  String? terminalId;
  String? terminalName;
  String? status;
  bool? isEdcIntegrated;
  bool? isWeighingScaleIntegrated;
  LastUsage? lastUsage;
  bool? isActive;

  Terminal({
    this.terminalId,
    this.terminalName,
    this.status,
    this.isEdcIntegrated,
    this.isWeighingScaleIntegrated,
    this.lastUsage,
    this.isActive,
  });

  factory Terminal.fromJson(Map<String, dynamic> json) => Terminal(
    terminalId: json["terminal_id"],
    terminalName: json["terminal_name"],
    status: json["status"],
    isEdcIntegrated: json["is_edc_integrated"],
    isWeighingScaleIntegrated: json["is_weighing_scale_integrated"],
    lastUsage: json["last_usage"] == null ? null : LastUsage.fromJson(json["last_usage"]),
    isActive: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "terminal_id": terminalId,
    "terminal_name": terminalName,
    "status": status,
    "is_edc_integrated": isEdcIntegrated,
    "is_weighing_scale_integrated": isWeighingScaleIntegrated,
    "last_usage": lastUsage?.toJson(),
    "is_active": isActive,
  };
}

class LastUsage {
  LastUsage();

  factory LastUsage.fromJson(Map<String, dynamic> json) => LastUsage(
  );

  Map<String, dynamic> toJson() => {
  };
}
