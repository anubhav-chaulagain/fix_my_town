import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/core/usecases/app_usecase.dart';
import 'package:fix_my_town/features/auth/data/repositories/user_repository.dart';
import 'package:fix_my_town/features/auth/domain/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final uploadPhotoUsecaseProvider = Provider<UploadPhotoUsecase>((ref) {
  return UploadPhotoUsecase(repository: ref.read(userRepositoryProvider));
});

class UploadPhotoUsecase implements UsecaseWithParams<String, File> {
  final IUserRepository _authRepository;
  UploadPhotoUsecase({required IUserRepository repository})
    : _authRepository = repository;

  @override
  Future<Either<Failure, String>> call(File photo) {
    return _authRepository.uploadPhoto(photo);
  }
}
