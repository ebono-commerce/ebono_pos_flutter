import 'package:kpn_pos_application/api/api_constants.dart';
import 'package:kpn_pos_application/api/api_helper.dart';
import 'package:kpn_pos_application/ui/login/model/login_request.dart';

class LoginRepository {
  final ApiHelper _apiHelper;

  LoginRepository(this._apiHelper);

  Future<Map<String, dynamic>> login(LoginRequest request) async {
    try {
      final response = await _apiHelper.post(
        ApiConstants.login,
        data: request.toJson(),
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to post data');
    }
  }

  Future<List<dynamic>> getNodes() async {
    try {
      final response = await _apiHelper.get('/nodes',);
      return response.data;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }
}
