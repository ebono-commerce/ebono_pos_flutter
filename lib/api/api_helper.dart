import 'package:dio/dio.dart' as dio;
import 'package:ebono_pos/api/environment_config.dart';
import 'package:ebono_pos/data_store/hive_storage_helper.dart';
import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';

import 'auth_interceptor.dart';
import 'custom_connection_interceptor.dart';
import 'custom_http_client_adapter.dart';
import 'logger_interceptor.dart';

class ApiHelper {
  late dio.Dio _dio;
  final String _baseUrl;
  final SharedPreferenceHelper _sharedPreferenceHelper;
  final HiveStorageHelper hiveStorageHelper;

  // Singleton instance
  static ApiHelper? _instance;

  // Add token manager
  final Map<String, dio.CancelToken> _tokenStore = {};

  // Add getter for active tokens count
  int get activeTokensCount => _tokenStore.length;

  // Add method to cancel all tokens
  void cancelAllRequests([String? reason]) {
    _tokenStore.forEach((_, token) {
      if (!token.isCancelled) {
        token.cancel(reason ?? 'All requests cancelled');
      }
    });
    _tokenStore.clear();
  }

  // Add method to create and track token
  dio.CancelToken _createToken(String endpoint) {
    final token = dio.CancelToken();
    _tokenStore[endpoint] = token;

    // Remove from store when cancelled
    token.whenCancel.then((_) {
      _tokenStore.remove(endpoint);
    });

    return token;
  }

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

    // Set our custom HTTP client adapter
    _dio.httpClientAdapter = CustomHttpClientAdapter();

    // Add our custom connection interceptor first
    _dio.interceptors.add(CustomConnectionInterceptor(_sharedPreferenceHelper));

    // Then add auth interceptor
    _dio.interceptors
        .add(AuthInterceptor(_sharedPreferenceHelper, hiveStorageHelper));

    _dio.interceptors.addAll([
      CustomLogInterceptor(),
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
    final url = '${EnvironmentConfig.sseBaseUrl}$endpoint';
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
      final token = cancelToken ?? _createToken(endpoint);
      dio.Response response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: dio.Options(headers: headers),
        cancelToken: token,
      );
      return _handleResponse(response, parser);
    } catch (e) {
      throw _handleError(e, endpoint);
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
      final token = cancelToken ?? _createToken(endpoint);
      dio.Response response = await _dio.post(
        endpoint,
        data: data,
        options: dio.Options(headers: headers),
        cancelToken: token,
      );
      return _handleResponse(response, parser);
    } catch (e) {
      throw _handleError(e, endpoint);
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
      final token = cancelToken ?? _createToken(endpoint);
      dio.Response response = await _dio.delete(
        endpoint,
        data: data,
        options: dio.Options(headers: headers),
        cancelToken: token,
      );
      return _handleResponse(response, parser);
    } catch (e) {
      throw _handleError(e, endpoint);
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

  Exception _handleError(dynamic error, String endpoint) {
    if (error is dio.DioException) {
      // Special handling for connectionError when it's a local HTTP request
      if (error.type == dio.DioExceptionType.connectionError &&
          error.requestOptions.extra.containsKey('isLocalHttpRequest') &&
          error.requestOptions.extra['isLocalHttpRequest'] == true) {
        // For local HTTP requests with connection errors, we'll create a better message
        // but still throw the error so it can be handled properly by the app
        return Exception(
          "Local API not available. Ensure your local server is running.",
        );
      }

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
