import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/core/usecases/app_usecase.dart';
import 'package:fix_my_town/features/auth/domain/entities/user_entity.dart';
import 'package:fix_my_town/features/auth/domain/repositories/user_repository.dart';
import 'package:uuid/uuid.dart';

class CreateUserUsecaseParams extends Equatable {
  final String fullname;
  final String email;
  final String password;
  final UserRole role;

  const CreateUserUsecaseParams({
    required this.email,
    required this.password,
    required this.fullname,
    required this.role,
  });
  @override
  List<Object?> get props => [fullname, email, password, role];
}

class CreateUserUsecase
    implements UsecaseWithParams<void, CreateUserUsecaseParams> {
  final IUserRepository _userRepository;
  CreateUserUsecase(this._userRepository);
  static const _uuid = Uuid();
  @override
  Future<Either<Failure, void>> call(CreateUserUsecaseParams params) {
    final user = UserEntity(
      userId: _uuid.v4(),
      fullName: params.fullname,
      email: params.email,
      password: params.password,
      role: params.role,
    );
    return _userRepository.createUser(user);
  }
}
