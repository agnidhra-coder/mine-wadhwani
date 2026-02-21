import 'dart:convert';

import 'package:mine_wadhwani/core/constants/app_constants.dart';
import 'package:mine_wadhwani/core/error/exceptions.dart';
import 'package:mine_wadhwani/data/models/auth/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
  Future<bool> hasToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheToken(String token) async {
    try {
      await sharedPreferences.setString(AppConstants.tokenKey, token);
    } catch (e) {
      throw CacheException(message: 'Failed to cache token');
    }
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(AppConstants.tokenKey);
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = json.encode(user.toJson());
      await sharedPreferences.setString(AppConstants.userKey, userJson);
    } catch (e) {
      throw CacheException(message: 'Failed to cache user');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final userString = sharedPreferences.getString(AppConstants.userKey);
    if (userString == null) return null;

    try {
      final userJson = json.decode(userString) as Map<String, dynamic>;
      return UserModel(
        id: userJson['_id'] as String,
        name: userJson['name'] as String,
        email: userJson['email'] as String,
        mobilenumber: userJson['mobilenumber'] as String,
        avatar: userJson['avatar'] as String? ?? 'default-avatar-url.jpg',
        role: userJson['role'] as String? ?? 'SUPERVISOR',
        mineid: userJson['mineid'] as String?,
        token: userJson['token'] as String? ?? '',
      );
    } catch (e) {
      throw CacheException(message: 'Failed to parse cached user');
    }
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(AppConstants.tokenKey);
    await sharedPreferences.remove(AppConstants.userKey);
  }

  @override
  Future<bool> hasToken() async {
    final token = sharedPreferences.getString(AppConstants.tokenKey);
    return token != null && token.isNotEmpty;
  }
}
