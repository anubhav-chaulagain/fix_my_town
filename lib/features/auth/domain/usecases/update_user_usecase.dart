import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/core/usecases/app_usecase.dart';
import 'package:fix_my_town/features/auth/domain/entities/user_entity.dart';
import 'package:fix_my_town/features/auth/domain/repositories/user_repository.dart';
import 'package:uuid/uuid.dart';

class UpdateUserUsecaseParams extends Equatable {
  final String userId;
  final String fullname;
  final String email;
  final String password;
  final UserRole? role;
  final String? profilePicture;
  final String? status;

  const UpdateUserUsecaseParams({
    required this.email,
    required this.password,
    required this.fullname,
    required this.role,
    required this.userId,
    this.profilePicture,
    this.status,
  });
  @override
  List<Object?> get props => [
    userId,
    fullname,
    email,
    password,
    role,
    profilePicture,
    status,
  ];
}

class UpdateUserUsecase
    implements UsecaseWithParams<void, UpdateUserUsecaseParams> {
  final IUserRepository _userRepository;
  UpdateUserUsecase(this._userRepository);
  @override
  Future<Either<Failure, void>> call(UpdateUserUsecaseParams params) {
    final user = UserEntity(
      fullName: params.fullname,
      email: params.email,
      password: params.password,
      profilePicture: params.profilePicture,
      status: params.status,
      role: params.role ?? UserRole.citizen,
    );
    return _userRepository.createUser(user);
  }
}
