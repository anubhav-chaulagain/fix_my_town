import 'package:equatable/equatable.dart';

enum UserRole { citizen, authority }

class UserEntity extends Equatable {
  final String? userId;
  final String fullName;
  final String email;
  final String? password;
  final UserRole role;
  final String? profilePicture;
  final String? status;

  const UserEntity({
    this.userId,
    required this.fullName,
    required this.email,
    this.password,
    required this.role,
    this.profilePicture,
    this.status,
  });

  @override
  List<Object?> get props => [userId, email, role];
}
