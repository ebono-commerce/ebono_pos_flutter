import 'package:dio/dio.dart';
import 'package:ebono_pos/api/api_constants.dart';
import 'package:ebono_pos/utils/logger.dart';

class CustomLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Creating a Map to store the log information
    if (_isPaymentRequest(options.uri.path)) {
      Map<String, dynamic> requestData = {
        'method': options.method,
        'uri': options.uri.toString(),
        'headers': options.headers,
        'data': options.data,
        'responseType': options.responseType.toString(),
        'followRedirects': options.followRedirects,
        'persistentConnection': options.persistentConnection,
        'connectTimeout': options.connectTimeout?.inMilliseconds,
        'sendTimeout': options.sendTimeout?.inMilliseconds,
        'receiveTimeout': options.receiveTimeout?.inMilliseconds,
        'receiveDataWhenStatusError': options.receiveDataWhenStatusError,
        'extra': options.extra,
      };

      // Logging the API request data via Logger
      Logger.logApi(
        request: requestData,
        url: options.uri.toString(),
      );
    }

    // Call next handler to pass the request along
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Create a map for response data
    if (_isPaymentRequest(response.requestOptions.uri.path)) {
      Map<String, dynamic> responseData = {
        'statusCode': response.statusCode,
        'data': response.data,
        'headers': _headersToMap(response.headers),
        'requestUri': response.requestOptions.uri.toString(),
        'responseType': response.requestOptions.responseType.toString(),
      };

      // Log the response data
      Logger.logApi(
        response: responseData,
        url: response.requestOptions.uri.toString(),
      );
    }

    // Call next handler to pass the response along
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Create a map for error data
    if (_isPaymentRequest(err.requestOptions.uri.path)) {
      Map<String, dynamic> errorData = {
        'uri': err.requestOptions.uri.toString(),
        'message': err.message,
        'errorType': err.type.toString(),
        'stackTrace': err.stackTrace.toString(),
      };

      // Log the error data
      Logger.logApi(
        error: errorData,
        url: err.requestOptions.uri.toString(),
      );
    }

    // Call next handler to pass the error along
    super.onError(err, handler);
  }

  /// Helper method to check if the request is related to payment
  bool _isPaymentRequest(String path) {
    return path.contains('/api/3.0/p2p/') ||
        path.contains(ApiConstants.fetchPaymentSummary) ||
        path.contains(ApiConstants.placeOrder) ||
        path.contains(ApiConstants.orderInvoiceSSE) ||
        path.contains(ApiConstants.walletAuthentication) ||
        path.contains(ApiConstants.getInvoice) ||
        path.contains(ApiConstants.walletCharge);
  }

  /// Helper function to convert Dio's Headers to a Map<String, String>
  Map<String, dynamic> _headersToMap(Headers headers) {
    final Map<String, dynamic> headersMap = {};
    headers.forEach((key, value) {
      headersMap[key] =
          value.join(", "); // Join multiple values in the list with commas
    });
    return headersMap;
  }
}
