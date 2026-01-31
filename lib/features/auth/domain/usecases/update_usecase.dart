import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/core/usecases/app_usecase.dart';
import 'package:fix_my_town/features/auth/data/repositories/user_repository.dart';
import 'package:fix_my_town/features/auth/domain/entities/user_entity.dart';
import 'package:fix_my_town/features/auth/domain/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateUsecaseParams extends Equatable {
  final String fullName;
  final String email;
  final String? currentPassword;
  final String? newPassword;
  final String? profilePicture;

  const UpdateUsecaseParams({
    required this.fullName,
    required this.email,
    this.currentPassword,
    this.newPassword,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [
    fullName,
    currentPassword,
    newPassword,
    profilePicture,
  ];
}

// provider
final updateUsecaseProvider = Provider<UpdateUsecase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return UpdateUsecase(userRepository: userRepository);
});

class UpdateUsecase implements UsecaseWithParams<bool, UpdateUsecaseParams> {
  final IUserRepository _authRepository;
  UpdateUsecase({required IUserRepository userRepository})
    : _authRepository = userRepository;

  @override
  Future<Either<Failure, bool>> call(UpdateUsecaseParams params) {
    final user = UserEntity(
      fullName: params.fullName,
      email: params.email,
      password: params.newPassword, // Use newPassword if provided
      profilePicture: params.profilePicture,
    );
    return _authRepository.update(user);
  }
}
