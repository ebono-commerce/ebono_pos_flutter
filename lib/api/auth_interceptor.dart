import 'package:dio/dio.dart';
import 'package:ebono_pos/api/api_constants.dart';
import 'package:ebono_pos/api/environment_config.dart';
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
    String pointedTo = await _sharedPreferenceHelper.pointingTo();

    // Check if it's a local HTTP request (marked by the CustomConnectionInterceptor)
    final bool isLocalHttpRequest = options.extra['isLocalHttpRequest'] == true;

    if (options.uri.path.contains('/api/3.0/p2p/')) {
      options.baseUrl = EnvironmentConfig.paymentBaseUrl;
      options.headers['Content-Type'] = 'application/json';
      options.headers['Accept'] = 'application/json, text/plain, */*';

      if (options.uri.path.contains('/status')) {
        options.path = ApiConstants.paymentApiStatus;
      } else if (options.uri.path.contains('/start')) {
        options.path = ApiConstants.paymentApiInitiate;
      } else if (options.uri.path.contains('/cancel')) {
        options.path = ApiConstants.paymentApiCancel;
      }
    } else if (options.uri.path.contains('metrics-collector')) {
      options.baseUrl = EnvironmentConfig.metricsBaseUrl;
    } else if (options.uri.path.contains('/health')) {
      /* made duration to 5 sec, in order to reduce time out in login when switching*/
      options.connectTimeout = Duration(seconds: 5);
    } else {
      if (token != null && !options.uri.path.contains('/login')) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      if (appUUID != null) {
        options.headers['x-app-id'] = appUUID;
      }
      options.queryParameters.addAll({'channel': 'STORE'});
      options.baseUrl = pointedTo == 'LOCAL'
          ? EnvironmentConfig.baseUrl
          : EnvironmentConfig.bffUrl;
    }
    print('app id : $appUUID');
    print('token $token');
    print('isLocalHttpRequest: $isLocalHttpRequest');
    // Continue with the request
    return handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
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
