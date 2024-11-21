import 'dart:convert';

LoginRequest loginRequestFromJson(String str) => LoginRequest.fromJson(json.decode(str));

String loginRequestToJson(LoginRequest data) => json.encode(data.toJson());

class LoginRequest {
  String userName;
  String password;

  LoginRequest({
    required this.userName,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
    userName: json["username"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "username": userName,
    "password": password,
  };
}