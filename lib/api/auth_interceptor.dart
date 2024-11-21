import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kpn_pos_application/data_store/get_storage_helper.dart';
import 'package:kpn_pos_application/data_store/shared_preference_helper.dart';
import 'package:kpn_pos_application/navigation/page_routes.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferenceHelper _sharedPreferenceHelper;

  AuthInterceptor(this._sharedPreferenceHelper);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? token = await _sharedPreferenceHelper.getAuthToken();
    String? appUUID = await _sharedPreferenceHelper.getAppUUID();

    if (token != null && !options.uri.path.contains('/login')) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    if (appUUID != null) {
      options.headers['x-app-id'] = appUUID;
    }
    print('app id : $appUUID');
    print('token $token');
    // Continue with the request
    return handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      print('Token expired or unauthorized');
      bool isLoggedIn = await _sharedPreferenceHelper.getLoginStatus() ?? false;
      if (isLoggedIn) {
        _sharedPreferenceHelper.clearAll();
        GetStorageHelper.clear();
        Get.offAllNamed(PageRoutes.login);
      }
    }

    // Forward the error to the next handler
    super.onError(err, handler);
  }
}
