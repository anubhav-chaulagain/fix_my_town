import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String? fullname;
  final String email;
  final String password;
  final String? role;
  final String? profilePicture;

  const UserEntity({
    this.fullname,
    required this.email,
    required this.password,
    this.userId,
    this.role,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [email];
}
