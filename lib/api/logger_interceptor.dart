import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ebono_pos/api/api_constants.dart';
import 'package:ebono_pos/utils/logger.dart';

class CustomLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Call next handler to pass the request along
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Create a map for response data
    if (_isPaymentRequest(response.requestOptions.uri.path)) {
      Map<String, dynamic> responseData = {
        'statusCode': response.statusCode,
        'data': response.data.toString(),
        'headers': _headersToMap(response.headers),
        'requestUri': response.requestOptions.uri.toString(),
        'responseType': response.requestOptions.responseType.toString(),
      };

      Map<String, dynamic> requestData = {
        'method': response.requestOptions.method,
        'uri': response.requestOptions.uri.toString(),
        'headers': response.requestOptions.headers.toString(),
        'data': {
          jsonDecode(
            response.requestOptions.data.toString(),
          )
        },
        'responseType': response.requestOptions.responseType.toString(),
        'followRedirects': response.requestOptions.followRedirects,
        'persistentConnection': response.requestOptions.persistentConnection,
        'connectTimeout':
            response.requestOptions.connectTimeout?.inMilliseconds,
        'sendTimeout': response.requestOptions.sendTimeout?.inMilliseconds,
        'receiveTimeout':
            response.requestOptions.receiveTimeout?.inMilliseconds,
        'receiveDataWhenStatusError':
            response.requestOptions.receiveDataWhenStatusError,
        'extra': response.requestOptions.extra,
      };

      // Log the response data
      Logger.logApi(
        request: requestData,
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
        'statusCode': err.response?.statusCode.toString(),
        'uri': err.requestOptions.uri.toString(),
        'message': err.message,
        'errorType': err.type.toString(),
        'stackTrace': err.stackTrace.toString(),
      };

      Map<String, dynamic> requestData = {
        'method': err.requestOptions.method,
        'uri': err.requestOptions.uri.toString(),
        'headers': err.requestOptions.headers.toString(),
        'data': {jsonEncode(err.requestOptions.data)},
        'responseType': err.requestOptions.responseType.toString(),
        'followRedirects': err.requestOptions.followRedirects,
        'persistentConnection': err.requestOptions.persistentConnection,
        'connectTimeout': err.requestOptions.connectTimeout?.inMilliseconds,
        'sendTimeout': err.requestOptions.sendTimeout?.inMilliseconds,
        'receiveTimeout': err.requestOptions.receiveTimeout?.inMilliseconds,
        'receiveDataWhenStatusError':
            err.requestOptions.receiveDataWhenStatusError,
        'extra': err.requestOptions.extra,
      };

      // Log the error data
      Logger.logApi(
        request: requestData,
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
