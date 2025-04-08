import 'package:dio/dio.dart';

class CustomConnectionInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Check if the URL is using HTTP protocol and is a local address
    final bool isHttpProtocol = options.uri.scheme == 'http';
    final bool isLocalHost = options.uri.host.contains('local') ||
        options.uri.host.contains('localhost') ||
        options.uri.host.contains('127.0.0.1') ||
        options.uri.host.contains('api-local');

    // If it's HTTP and local, mark it with a custom property
    if (isHttpProtocol && isLocalHost) {
      // Add a custom property to options to mark as local HTTP request
      options.extra['isLocalHttpRequest'] = true;
    }

    return handler.next(options);
  }
}
