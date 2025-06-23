import 'package:dio/dio.dart';
import 'package:ebono_pos/api/environment_config.dart';
import 'package:ebono_pos/data_store/hive_storage_helper.dart';
import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:ebono_pos/navigation/page_routes.dart';
import 'package:get/get.dart';

class AppRequestInterceptor extends Interceptor {
  final SharedPreferenceHelper _sharedPreferenceHelper;
  final HiveStorageHelper hiveStorageHelper;

  AppRequestInterceptor(this._sharedPreferenceHelper, this.hiveStorageHelper);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? token = await _sharedPreferenceHelper.getAuthToken();
    String? appUUID = await _sharedPreferenceHelper.getAppUUID();
    String pointedTo = await _sharedPreferenceHelper.pointingTo();

    if (options.uri.path.contains('/api/3.0/p2p/')) {
      options.baseUrl = EnvironmentConfig.ezetapBaseUrl;
      options.headers['Accept'] = 'application/json, text/plain, */*';
    } else if (options.uri.path.contains('/ecr')) {
      options.baseUrl = EnvironmentConfig.paytmBaseUrl;
    } else if (options.uri.path.contains('metrics-collector')) {
      options.baseUrl = pointedTo == 'LOCAL'
          ? EnvironmentConfig.metricsBaseUrl
          : EnvironmentConfig.metricsBffUrl;
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

      // Check if the URL is using HTTP protocol and is a local address
      final bool isHttpProtocol = options.uri.scheme == 'http';
      final bool isLocalHost = options.uri.host.contains('local') ||
          options.uri.host.contains('localhost') ||
          options.uri.host.contains('127.0.0.1') ||
          options.uri.host.contains('api-local');

      // If it's HTTP and local, mark it with a custom property
      if (isHttpProtocol && isLocalHost) {
        // Add a custom property to options to mark as local HTTP request
        // Only mark as local HTTP request if pointedTo is 'LOCAL'
        options.extra['isLocalHttpRequest'] = (pointedTo == 'LOCAL');
      }
    }
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
