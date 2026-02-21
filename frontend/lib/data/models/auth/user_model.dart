import 'package:mine_wadhwani/domain/entities/auth/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.mobilenumber,
    required super.avatar,
    required super.role,
    super.mineid,
    required super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {String? token}) {
    return UserModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      mobilenumber: json['mobilenumber'] as String,
      avatar: json['avatar'] as String? ?? 'default-avatar-url.jpg',
      role: json['role'] as String? ?? '',
      mineid: json['mineid'] as String?,
      token: token ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'mobilenumber': mobilenumber,
      'avatar': avatar,
      'role': role,
      'mineid': mineid,
      'token': token,
    };
  }
}
