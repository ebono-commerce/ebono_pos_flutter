import 'package:dio/dio.dart';
import 'package:ebono_pos/api/api_constants.dart';
import 'package:ebono_pos/data_store/hive_storage_helper.dart';
import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:ebono_pos/navigation/page_routes.dart';
import 'package:get/get.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferenceHelper _sharedPreferenceHelper;
  final HiveStorageHelper hiveStorageHelper;

  AuthInterceptor(this._sharedPreferenceHelper, this.hiveStorageHelper);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? token = await _sharedPreferenceHelper.getAuthToken();
    String? appUUID = await _sharedPreferenceHelper.getAppUUID();

    if (options.uri.path.contains('/api/3.0/p2p/')) {
      options.baseUrl = ApiConstants.paymentBaseUrl;
      options.headers['Content-Type'] = 'application/json';
      options.headers['Accept'] = 'application/json, text/plain, */*';

      if (options.uri.path.contains('/status')) {
        options.path = ApiConstants.paymentApiStatus;
      } else if (options.uri.path.contains('/start')) {
        options.path = ApiConstants.paymentApiInitiate;
      } else if (options.uri.path.contains('/cancel')) {
        options.path = ApiConstants.paymentApiCancel;
      }
    } else {
      if (token != null && !options.uri.path.contains('/login')) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      if (appUUID != null) {
        options.headers['x-app-id'] = appUUID;
      }
      options.queryParameters.addAll({'channel': 'STORE'});
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
        hiveStorageHelper.clear();
        Get.offAllNamed(PageRoutes.login);
      }
    }

    // Forward the error to the next handler
    super.onError(err, handler);
  }
}
