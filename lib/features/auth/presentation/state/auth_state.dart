import 'package:equatable/equatable.dart';
import 'package:fix_my_town/features/auth/domain/entities/user_entity.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  registered,
  error,
  loaded,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? userEntity;
  final String? errorMessage;
  final String? uploadedPhotoUrl;

  const AuthState({
    this.status = AuthStatus.initial,
    this.userEntity,
    this.errorMessage,
    this.uploadedPhotoUrl,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? userEntity,
    String? errorMessage,
    String? uploadedPhotoUrl,
    bool resetUploadedPhotoUrl = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      userEntity: userEntity ?? this.userEntity,
      errorMessage: errorMessage,
      uploadedPhotoUrl: resetUploadedPhotoUrl
          ? null
          : (uploadedPhotoUrl ?? this.uploadedPhotoUrl),
    );
  }

  @override
  List<Object?> get props => [status, userEntity, errorMessage];
}
