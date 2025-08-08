import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
class ApiHelper {
  static final ApiHelper _instance = ApiHelper._internal();

  factory ApiHelper() => _instance;

  ApiHelper._internal();

  late Dio _dio;
  Future<void> init() async {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      );
    }
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool skipAuth = false,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  dynamic _handleError(DioException e) {
    if (e.response?.data != null) {
      final responseData = e.response?.data;

      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('errors')) {
        final errors = responseData['errors'];
        if (errors is Map<String, dynamic>) {
          final errorMessages = <String, dynamic>{};
          errors.forEach((key, value) {
            if (value is Map<String, dynamic>) {
              value.forEach((k, v) {
                errorMessages['$key.$k'] = v;
              });
            } else if (value is List) {
              errorMessages[key] = value;
            } else {
              errorMessages[key] = value;
            }
          });
          return errorMessages;
        }
      }

      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('message')) {
        return responseData['message'];
      }
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        switch (e.response?.statusCode) {
          case 400:
            return 'Bad request. Please check your input.';
          case 401:
            return 'Unauthorized. Please login again.';
          case 403:
            return 'Forbidden. You don\'t have permission to access this resource.';
          case 404:
            return 'Resource not found.';
          case 500:
            return 'Server error. Please try again later.';
          default:
            return 'An error occurred. Please try again.';
        }
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      case DioExceptionType.unknown:
        return 'Unknown error occurred. Please check your internet connection.';
      default:
        return 'An error occurred. Please try again.';
    }
  }


}
