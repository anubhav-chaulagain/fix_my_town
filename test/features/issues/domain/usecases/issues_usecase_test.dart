import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/features/issues/domain/entities/issues_entity.dart';
import 'package:fix_my_town/features/issues/domain/repositories/issues_repository.dart';
import 'package:fix_my_town/features/issues/domain/usecases/create_issue_usecase.dart';
import 'package:fix_my_town/features/issues/domain/usecases/get_all_issues_usecase.dart';
import 'package:fix_my_town/features/issues/domain/usecases/get_my_assigned_issues_usecase.dart';
import 'package:fix_my_town/features/issues/domain/usecases/update_issue_status_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIssueRepository extends Mock implements IIssueRepository {}

void main() {
  late MockIssueRepository mockIssueRepository;

  final fakeIssues = [
    const IssuesEntity(issueId: "1", title: "Broken Road", status: "open"),
    const IssuesEntity(issueId: "2", title: "Water Leak", status: "open"),
  ];

  setUp(() {
    mockIssueRepository = MockIssueRepository();
    registerFallbackValue(const IssuesEntity());
    registerFallbackValue(<File>[]);
  });

  // ── GetAllIssuesUsecase ───────────────────────────────────────────────────

  group("GetAllIssuesUsecase", () {
    late GetAllIssuesUsecase getAllIssuesUsecase;

    setUp(() {
      getAllIssuesUsecase = GetAllIssuesUsecase(
        issueRepository: mockIssueRepository,
      );
    });

    test("success → returns list of issues from repository", () async {
      when(
        () => mockIssueRepository.getAllIssues(),
      ).thenAnswer((_) async => Right(fakeIssues));

      final result = await getAllIssuesUsecase();

      expect(result, Right(fakeIssues));
      verify(() => mockIssueRepository.getAllIssues()).called(1);
    });

    test("failure → returns ApiFailure from repository", () async {
      when(() => mockIssueRepository.getAllIssues()).thenAnswer(
        (_) async => Left(ApiFailure(message: "Failed to fetch issues")),
      );

      final result = await getAllIssuesUsecase();

      expect(result, Left(ApiFailure(message: "Failed to fetch issues")));
    });
  });

  // ── CreateIssueUsecase ────────────────────────────────────────────────────

  group("CreateIssueUsecase", () {
    late CreateIssueUsecase createIssueUsecase;

    setUp(() {
      createIssueUsecase = CreateIssueUsecase(
        issueRepository: mockIssueRepository,
      );
    });

    test("success → calls repository and returns true", () async {
      when(
        () => mockIssueRepository.createIssue(any(), any()),
      ).thenAnswer((_) async => const Right(true));

      final result = await createIssueUsecase(
        CreateIssueParams(
          title: "Broken Road",
          category: "Roads",
          location: "Kathmandu",
          latitude: "27.7",
          longitude: "85.3",
          description: "Big pothole",
          priority: "high",
          issueImages: [],
        ),
      );

      expect(result, const Right(true));
      verify(() => mockIssueRepository.createIssue(any(), any())).called(1);
    });

    test("failure → returns ApiFailure from repository", () async {
      when(() => mockIssueRepository.createIssue(any(), any())).thenAnswer(
        (_) async => Left(ApiFailure(message: "Failed to create issue")),
      );

      final result = await createIssueUsecase(
        CreateIssueParams(
          title: "Broken Road",
          category: "Roads",
          location: "Kathmandu",
          latitude: "27.7",
          longitude: "85.3",
          description: "Big pothole",
          priority: "high",
          issueImages: [],
        ),
      );

      expect(result, Left(ApiFailure(message: "Failed to create issue")));
    });
  });

  // ── GetMyAssignedIssuesUsecase ────────────────────────────────────────────

  group("GetMyAssignedIssuesUsecase", () {
    late GetMyAssignedIssuesUsecase getMyAssignedIssuesUsecase;

    setUp(() {
      getMyAssignedIssuesUsecase = GetMyAssignedIssuesUsecase(
        issueRepository: mockIssueRepository,
      );
    });

    test("success → returns list of assigned issues from repository", () async {
      when(
        () => mockIssueRepository.getMyAssignedIssues(),
      ).thenAnswer((_) async => Right(fakeIssues));

      final result = await getMyAssignedIssuesUsecase();

      expect(result, Right(fakeIssues));
      verify(() => mockIssueRepository.getMyAssignedIssues()).called(1);
    });

    test("failure → returns ApiFailure from repository", () async {
      when(() => mockIssueRepository.getMyAssignedIssues()).thenAnswer(
        (_) async =>
            Left(ApiFailure(message: "Failed to fetch assigned issues")),
      );

      final result = await getMyAssignedIssuesUsecase();

      expect(
        result,
        Left(ApiFailure(message: "Failed to fetch assigned issues")),
      );
    });
  });

  // ── UpdateIssueStatusUsecase ──────────────────────────────────────────────

  group("UpdateIssueStatusUsecase", () {
    late UpdateIssueStatusUsecase updateIssueStatusUsecase;

    setUp(() {
      updateIssueStatusUsecase = UpdateIssueStatusUsecase(
        issueRepository: mockIssueRepository,
      );
    });

    test(
      "success → calls repository with correct params and returns true",
      () async {
        when(
          () => mockIssueRepository.updateIssueStatus(any(), any()),
        ).thenAnswer((_) async => const Right(true));

        final result = await updateIssueStatusUsecase(
          UpdateIssueStatusParams(issueId: "1", status: "in_progress"),
        );

        expect(result, const Right(true));
        verify(
          () => mockIssueRepository.updateIssueStatus("1", "in_progress"),
        ).called(1);
      },
    );

    test("failure → returns ApiFailure from repository", () async {
      when(
        () => mockIssueRepository.updateIssueStatus(any(), any()),
      ).thenAnswer(
        (_) async => Left(ApiFailure(message: "Failed to update status")),
      );

      final result = await updateIssueStatusUsecase(
        UpdateIssueStatusParams(issueId: "1", status: "in_progress"),
      );

      expect(result, Left(ApiFailure(message: "Failed to update status")));
    });
  });
}
