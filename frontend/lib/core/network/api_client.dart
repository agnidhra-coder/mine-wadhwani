import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mine_wadhwani/core/constants/api_constants.dart';
import 'package:mine_wadhwani/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mine_wadhwani/core/constants/app_constants.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

enum HttpMethod {
  get,
  put,
  post,
  patch,
  delete;
}

class ApiClient {
  late final Dio _dio;
  final SharedPreferences _sharedPreferences;
  late String baseUrl;
  final String _defaultBaseUrl;

  ApiClient({
    required SharedPreferences sharedPreferences,
    required Talker talker,
    String? baseUrl,
  })  : _sharedPreferences = sharedPreferences,
        _defaultBaseUrl = baseUrl ?? ApiConstants.baseUrl {
    _dio = Dio(
      BaseOptions(
        baseUrl: _defaultBaseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    this.baseUrl = _defaultBaseUrl;

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _sharedPreferences.getString(AppConstants.tokenKey);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );

    _dio.interceptors.add(
      TalkerDioLogger(
        talker: talker,
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          printResponseMessage: true,
        ),
      ),
    );
  }

  void updateBaseUrl(String newBaseUrl) {
    baseUrl = newBaseUrl;
    _dio.options.baseUrl = newBaseUrl;
  }

  void resetToDefaultBaseUrl() {
    baseUrl = _defaultBaseUrl;
    _dio.options.baseUrl = _defaultBaseUrl;
  }

  /// Generic request method. Throws [ServerException] on any error.
  ///
  /// Usage in a datasource:
  /// ```dart
  /// final response = await apiClient.request(
  ///   path: '/api/v1/users',
  ///   method: HttpMethod.get,
  /// );
  /// return UserModel.fromJson(response.data);
  /// ```
  Future<Response> request({
    required String path,
    required HttpMethod method,
    dynamic data,
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    Response<dynamic> response;

    try {
      switch (method) {
        case HttpMethod.get:
          response = await _dio.get(path,
              data: data,
              options: options,
              queryParameters: queryParameters);
          break;
        case HttpMethod.post:
          response = await _dio.post(path,
              data: data,
              options: options,
              queryParameters: queryParameters);
          break;
        case HttpMethod.put:
          response = await _dio.put(path,
              data: data,
              options: options,
              queryParameters: queryParameters);
          break;
        case HttpMethod.patch:
          response = await _dio.patch(path,
              data: data,
              options: options,
              queryParameters: queryParameters);
          break;
        case HttpMethod.delete:
          response = await _dio.delete(path,
              data: data,
              options: options,
              queryParameters: queryParameters);
          break;
      }

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return response;
      } else {
        final message =
            response.data is Map && (response.data['message'] is String)
                ? response.data['message'] as String
                : 'Something went wrong';
        throw ServerException(
            message: message, statusCode: response.statusCode);
      }
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      debugPrint("error: ${e.toString()}");
      throw ServerException(message: e.toString());
    }
  }

  ServerException _handleDioError(DioException error) {
    String message = 'Something went wrong';

    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.unknown) {
      message = 'No internet connection. Please check your network.';
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      message = 'Request timed out. Please check your connection.';
    } else {
      final responseData = error.response?.data;
      if (responseData is Map && responseData['message'] is String) {
        message = responseData['message'];
      }
      if (responseData is Map && responseData['error'] is String) {
        message = responseData['error'];
      }
    }

    return ServerException(
      message: message,
      statusCode: error.response?.statusCode,
    );
  }
}
