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
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // Create a map for response data
    if (_isRequestAllowed(response.requestOptions.uri.path)) {
      Map<String, dynamic> requestData = {
        'method': response.requestOptions.method,
        'uri': response.requestOptions.uri.toString(),
        'headers': response.requestOptions.headers,
        'data': response.requestOptions.data,
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

      Map<String, dynamic> responseData = {
        'statusCode': response.statusCode,
        'data': response.data,
        'headers': await _headersToMap(response.headers),
        'requestUri': response.requestOptions.uri.toString(),
        'responseType': response.requestOptions.responseType.toString(),
      };

      print("logg: $requestData $response");

      // Log the response data
      await Logger.logApi(
        request: requestData,
        response: responseData,
        url: response.requestOptions.uri.toString(),
      );
    }

    // Call next handler to pass the response along
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_isRequestAllowed(err.requestOptions.uri.path)) {
      Map<String, dynamic> requestData = {
        'method': err.requestOptions.method,
        'uri': err.requestOptions.uri.toString(),
        'headers': err.requestOptions.headers,
        'data': err.requestOptions.data,
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

      Map<String, dynamic> errorData = {
        'uri': err.requestOptions.uri.toString(),
        'message': err.message ?? 'Unknown error',
        'errorType': err.type.toString(),
        'isTimeout': err.type == DioExceptionType.connectionTimeout ||
            err.type == DioExceptionType.sendTimeout ||
            err.type == DioExceptionType.receiveTimeout,
        'isCancelled': err.type == DioExceptionType.cancel,
        'responseData': err.response?.data,
        'statusCode': err.response?.statusCode,
        'stackTrace': err.stackTrace.toString(),
      };

      await Logger.logApi(
        request: requestData,
        error: errorData,
        url: err.requestOptions.uri.toString(),
      );
    }

    super.onError(err, handler);
  }

  /// Helper method to check if the request is related to payment
  bool _isRequestAllowed(String path) {
    return path.contains('/api/3.0/p2p/') ||
        path.contains(ApiConstants.fetchPaymentSummary) ||
        path.contains(ApiConstants.terminalDetails) ||
        path.contains(ApiConstants.outletDetails) ||
        path.contains(ApiConstants.placeOrder) ||
        path.contains(ApiConstants.orderInvoiceSSE) ||
        path.contains(ApiConstants.walletAuthentication) ||
        path.contains(ApiConstants.getInvoice) ||
        path.contains(ApiConstants.walletCharge);
  }

  CustomLogInterceptor();

  /// Helper function to convert Dio's Headers to a Map<String, String>
  Future<Map<String, dynamic>> _headersToMap(Headers headers) async {
    try {
      final Map<String, dynamic> headersMap = {};
      headers.forEach((key, value) {
        headersMap[key] =
            value.join(", "); // Join multiple values in the list with commas
      });
      return headersMap;
    } catch (e, stack) {
      return {};
    }
  }
}
