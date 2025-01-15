import 'package:dio/dio.dart' as dio;
import 'package:ebono_pos/data_store/hive_storage_helper.dart';
import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';

import 'auth_interceptor.dart';

class ApiHelper {
  late dio.Dio _dio;
  final String _baseUrl;
  final SharedPreferenceHelper _sharedPreferenceHelper;
  final HiveStorageHelper hiveStorageHelper;

  // Singleton instance
  static ApiHelper? _instance;

  // Private constructor
  ApiHelper._internal(
      this._baseUrl, this._sharedPreferenceHelper, this.hiveStorageHelper) {
    _dio = dio.Dio(dio.BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'x-channel-id': 'STORE',
        }));

    _dio.interceptors
        .add(AuthInterceptor(_sharedPreferenceHelper, hiveStorageHelper));

    _dio.interceptors.addAll([
      dio.LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    ]);
  }

  // Factory constructor to return the same instance
  factory ApiHelper(
      String baseUrl,
      SharedPreferenceHelper sharedPreferenceHelper,
      HiveStorageHelper hiveStorageHelper) {
    _instance ??=
        ApiHelper._internal(baseUrl, sharedPreferenceHelper, hiveStorageHelper);
    return _instance!;
  }

  // SSE Subscription
  Stream<SSEModel> subscribeToSSE(String endpoint,
      {Map<String, String>? headers,
      SSERequestType method = SSERequestType.GET}) {
    //final url = '$_baseUrl$endpoint';
    final url = 'https://api-staging.ebono.com/s/$endpoint';
    print("SSE Request URL: $url");

    return SSEClient.subscribeToSSE(
      url: url,
      /* header: headers ?? {
        'Content-Type': 'application/json',
      },*/
      method: SSERequestType.GET,
      header: {},
    );
  }

  // GET request
  Future<T> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic json)? parser,
    dio.CancelToken? cancelToken,
  }) async {
    try {
      dio.Response response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: dio.Options(headers: headers),
        cancelToken: cancelToken,
      );
      return _handleResponse(response, parser);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  Future<T> post<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    T Function(dynamic json)? parser,
    dio.CancelToken? cancelToken,
  }) async {
    try {
      dio.Response response = await _dio.post(
        endpoint,
        data: data,
        options: dio.Options(headers: headers),
        cancelToken: cancelToken,
      );
      return _handleResponse(response, parser);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Delete request
  Future<T> delete<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    T Function(dynamic json)? parser,
    dio.CancelToken? cancelToken,
  }) async {
    try {
      dio.Response response = await _dio.delete(
        endpoint,
        data: data,
        options: dio.Options(headers: headers),
        cancelToken: cancelToken,
      );
      return _handleResponse(response, parser);
    } catch (e) {
      throw _handleError(e);
    }
  }

  T _handleResponse<T>(dio.Response response, T Function(dynamic)? parser) {
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      if (parser != null) {
        return parser(response.data);
      } else {
        // Return data as T if T matches the data type, otherwise throw an error
        if (response.data is T) {
          return response.data;
        } else {
          throw Exception(
            'No parser provided, and response data type does not match expected type $T.',
          );
        }
      }
    } else {
      throw Exception(
        'Failed request: ${response.statusCode} - ${response.statusMessage}',
      );
    }
  }

  Exception _handleError(dynamic error) {
    if (error is dio.DioException) {
      switch (error.type) {
        case dio.DioExceptionType.cancel:
          return Exception("Request to the server was cancelled.");
        case dio.DioExceptionType.connectionTimeout:
          return Exception("Connection timeout with server.");
        case dio.DioExceptionType.receiveTimeout:
          return Exception("Receive timeout in connection with server.");
        case dio.DioExceptionType.sendTimeout:
          return Exception("Send timeout in connection with server.");
        case dio.DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final errorData = error.response?.data;
          String errorMessage = 'Unknown error';
          if (errorData is Map<String, dynamic>) {
            final errors = errorData["errors"];
            if (errors is List && errors.isNotEmpty) {
              final firstError = errors.first;
              if (firstError is Map<String, dynamic>) {
                errorMessage = firstError['error_class'] != null &&
                        firstError['error_class'] == "SHOW_STOPPER"
                    ? "${firstError['error_class']}::${firstError['message']}"
                    : firstError["message"] ?? 'Unknown error';
              }
            }
          }

          return Exception("$statusCode | $errorMessage");

        case dio.DioExceptionType.connectionError:
          return Exception(
            "Connection to server failed due to internet connection.",
          );
        default:
          return Exception("Unknown Exception.");
      }
    }
    return Exception("Unexpected error occurred.");
  }
}
