import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/authentication_service.dart';
import '../app/app.locator.dart';

/// Simple API base class that provides common Dio configuration and error handling
class SimpleApiBase {
  late final Dio dio;
  final AuthenticationService _authService = locator<AuthenticationService>();

  SimpleApiBase() {
    dio = Dio();
    _configureInterceptors();
  }

  void _configureInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Set base URL from environment or use default
          options.baseUrl =
              dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080';

          // Add authentication headers
          final authHeaders = _authService.getAuthHeaders();
          options.headers.addAll(authHeaders);

          // Log request (in debug mode)
          print('🌐 ${options.method} ${options.uri}');
          if (options.data != null) {
            print('📤 Request data: ${options.data}');
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response (in debug mode)
          print('✅ ${response.statusCode} ${response.requestOptions.uri}');
          handler.next(response);
        },
        onError: (error, handler) {
          // Log error
          print('❌ ${error.response?.statusCode} ${error.requestOptions.uri}');
          print('❌ Error: ${error.response?.data}');
          handler.next(error);
        },
      ),
    );

    // Set timeouts
    dio.options.connectTimeout = Duration(seconds: 30);
    dio.options.receiveTimeout = Duration(seconds: 30);
    dio.options.sendTimeout = Duration(seconds: 30);
  }

  /// Common error handling method
  Exception handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception(
              'Connection timeout. Please check your internet connection.');

        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message =
              error.response?.data?['message'] ?? 'Unknown error occurred';

          switch (statusCode) {
            case 400:
              return Exception('Bad request: $message');
            case 401:
              return Exception('Unauthorized. Please login again.');
            case 403:
              return Exception('Access forbidden.');
            case 404:
              return Exception('Resource not found.');
            case 500:
              return Exception('Server error. Please try again later.');
            default:
              return Exception('HTTP $statusCode: $message');
          }

        case DioExceptionType.cancel:
          return Exception('Request was cancelled.');

        case DioExceptionType.unknown:
        default:
          return Exception('Network error: ${error.message}');
      }
    }
    return Exception('Unexpected error: $error');
  }
}
