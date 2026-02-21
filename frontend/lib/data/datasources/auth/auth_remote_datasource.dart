import 'package:mine_wadhwani/core/constants/api_constants.dart';
import 'package:mine_wadhwani/core/error/exceptions.dart';
import 'package:mine_wadhwani/core/network/api_client.dart';
import 'package:mine_wadhwani/data/models/auth/auth_response_model.dart';
import 'package:mine_wadhwani/data/models/auth/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String mobilenumber,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.loginEndpoint,
        data: {'email': email, 'password': password},
      );

      final authResponse =
          AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
      return authResponse.user;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to login: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String mobilenumber,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.registerEndpoint,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'mobilenumber': mobilenumber,
        },
      );

      final authResponse =
          AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
      return authResponse.user;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to register: ${e.toString()}');
    }
  }
}
