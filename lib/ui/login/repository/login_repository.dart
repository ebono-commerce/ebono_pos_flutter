import 'dart:convert';

import 'package:kpn_pos_application/api/api_constants.dart';
import 'package:kpn_pos_application/api/api_helper.dart';
import 'package:kpn_pos_application/ui/login/model/get_terminal_details_request.dart';
import 'package:kpn_pos_application/ui/login/model/login_request.dart';
import 'package:kpn_pos_application/ui/login/model/login_response.dart';
import 'package:kpn_pos_application/ui/login/model/logout_response.dart';
import 'package:kpn_pos_application/ui/login/model/outlet_details_response.dart';
import 'package:kpn_pos_application/ui/login/model/terminal_details_response.dart';

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


  Future<LogoutResponse> logout({required String token}) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.logout,
        data: {'token':token},
      );
      final logoutResponse = logoutResponseFromJson(jsonEncode(response));

      return logoutResponse;
    } catch (e) {
      throw Exception('Failed to parse data');
    }
  }

  Future<OutletDetailsResponse> getOutletDetails(String outletId) async {
    try {
      final response = await _apiHelper.get(
        '${ApiConstants.outletDetails}$outletId/details',

      );
      final outletDetailsResponse = outletDetailsResponseFromJson(jsonEncode(response));
      return outletDetailsResponse;
    } catch (e) {
      throw Exception('Failed to parse data');
    }
  }

  Future<TerminalDetailsResponse> getTerminalDetails(GetTerminalDetailsRequest request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.terminalDetails,
        data: request.toJson(),
      );
      final terminalDetailsResponse = terminalDetailsResponseFromJson(jsonEncode(response));
      return terminalDetailsResponse;
    } catch (e) {
      throw Exception('Failed to parse data');
    }
  }
}
