import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/core/usecases/app_usecase.dart';
import 'package:fix_my_town/features/auth/data/models/user_hive_model.dart';
import 'package:fix_my_town/features/auth/data/repositories/user_repository.dart';
import 'package:fix_my_town/features/auth/domain/entities/user_entity.dart';
import 'package:fix_my_town/features/auth/domain/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginUsecaseParams extends Equatable {
  final String email;
  final String password;

  const LoginUsecaseParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  return LoginUsecase(repository: ref.read(userRepositoryProvider));
});

class LoginUsecase
    implements UsecaseWithParams<UserEntity, LoginUsecaseParams> {
  final IUserRepository _authRepository;
  LoginUsecase({required IUserRepository repository})
    : _authRepository = repository;

  @override
  Future<Either<Failure, UserEntity>> call(LoginUsecaseParams params) {
    return _authRepository.login(params.email, params.password);
  }
}
