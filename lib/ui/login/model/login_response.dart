import 'dart:convert';

LoginResponse loginResponseFromJson(dynamic str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  String token;
  UserDetails userDetails;
  List<OutletDetail> outletDetails;

  LoginResponse({
    required this.token,
    required this.userDetails,
    required this.outletDetails,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    token: json["token"],
    userDetails: UserDetails.fromJson(json["user_details"]),
    outletDetails: List<OutletDetail>.from(json["outlet_details"].map((x) => OutletDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user_details": userDetails.toJson(),
    "outlet_details": List<dynamic>.from(outletDetails.map((x) => x.toJson())),
  };
}

class OutletDetail {
  String outletId;
  String name;

  OutletDetail({
    required this.outletId,
    required this.name,
  });

  factory OutletDetail.fromJson(Map<String, dynamic> json) => OutletDetail(
    outletId: json["outlet_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "outlet_id": outletId,
    "name": name,
  };
}

class UserDetails {
  String fullName;
  String userType;

  UserDetails({
    required this.fullName,
    required this.userType,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
    fullName: json["full_name"],
    userType: json["user_type"],
  );

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "user_type": userType,
  };
}
