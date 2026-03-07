import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:fix_my_town/core/api/api_endpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: ApiEndpoints.connectionTimeout,
        receiveTimeout: ApiEndpoints.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Info: Add intercept
    _dio.interceptors.add(_AuthInterceptor());

    // Info: Auto retry on network failures
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
        retryEvaluator: (error, attempt) {
          // info: retry on connection error and timeout, not on 404, 4xx/5xx
          return error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.connectionError;
        },
      ),
    );

    // Note: only add logger in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          compact: true,
        ),
      );
    }
  }

  Dio get dio => _dio;

  // Info: GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? option,
  }) async {
    return _dio.get(path, queryParameters: queryParameters, options: option);
  }

  // Info: POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? option,
  }) async {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: option,
    );
  }

  // Info: PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? option,
  }) async {
    return _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: option,
    );
  }

  // Info: PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? option,
  }) async {
    return _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: option,
    );
  }

  // Info: DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? option,
  }) async {
    return _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: option,
    );
  }

  // Info: multipart request for file uploads
  Future<Response> uploadFile(
    String path, {
    required FormData formData,
    Options? options,
    ProgressCallback? onSendProgress,
  }) async {
    return _dio.post(
      path,
      data: formData,
      options: options,
      onSendProgress: onSendProgress,
    );
  }
}

// Info: Auth interceptor to add JWT token to request
class _AuthInterceptor extends Interceptor {
  final _storage = const FlutterSecureStorage();
  static const String _tokenKey = "auth_token";

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // info: skip auth for public endpoints
    final publicEndPoints = [ApiEndpoints.userLogin, ApiEndpoints.userRegister];

    final isPublicGet =
        options.method == "GET" &&
        publicEndPoints.any((endpoint) => options.path.startsWith(endpoint));

    final isAuthEndpoint =
        options.path == ApiEndpoints.userLogin ||
        options.path == ApiEndpoints.userRegister;

    if (!isPublicGet && !isAuthEndpoint) {
      final token = await _storage.read(key: _tokenKey);
      if (token != null) {
        options.headers["Authorization"] = "Bearer $token";
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Info: Handle 401 unauthorized - token expire
    if (err.response?.statusCode == 401) {
      // info: Clear token and redirect to login
      _storage.delete(key: _tokenKey);
      // info: You can add navigation logic here or use a callback
    }
    handler.next(err);
  }
}
