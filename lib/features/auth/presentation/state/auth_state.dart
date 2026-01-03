import 'package:equatable/equatable.dart';
import 'package:fix_my_town/features/auth/domain/entities/user_entity.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  registered,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? userEntity;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.userEntity,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? userEntity,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      userEntity: userEntity ?? this.userEntity,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, userEntity, errorMessage];
}
