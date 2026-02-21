import 'package:mine_wadhwani/data/models/auth/user_model.dart';

class AuthResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final UserModel user;
  final String token;

  const AuthResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.user,
    required this.token,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final token = data['token'] as String;
    final userData = data['user'] as Map<String, dynamic>;

    return AuthResponseModel(
      success: json['success'] as bool,
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      token: token,
      user: UserModel.fromJson(userData, token: token),
    );
  }
}
