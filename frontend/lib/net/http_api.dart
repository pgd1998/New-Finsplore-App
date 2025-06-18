import 'package:dio/dio.dart';
import 'package:finsplore/model/model.dart';
import 'package:finsplore/model/result.dart';
import 'package:finsplore/model/pager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// HTTP API client for making requests to the Finsplore backend.
/// Updated to work with the unified backend structure.
class HttpApi<M extends Model<M>> {
  static Dio? _dio;
  final Converter<M> converter;
  final _secureStorage = FlutterSecureStorage();

  HttpApi(this.converter);

  /// Get configured Dio instance
  Dio get dio {
    if (_dio == null) {
      _dio = Dio();
      _setupDio();
    }
    return _dio!;
  }

  /// Setup Dio configuration
  void _setupDio() {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8080';
    final timeout = int.tryParse(dotenv.env['API_TIMEOUT'] ?? '30000') ?? 30000;
    final enableLogging = dotenv.env['ENABLE_LOGGING']?.toLowerCase() == 'true';

    dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(milliseconds: timeout),
      receiveTimeout: Duration(milliseconds: timeout),
      sendTimeout: Duration(milliseconds: timeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add authentication interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add JWT token if available and auth is required
        final token = await _secureStorage.read(key: 'jwt_token');
        if (token != null && !options.path.contains('/auth/')) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        // Handle 401 errors (token expired)
        if (error.response?.statusCode == 401) {
          await _secureStorage.deleteAll();
        }
        handler.next(error);
      },
    ));

    // Add logging in debug mode
    if (enableLogging) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ));
    }
  }

  /// Generic GET request
  Future<Result<Map<String, dynamic>>> get(
    String path, {
    Map<String, dynamic>? query,
    bool useAuth = true,
  }) async {
    try {
      final response = await dio.get(path, queryParameters: query);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return Result.error(message: 'Unexpected error: $e');
    }
  }

  /// GET request for list of items
  Future<List<M>> getList(String path, {bool useAuth = true}) async {
    try {
      final response = await dio.get(path);
      final result = _handleResponse(response);
      
      if (result.success && result.data != null) {
        final List<dynamic> listData = result.data!['data'] ?? result.data!['content'] ?? [];
        return listData.map((item) => converter(item as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching list: $e');
      return [];
    }
  }

  /// GET request for paginated list
  Future<Pager<M>> getPageList(
    String path, {
    Map<String, dynamic>? query,
    bool useAuth = true,
  }) async {
    try {
      final response = await dio.get(path, queryParameters: query);
      final result = _handleResponse(response);
      
      if (result.success && result.data != null) {
        final pageData = result.data!;
        final List<dynamic> content = pageData['content'] ?? [];
        
        return Pager<M>(
          content: content.map((item) => converter(item as Map<String, dynamic>)).toList(),
          page: pageData['number'] ?? 0,
          size: pageData['size'] ?? 20,
          totalElements: pageData['totalElements'] ?? 0,
          totalPages: pageData['totalPages'] ?? 0,
          first: pageData['first'] ?? true,
          last: pageData['last'] ?? true,
          empty: pageData['empty'] ?? true,
        );
      }
      return Pager.empty();
    } catch (e) {
      print('Error fetching page list: $e');
      return Pager.empty();
    }
  }

  /// POST request
  Future<Result<Map<String, dynamic>>> post(
    String path, {
    dynamic data,
    bool useAuth = true,
  }) async {
    try {
      final response = await dio.post(path, data: data?.toJson() ?? data);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return Result.error(message: 'Unexpected error: $e');
    }
  }

  /// PUT request
  Future<Result<Map<String, dynamic>>> put(
    String path, {
    dynamic data,
    bool useAuth = true,
  }) async {
    try {
      final response = await dio.put(path, data: data?.toJson() ?? data);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return Result.error(message: 'Unexpected error: $e');
    }
  }

  /// DELETE request
  Future<bool> delete(String path, {bool useAuth = true}) async {
    try {
      final response = await dio.delete(path);
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error deleting: $e');
      return false;
    }
  }

  /// Handle successful response
  Result<Map<String, dynamic>> _handleResponse(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return Result.success(
        data: response.data is Map<String, dynamic> 
            ? response.data as Map<String, dynamic>
            : {'data': response.data},
        message: 'Request successful',
      );
    } else {
      return Result.error(
        message: 'Request failed with status ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }

  /// Handle Dio errors
  Result<Map<String, dynamic>> _handleDioError(DioException e) {
    String message;
    String? errorCode;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Request timeout. Please check your connection.';
        break;
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;
        
        if (responseData is Map<String, dynamic>) {
          message = responseData['message'] ?? 'Request failed';
          errorCode = responseData['errorCode'];
        } else {
          message = 'Request failed with status $statusCode';
        }
        break;
      case DioExceptionType.cancel:
        message = 'Request was cancelled';
        break;
      case DioExceptionType.connectionError:
        message = 'Connection error. Please check your internet connection.';
        break;
      default:
        message = 'Unexpected error occurred';
    }

    return Result.error(
      message: message,
      errorCode: errorCode,
      statusCode: e.response?.statusCode,
    );
  }
}
