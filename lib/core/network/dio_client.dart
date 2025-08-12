import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class DioClient {
  static Dio? _dio;

  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add logging interceptor for debug prints
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: true,
        logPrint: (obj) {
          // Custom debug print with timestamp
          final timestamp = DateTime.now().toIso8601String();
          debugPrint('🌐 [DIO] [$timestamp] $obj');
        },
      ),
    );

    // Add interceptors
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Debug print for request
          debugPrint('🚀 [DIO] REQUEST: ${options.method} ${options.path}');
          debugPrint('🚀 [DIO] Headers: ${options.headers}');
          if (options.data != null) {
            debugPrint('🚀 [DIO] Request Data: ${options.data}');
          }
          if (options.queryParameters.isNotEmpty) {
            debugPrint('🚀 [DIO] Query Parameters: ${options.queryParameters}');
          }

          // Add auth token if available
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString(AppConstants.authTokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
            debugPrint(
              '🔐 [DIO] Authorization header added: Bearer ${token.substring(0, 10)}...',
            );
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          // Debug print for response
          debugPrint(
            '✅ [DIO] RESPONSE: ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}',
          );
          debugPrint('✅ [DIO] Response Data: ${response.data}');
          debugPrint('✅ [DIO] Response Headers: ${response.headers}');
          handler.next(response);
        },
        onError: (error, handler) {
          // Debug print for error
          debugPrint('❌ [DIO] ERROR: ${error.type}');
          debugPrint('❌ [DIO] Error Message: ${error.message}');
          debugPrint('❌ [DIO] Error Response: ${error.response?.data}');
          debugPrint('❌ [DIO] Error Status Code: ${error.response?.statusCode}');
          debugPrint(
            '❌ [DIO] Error Request: ${error.requestOptions.method} ${error.requestOptions.path}',
          );
          handler.next(error);
        },
      ),
    );

    return dio;
  }

  static void clearInstance() {
    _dio = null;
  }
}
