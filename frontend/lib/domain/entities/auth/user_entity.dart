import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String mobilenumber;
  final String avatar;
  final String role;
  final String? mineid;
  final String token;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.mobilenumber,
    required this.avatar,
    required this.role,
    this.mineid,
    required this.token,
  });

  @override
  List<Object?> get props => [id, name, email, mobilenumber, avatar, role, mineid, token];
}
