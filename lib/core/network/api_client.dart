import 'package:dio/dio.dart';
import 'package:mine_wadhwani/core/constants/api_constants.dart';
import 'package:mine_wadhwani/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mine_wadhwani/core/constants/app_constants.dart';

class ApiClient {
  late final Dio _dio;
  final SharedPreferences _sharedPreferences;

  ApiClient({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {'Content-Type': 'application/json'},
      ),
    );

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
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
  }) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ServerException _handleError(DioException error) {
    final response = error.response;
    if (response != null && response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      return ServerException(
        message: data['message'] as String? ?? 'Something went wrong',
        statusCode: response.statusCode,
      );
    }
    return ServerException(
      message: error.message ?? 'Network error occurred',
      statusCode: error.response?.statusCode,
    );
  }
}
