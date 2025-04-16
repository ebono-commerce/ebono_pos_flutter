import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

class CustomHttpClientAdapter extends IOHttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    // Check if this is a local HTTP request (marked by our interceptor)
    final bool isLocalHttpRequest = options.extra['isLocalHttpRequest'] == true;

    if (isLocalHttpRequest) {
      // For local HTTP requests, use a more permissive HttpClient
      final httpClient = HttpClient();

      // Bypass certificate checks for local development
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      // Override the createHttpClient to use our custom client
      createHttpClient = () => httpClient;
    }

    try {
      return await super.fetch(options, requestStream, cancelFuture);
    } catch (e) {
      if (isLocalHttpRequest && e is SocketException) {
        // For local HTTP requests with socket exceptions,
        // we can create a custom response indicating local server is not running
        return ResponseBody(
          Stream.value(
            Uint8List.fromList(
              '{"message": "Local server unavailable"}'.codeUnits,
            ),
          ),
          503, // Service Unavailable
          headers: {
            HttpHeaders.contentTypeHeader: ['application/json'],
          },
          isRedirect: false,
          redirects: [],
          statusMessage: 'Local Server Unavailable',
        );
      }
      // For other errors, rethrow
      rethrow;
    }
  }
}
