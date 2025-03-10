import 'dart:convert';

import 'package:ebono_pos/api/api_constants.dart';
import 'package:ebono_pos/api/api_exception.dart';
import 'package:ebono_pos/api/api_helper.dart';
import 'package:ebono_pos/ui/login/model/get_terminal_details_request.dart';
import 'package:ebono_pos/ui/login/model/login_request.dart';
import 'package:ebono_pos/ui/login/model/login_response.dart';
import 'package:ebono_pos/ui/login/model/logout_request.dart';
import 'package:ebono_pos/ui/login/model/logout_response.dart';
import 'package:ebono_pos/ui/login/model/outlet_details_response.dart';
import 'package:ebono_pos/ui/login/model/terminal_details_response.dart';

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
      throw ApiException(e.toString());
    }
  }


  Future<LogoutResponse> logout({required LogoutRequest request}) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.logout,
        data: request.toJson(),
      );
      final logoutResponse = logoutResponseFromJson(jsonEncode(response));

      return logoutResponse;
    } catch (e) {
      throw ApiException(e.toString());
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
      throw ApiException(e.toString());
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
      throw ApiException(e.toString());
    }
  }
}
