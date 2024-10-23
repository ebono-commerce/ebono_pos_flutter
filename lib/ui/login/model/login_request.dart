// To parse this JSON data, do
//
//     final loginRequest = loginRequestFromJson(jsonString);

import 'dart:convert';

LoginRequest loginRequestFromJson(String str) => LoginRequest.fromJson(json.decode(str));

String loginRequestToJson(LoginRequest data) => json.encode(data.toJson());

class LoginRequest {
  String loginId;
  String password;

  LoginRequest({
    required this.loginId,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
    loginId: json["loginId"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "loginId": loginId,
    "password": password,
  };
}