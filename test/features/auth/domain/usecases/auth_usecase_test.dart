import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/features/auth/domain/entities/user_entity.dart';
import 'package:fix_my_town/features/auth/domain/repositories/user_repository.dart';
import 'package:fix_my_town/features/auth/domain/usecases/login_usecase.dart';
import 'package:fix_my_town/features/auth/domain/usecases/register_usecase.dart';
import 'package:fix_my_town/features/auth/domain/usecases/upload_photo_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    registerFallbackValue(UserEntity(fullName: '', email: ''));
    registerFallbackValue(File(''));
  });

  // ── LoginUsecase ──────────────────────────────────────────────────────────

  group("LoginUsecase", () {
    late LoginUsecase loginUsecase;

    setUp(() {
      loginUsecase = LoginUsecase(repository: mockUserRepository);
    });

    test("success → returns UserEntity from repository", () async {
      final fakeUser = UserEntity(
        fullName: "Anubhav Chaulagain",
        email: "ac@gmail.com",
      );

      when(
        () => mockUserRepository.login(any(), any()),
      ).thenAnswer((_) async => Right(fakeUser));

      final result = await loginUsecase(
        LoginUsecaseParams(email: "ac@gmail.com", password: "pass123"),
      );

      expect(result, Right(fakeUser));
      verify(
        () => mockUserRepository.login("ac@gmail.com", "pass123"),
      ).called(1);
    });

    test("failure → returns ApiFailure from repository", () async {
      when(() => mockUserRepository.login(any(), any())).thenAnswer(
        (_) async => Left(ApiFailure(message: "Invalid credentials")),
      );

      final result = await loginUsecase(
        LoginUsecaseParams(email: "wrong@gmail.com", password: "wrong"),
      );

      expect(result, Left(ApiFailure(message: "Invalid credentials")));
    });
  });

  // ── LogoutUsecase ─────────────────────────────────────────────────────────

  group("LoginUsecase params", () {
    late LoginUsecase loginUsecase;

    setUp(() {
      loginUsecase = LoginUsecase(repository: mockUserRepository);
    });

    test("passes correct email and password to repository", () async {
      when(
        () => mockUserRepository.login(any(), any()),
      ).thenAnswer((_) async => Left(ApiFailure(message: "error")));

      await loginUsecase(
        LoginUsecaseParams(email: "ac@gmail.com", password: "pass123"),
      );

      verify(
        () => mockUserRepository.login("ac@gmail.com", "pass123"),
      ).called(1);
    });
  });

  // ── RegisterUsecase ───────────────────────────────────────────────────────

  group("RegisterUsecase", () {
    late RegisterUsecase registerUsecase;

    setUp(() {
      registerUsecase = RegisterUsecase(repository: mockUserRepository);
    });

    test("success → returns true from repository", () async {
      when(
        () => mockUserRepository.register(any()),
      ).thenAnswer((_) async => const Right(true));

      final result = await registerUsecase(
        RegisterUsecaseParams(
          fullName: "Anubhav Chaulagain",
          email: "ac@gmail.com",
          password: "pass123",
          role: "user",
        ),
      );

      expect(result, const Right(true));
      verify(() => mockUserRepository.register(any())).called(1);
    });

    test("failure → returns ApiFailure from repository", () async {
      when(() => mockUserRepository.register(any())).thenAnswer(
        (_) async => Left(ApiFailure(message: "Email already exists")),
      );

      final result = await registerUsecase(
        RegisterUsecaseParams(
          fullName: "Anubhav",
          email: "ac@gmail.com",
          password: "pass123",
          role: "user",
        ),
      );

      expect(result, Left(ApiFailure(message: "Email already exists")));
    });
  });

  // ── UploadPhotoUsecase ────────────────────────────────────────────────────

  group("UploadPhotoUsecase", () {
    late UploadPhotoUsecase uploadPhotoUsecase;

    setUp(() {
      uploadPhotoUsecase = UploadPhotoUsecase(repository: mockUserRepository);
    });

    test("success → returns photo url from repository", () async {
      final fakePhoto = File("fake_path.jpg");

      when(
        () => mockUserRepository.uploadPhoto(any()),
      ).thenAnswer((_) async => const Right("https://example.com/photo.jpg"));

      final result = await uploadPhotoUsecase(fakePhoto);

      expect(result, const Right("https://example.com/photo.jpg"));
      verify(() => mockUserRepository.uploadPhoto(any())).called(1);
    });

    test("failure → returns ApiFailure from repository", () async {
      final fakePhoto = File("fake_path.jpg");

      when(
        () => mockUserRepository.uploadPhoto(any()),
      ).thenAnswer((_) async => Left(ApiFailure(message: "Upload failed")));

      final result = await uploadPhotoUsecase(fakePhoto);

      expect(result, Left(ApiFailure(message: "Upload failed")));
    });
  });
}
