// To parse this JSON data, do
//
//     final deleteCartRequest = deleteCartRequestFromJson(jsonString);

import 'dart:convert';

DeleteCartRequest deleteCartRequestFromJson(dynamic str) =>
    DeleteCartRequest.fromJson(json.decode(str));

String deleteCartRequestToJson(DeleteCartRequest data) =>
    json.encode(data.toJson());

class DeleteCartRequest {
  DeleteCartRequest();

  factory DeleteCartRequest.fromJson(Map<String, dynamic> json) =>
      DeleteCartRequest();

  Map<String, dynamic> toJson() => {};
}
