import 'package:dio/dio.dart' as dio;
import 'package:kpn_pos_application/data_store/shared_preference_helper.dart';
import 'auth_interceptor.dart';

class ApiHelper {
  late dio.Dio _dio;
  final String _baseUrl;
  final SharedPreferenceHelper _sharedPreferenceHelper;

  // Singleton instance
  static ApiHelper? _instance;

  // Private constructor
  ApiHelper._internal(this._baseUrl, this._sharedPreferenceHelper) {
    _dio = dio.Dio(dio.BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    _dio.interceptors.add(AuthInterceptor(_sharedPreferenceHelper));

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
  factory ApiHelper(String baseUrl, SharedPreferenceHelper sharedPreferenceHelper) {
    _instance ??= ApiHelper._internal(baseUrl, sharedPreferenceHelper);
    return _instance!;
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

  T _handleResponse<T>(dio.Response response, T Function(dynamic)? parser) {
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return parser != null ? parser(response.data) : response.data as T;
    } else {
      throw Exception(
          'Failed request: ${response.statusCode} - ${response.statusMessage}');
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
          return Exception(
              "Received invalid status code: ${error.response?.statusCode}");
        case dio.DioExceptionType.connectionError:
          return Exception(
              "Connection to server failed due to internet connection.");
        default:
          return Exception("Unknown Exception.");
      }
    }
    return Exception("Unexpected error occurred.");
  }
}
