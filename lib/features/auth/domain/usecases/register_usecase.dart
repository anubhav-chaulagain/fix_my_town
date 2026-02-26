import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/core/usecases/app_usecase.dart';
import 'package:fix_my_town/features/auth/data/repositories/user_repository.dart';
import 'package:fix_my_town/features/auth/domain/entities/user_entity.dart';
import 'package:fix_my_town/features/auth/domain/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterUsecaseParams extends Equatable {
  final String fullName;
  final String email;
  final String password;
  final String role;

  const RegisterUsecaseParams({
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
  });

  @override
  List<Object?> get props => [fullName, email, password, role];
}

final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  return RegisterUsecase(repository: ref.read(userRepositoryProvider));
});

class RegisterUsecase
    implements UsecaseWithParams<bool, RegisterUsecaseParams> {
  final IUserRepository _authRepository;
  RegisterUsecase({required IUserRepository repository})
    : _authRepository = repository;
  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) {
    final user = UserEntity(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
      role: params.role,
    );
    return _authRepository.register(user);
  }
}
