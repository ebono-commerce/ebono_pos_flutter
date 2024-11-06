import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kpn_pos_application/data_store/shared_preference_helper.dart';
import 'package:kpn_pos_application/navigation/page_routes.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferenceHelper _sharedPreferenceHelper;

  AuthInterceptor(this._sharedPreferenceHelper);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Retrieve the token using SharedPreferenceHelper
    String? token = await _sharedPreferenceHelper.getAuthToken();

    if (token != null) {
      // Add the token to the Authorization header if it exists
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Continue with the request
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle errors like token expiry
    if (err.response?.statusCode == 401) {
      // Token expired or unauthorized
      print('Token expired or unauthorized');

      // Clear the token on error (optional)
      _sharedPreferenceHelper.clearAuthToken();

      // You can also redirect the user to the login page here if necessary
       Get.offAllNamed(PageRoutes.login);
    }

    // Forward the error to the next handler
    super.onError(err, handler);
  }
}
