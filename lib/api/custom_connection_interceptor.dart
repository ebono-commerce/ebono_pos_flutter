import 'package:dio/dio.dart';
import 'package:ebono_pos/data_store/shared_preference_helper.dart';

class CustomConnectionInterceptor extends Interceptor {
  final SharedPreferenceHelper _sharedPreferenceHelper;

  CustomConnectionInterceptor(this._sharedPreferenceHelper);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Get current pointing preference
    String pointedTo = await _sharedPreferenceHelper.pointingTo();

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

    return handler.next(options);
  }
}
