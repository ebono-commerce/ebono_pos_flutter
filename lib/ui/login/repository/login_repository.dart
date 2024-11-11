import 'dart:convert';

import 'package:kpn_pos_application/api/api_constants.dart';
import 'package:kpn_pos_application/api/api_helper.dart';
import 'package:kpn_pos_application/ui/login/model/login_request.dart';
import 'package:kpn_pos_application/ui/login/model/login_response.dart';

class LoginRepository {
  final ApiHelper _apiHelper;

  LoginRepository(this._apiHelper);

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.login,
        data: request.toJson(),
        // parser: (json) => compute(loginResponseFromJson, json),
      );
      final loginResponse = loginResponseFromJson(jsonEncode(response));

      // var data = await compute(loginResponseFromJson, jsonEncode(response.toString()));
      // return data;
      return loginResponse;
    } catch (e) {
      throw Exception('Failed to parse data');
    }
  }

  Future<List<dynamic>> getNodes() async {
    try {
      final response = await _apiHelper.get(
        '/nodes',
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }
}
