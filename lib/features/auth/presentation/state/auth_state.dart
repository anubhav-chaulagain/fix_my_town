import 'package:equatable/equatable.dart';
import 'package:fix_my_town/features/auth/domain/entities/user_entity.dart';

enum AuthStatus { initial, loading, loaded, error, created, updated, deleted }

class AuthState extends Equatable {
  final AuthStatus status;
  final List<UserEntity> users;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.users = const [],
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    List<UserEntity>? users,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      users: users ?? this.users,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, users, errorMessage];
}
