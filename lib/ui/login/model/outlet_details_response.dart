import 'dart:convert';

OutletDetailsResponse outletDetailsResponseFromJson(str) => OutletDetailsResponse.fromJson(json.decode(str));

String outletDetailsResponseToJson(OutletDetailsResponse data) => json.encode(data.toJson());

class OutletDetailsResponse {
  String outletId;
  String name;
  String shortName;
  String zoneId;
  String zoneShortCode;
  Address address;
  String clusterId;
  String gstin;
  Fssai fssai;
  List<Email> emails;
  List<PhoneNumber> phoneNumbers;
  Calendar calendar;
  String outletGrading;
  AllowedPosIps allowedPosIps;
  String outletCustomerProxyPhoneNumber;
  List<String> allowedPosModes;
  String quantityEditMode;
  String lineDeleteMode;
  String enableHoldCartMode;
  String priceEditMode;
  String salesAssociateLink;
  String mandateRegisterCloseOnLogout;
  List<Terminal> terminals;
  bool isActive;

  OutletDetailsResponse({
    required this.outletId,
    required this.name,
    required this.shortName,
    required this.zoneId,
    required this.zoneShortCode,
    required this.address,
    required this.clusterId,
    required this.gstin,
    required this.fssai,
    required this.emails,
    required this.phoneNumbers,
    required this.calendar,
    required this.outletGrading,
    required this.allowedPosIps,
    required this.outletCustomerProxyPhoneNumber,
    required this.allowedPosModes,
    required this.quantityEditMode,
    required this.lineDeleteMode,
    required this.enableHoldCartMode,
    required this.priceEditMode,
    required this.salesAssociateLink,
    required this.mandateRegisterCloseOnLogout,
    required this.terminals,
    required this.isActive,
  });

  factory OutletDetailsResponse.fromJson(Map<String, dynamic> json) => OutletDetailsResponse(
    outletId: json["outlet_id"],
    name: json["name"],
    shortName: json["short_name"],
    zoneId: json["zone_id"],
    zoneShortCode: json["zone_short_code"],
    address: Address.fromJson(json["address"]),
    clusterId: json["cluster_id"],
    gstin: json["gstin"],
    fssai: Fssai.fromJson(json["fssai"]),
    emails: List<Email>.from(json["emails"].map((x) => Email.fromJson(x))),
    phoneNumbers: List<PhoneNumber>.from(json["phone_numbers"].map((x) => PhoneNumber.fromJson(x))),
    calendar: Calendar.fromJson(json["calendar"]),
    outletGrading: json["outlet_grading"],
    allowedPosIps: AllowedPosIps.fromJson(json["allowed_pos_ips"]),
    outletCustomerProxyPhoneNumber: json["outlet_customer_proxy_phone_number"],
    allowedPosModes: List<String>.from(json["allowed_pos_modes"].map((x) => x)),
    quantityEditMode: json["quantity_edit_mode"],
    lineDeleteMode: json["line_delete_mode"],
    enableHoldCartMode: json["enable_hold_cart_mode"],
    priceEditMode: json["price_edit_mode"],
    salesAssociateLink: json["sales_associate_link"],
    mandateRegisterCloseOnLogout: json["mandate_register_close_on_logout"],
    terminals: List<Terminal>.from(json["terminals"].map((x) => Terminal.fromJson(x))),
    isActive: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "outlet_id": outletId,
    "name": name,
    "short_name": shortName,
    "zone_id": zoneId,
    "zone_short_code": zoneShortCode,
    "address": address.toJson(),
    "cluster_id": clusterId,
    "gstin": gstin,
    "fssai": fssai.toJson(),
    "emails": List<dynamic>.from(emails.map((x) => x.toJson())),
    "phone_numbers": List<dynamic>.from(phoneNumbers.map((x) => x.toJson())),
    "calendar": calendar.toJson(),
    "outlet_grading": outletGrading,
    "allowed_pos_ips": allowedPosIps.toJson(),
    "outlet_customer_proxy_phone_number": outletCustomerProxyPhoneNumber,
    "allowed_pos_modes": List<dynamic>.from(allowedPosModes.map((x) => x)),
    "quantity_edit_mode": quantityEditMode,
    "line_delete_mode": lineDeleteMode,
    "enable_hold_cart_mode": enableHoldCartMode,
    "price_edit_mode": priceEditMode,
    "sales_associate_link": salesAssociateLink,
    "mandate_register_close_on_logout": mandateRegisterCloseOnLogout,
    "terminals": List<dynamic>.from(terminals.map((x) => x.toJson())),
    "is_active": isActive,
  };
}

class Address {
  String addressLine1;
  String addressLine2;
  String addressLine3;
  String landmark;
  String municipal;
  String city;
  String stateCode;
  String state;
  String countryCode;
  String country;
  String postCode;
  GeoLocation geoLocation;

  Address({
    required this.addressLine1,
    required this.addressLine2,
    required this.addressLine3,
    required this.landmark,
    required this.municipal,
    required this.city,
    required this.stateCode,
    required this.state,
    required this.countryCode,
    required this.country,
    required this.postCode,
    required this.geoLocation,
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
    geoLocation: GeoLocation.fromJson(json["geo_location"]),
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
    "geo_location": geoLocation.toJson(),
  };
}

class GeoLocation {
  double latitude;
  double longitude;

  GeoLocation({
    required this.latitude,
    required this.longitude,
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
  bool enableIpRestriction;
  List<dynamic> allowedIpList;
  List<dynamic> allowedIpRange;

  AllowedPosIps({
    required this.enableIpRestriction,
    required this.allowedIpList,
    required this.allowedIpRange,
  });

  factory AllowedPosIps.fromJson(Map<String, dynamic> json) => AllowedPosIps(
    enableIpRestriction: json["enable_ip_restriction"],
    allowedIpList: List<dynamic>.from(json["allowed_ip_list"].map((x) => x)),
    allowedIpRange: List<dynamic>.from(json["allowed_ip_range"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "enable_ip_restriction": enableIpRestriction,
    "allowed_ip_list": List<dynamic>.from(allowedIpList.map((x) => x)),
    "allowed_ip_range": List<dynamic>.from(allowedIpRange.map((x) => x)),
  };
}

class Calendar {
  String weekStartFrom;
  String storeOpeningTime;
  String storeClosingTime;
  List<String> weeklyHolidays;
  List<dynamic> holidays;

  Calendar({
    required this.weekStartFrom,
    required this.storeOpeningTime,
    required this.storeClosingTime,
    required this.weeklyHolidays,
    required this.holidays,
  });

  factory Calendar.fromJson(Map<String, dynamic> json) => Calendar(
    weekStartFrom: json["week_start_from"],
    storeOpeningTime: json["store_opening_time"],
    storeClosingTime: json["store_closing_time"],
    weeklyHolidays: List<String>.from(json["weekly_holidays"].map((x) => x)),
    holidays: List<dynamic>.from(json["holidays"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "week_start_from": weekStartFrom,
    "store_opening_time": storeOpeningTime,
    "store_closing_time": storeClosingTime,
    "weekly_holidays": List<dynamic>.from(weeklyHolidays.map((x) => x)),
    "holidays": List<dynamic>.from(holidays.map((x) => x)),
  };
}

class Email {
  String type;
  String emailId;

  Email({
    required this.type,
    required this.emailId,
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
  String fssaiNumber;
  String fssaiImageUrl;

  Fssai({
    required this.fssaiNumber,
    required this.fssaiImageUrl,
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
  String type;
  String countryCode;
  String number;
  bool availability;

  PhoneNumber({
    required this.type,
    required this.countryCode,
    required this.number,
    required this.availability,
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
  String terminalId;
  String terminalName;
  String status;
  bool isEdcIntegrated;
  bool isWeighingScaleIntegrated;
  LastUsage lastUsage;
  bool isActive;

  Terminal({
    required this.terminalId,
    required this.terminalName,
    required this.status,
    required this.isEdcIntegrated,
    required this.isWeighingScaleIntegrated,
    required this.lastUsage,
    required this.isActive,
  });

  factory Terminal.fromJson(Map<String, dynamic> json) => Terminal(
    terminalId: json["terminal_id"],
    terminalName: json["terminal_name"],
    status: json["status"],
    isEdcIntegrated: json["is_edc_integrated"],
    isWeighingScaleIntegrated: json["is_weighing_scale_integrated"],
    lastUsage: LastUsage.fromJson(json["last_usage"]),
    isActive: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "terminal_id": terminalId,
    "terminal_name": terminalName,
    "status": status,
    "is_edc_integrated": isEdcIntegrated,
    "is_weighing_scale_integrated": isWeighingScaleIntegrated,
    "last_usage": lastUsage.toJson(),
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
