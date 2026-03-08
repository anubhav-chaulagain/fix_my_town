import 'package:dartz/dartz.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/features/issues/domain/entities/issues_entity.dart';
import 'package:fix_my_town/features/issues/domain/usecases/assign_issue_usecase.dart';
import 'package:fix_my_town/features/issues/domain/usecases/create_issue_usecase.dart';
import 'package:fix_my_town/features/issues/domain/usecases/delete_issue_usecase.dart';
import 'package:fix_my_town/features/issues/domain/usecases/get_all_issues_usecase.dart';
import 'package:fix_my_town/features/issues/domain/usecases/get_issue_by_id_usecase.dart';
import 'package:fix_my_town/features/issues/domain/usecases/get_my_assigned_issues_usecase.dart';
import 'package:fix_my_town/features/issues/domain/usecases/get_my_recent_issues_usecase.dart';
import 'package:fix_my_town/features/issues/domain/usecases/get_user_issues_usecase.dart';
import 'package:fix_my_town/features/issues/domain/usecases/resolve_issue_usecase.dart';
import 'package:fix_my_town/features/issues/domain/usecases/update_issue_status_usecase.dart';
import 'package:fix_my_town/features/issues/domain/usecases/update_issue_usecase.dart';
import 'package:fix_my_town/features/issues/presentation/state/issues_state.dart';
import 'package:fix_my_town/features/issues/presentation/view_model/issues_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllIssuesUsecase extends Mock implements GetAllIssuesUsecase {}

class MockGetIssueByIdUsecase extends Mock implements GetIssueByIdUsecase {}

class MockGetUserIssuesUsecase extends Mock implements GetUserIssuesUsecase {}

class MockGetMyRecentIssuesUsecase extends Mock
    implements GetMyRecentIssuesUsecase {}

class MockGetMyAssignedIssuesUsecase extends Mock
    implements GetMyAssignedIssuesUsecase {}

class MockCreateIssueUsecase extends Mock implements CreateIssueUsecase {}

class MockUpdateIssueUsecase extends Mock implements UpdateIssueUsecase {}

class MockDeleteIssueUsecase extends Mock implements DeleteIssueUsecase {}

class MockUpdateIssueStatusUsecase extends Mock
    implements UpdateIssueStatusUsecase {}

class MockAssignIssueUsecase extends Mock implements AssignIssueUsecase {}

class MockResolveIssueUsecase extends Mock implements ResolveIssueUsecase {}

ProviderContainer makeIssuesContainer({
  required MockGetAllIssuesUsecase getAllIssuesUsecase,
  required MockGetIssueByIdUsecase getIssueByIdUsecase,
  required MockGetUserIssuesUsecase getUserIssuesUsecase,
  required MockGetMyRecentIssuesUsecase getMyRecentIssuesUsecase,
  required MockGetMyAssignedIssuesUsecase getMyAssignedIssuesUsecase,
  required MockCreateIssueUsecase createIssueUsecase,
  required MockUpdateIssueUsecase updateIssueUsecase,
  required MockDeleteIssueUsecase deleteIssueUsecase,
  required MockUpdateIssueStatusUsecase updateIssueStatusUsecase,
  required MockAssignIssueUsecase assignIssueUsecase,
  required MockResolveIssueUsecase resolveIssueUsecase,
}) {
  return ProviderContainer(
    overrides: [
      getAllIssuesUsecaseProvider.overrideWithValue(getAllIssuesUsecase),
      getIssueByIdUsecaseProvider.overrideWithValue(getIssueByIdUsecase),
      getUserIssuesUsecaseProvider.overrideWithValue(getUserIssuesUsecase),
      getMyRecentIssuesUsecaseProvider.overrideWithValue(
        getMyRecentIssuesUsecase,
      ),
      getMyAssignedIssuesUsecaseProvider.overrideWithValue(
        getMyAssignedIssuesUsecase,
      ),
      createIssueUsecaseProvider.overrideWithValue(createIssueUsecase),
      updateIssueUsecaseProvider.overrideWithValue(updateIssueUsecase),
      deleteIssueUsecaseProvider.overrideWithValue(deleteIssueUsecase),
      updateIssueStatusUsecaseProvider.overrideWithValue(
        updateIssueStatusUsecase,
      ),
      assignIssueUsecaseProvider.overrideWithValue(assignIssueUsecase),
      resolveIssueUsecaseProvider.overrideWithValue(resolveIssueUsecase),
    ],
  );
}

void main() {
  late MockGetAllIssuesUsecase mockGetAllIssuesUsecase;
  late MockGetIssueByIdUsecase mockGetIssueByIdUsecase;
  late MockGetUserIssuesUsecase mockGetUserIssuesUsecase;
  late MockGetMyRecentIssuesUsecase mockGetMyRecentIssuesUsecase;
  late MockGetMyAssignedIssuesUsecase mockGetMyAssignedIssuesUsecase;
  late MockCreateIssueUsecase mockCreateIssueUsecase;
  late MockUpdateIssueUsecase mockUpdateIssueUsecase;
  late MockDeleteIssueUsecase mockDeleteIssueUsecase;
  late MockUpdateIssueStatusUsecase mockUpdateIssueStatusUsecase;
  late MockAssignIssueUsecase mockAssignIssueUsecase;
  late MockResolveIssueUsecase mockResolveIssueUsecase;
  late ProviderContainer container;

  // ✅ all fields are optional — no required params
  final fakeIssues = [
    const IssuesEntity(issueId: "1", title: "Broken Road", status: "open"),
    const IssuesEntity(issueId: "2", title: "Water Leak", status: "open"),
  ];

  setUp(() {
    mockGetAllIssuesUsecase = MockGetAllIssuesUsecase();
    mockGetIssueByIdUsecase = MockGetIssueByIdUsecase();
    mockGetUserIssuesUsecase = MockGetUserIssuesUsecase();
    mockGetMyRecentIssuesUsecase = MockGetMyRecentIssuesUsecase();
    mockGetMyAssignedIssuesUsecase = MockGetMyAssignedIssuesUsecase();
    mockCreateIssueUsecase = MockCreateIssueUsecase();
    mockUpdateIssueUsecase = MockUpdateIssueUsecase();
    mockDeleteIssueUsecase = MockDeleteIssueUsecase();
    mockUpdateIssueStatusUsecase = MockUpdateIssueStatusUsecase();
    mockAssignIssueUsecase = MockAssignIssueUsecase();
    mockResolveIssueUsecase = MockResolveIssueUsecase();

    container = makeIssuesContainer(
      getAllIssuesUsecase: mockGetAllIssuesUsecase,
      getIssueByIdUsecase: mockGetIssueByIdUsecase,
      getUserIssuesUsecase: mockGetUserIssuesUsecase,
      getMyRecentIssuesUsecase: mockGetMyRecentIssuesUsecase,
      getMyAssignedIssuesUsecase: mockGetMyAssignedIssuesUsecase,
      createIssueUsecase: mockCreateIssueUsecase,
      updateIssueUsecase: mockUpdateIssueUsecase,
      deleteIssueUsecase: mockDeleteIssueUsecase,
      updateIssueStatusUsecase: mockUpdateIssueStatusUsecase,
      assignIssueUsecase: mockAssignIssueUsecase,
      resolveIssueUsecase: mockResolveIssueUsecase,
    );

    registerFallbackValue(GetIssueByIdParams(issueId: ''));
    registerFallbackValue(
      CreateIssueParams(
        title: '',
        category: '',
        location: '',
        latitude: '',
        longitude: '',
        description: '',
        priority: '',
        issueImages: [],
      ),
    );
    registerFallbackValue(
      UpdateIssueParams(
        issue: const IssuesEntity(), // ✅ all fields optional, empty is valid
        issueImages: [],
      ),
    );
    registerFallbackValue(DeleteIssueParams(issueId: ''));
    registerFallbackValue(UpdateIssueStatusParams(issueId: '', status: ''));
    registerFallbackValue(AssignIssueParams(issueId: '', assigneeId: ''));
    registerFallbackValue(ResolveIssueParams(issueId: ''));
  });

  tearDown(() => container.dispose());

  group("IssuesViewModel", () {
    test("getAllIssues success → state becomes loaded with issues", () async {
      when(
        () => mockGetAllIssuesUsecase.call(),
      ).thenAnswer((_) async => Right(fakeIssues));

      await container.read(issuesViewModelProvider.notifier).getAllIssues();

      final state = container.read(issuesViewModelProvider);
      expect(state.status, IssuesStatus.loaded);
      expect(state.issues, fakeIssues);
    });

    test("getAllIssues failure → state becomes error with message", () async {
      when(() => mockGetAllIssuesUsecase.call()).thenAnswer(
        (_) async => Left(ApiFailure(message: "Failed to fetch issues")),
      );

      await container.read(issuesViewModelProvider.notifier).getAllIssues();

      final state = container.read(issuesViewModelProvider);
      expect(state.status, IssuesStatus.error);
      expect(state.errorMessage, "Failed to fetch issues");
    });

    test("deleteIssue success → state becomes deleted", () async {
      when(
        () => mockDeleteIssueUsecase.call(any()),
      ).thenAnswer((_) async => const Right(true));
      when(
        () => mockGetAllIssuesUsecase.call(),
      ).thenAnswer((_) async => Right(fakeIssues));

      final statuses = <IssuesStatus>[];
      container.listen(
        issuesViewModelProvider.select((s) => s.status),
        (_, next) => statuses.add(next),
        fireImmediately: false,
      );

      await container.read(issuesViewModelProvider.notifier).deleteIssue("1");

      expect(statuses, contains(IssuesStatus.deleted));
    });

    test("deleteIssue failure → state becomes error with message", () async {
      when(() => mockDeleteIssueUsecase.call(any())).thenAnswer(
        (_) async => Left(ApiFailure(message: "Failed to delete issue")),
      );

      await container.read(issuesViewModelProvider.notifier).deleteIssue("1");

      final state = container.read(issuesViewModelProvider);
      expect(state.status, IssuesStatus.error);
      expect(state.errorMessage, "Failed to delete issue");
    });

    test("resolveIssue success → state becomes resolved", () async {
      when(
        () => mockResolveIssueUsecase.call(any()),
      ).thenAnswer((_) async => const Right(true));
      when(
        () => mockGetAllIssuesUsecase.call(),
      ).thenAnswer((_) async => Right(fakeIssues));

      final statuses = <IssuesStatus>[];
      container.listen(
        issuesViewModelProvider.select((s) => s.status),
        (_, next) => statuses.add(next),
        fireImmediately: false,
      );

      await container.read(issuesViewModelProvider.notifier).resolveIssue("1");

      expect(statuses, contains(IssuesStatus.resolved));
    });

    test("updateIssueStatus success → state becomes updated", () async {
      when(
        () => mockUpdateIssueStatusUsecase.call(any()),
      ).thenAnswer((_) async => const Right(true));
      when(
        () => mockGetAllIssuesUsecase.call(),
      ).thenAnswer((_) async => Right(fakeIssues));

      final statuses = <IssuesStatus>[];
      container.listen(
        issuesViewModelProvider.select((s) => s.status),
        (_, next) => statuses.add(next),
        fireImmediately: false,
      );

      await container
          .read(issuesViewModelProvider.notifier)
          .updateIssueStatus(issueId: "1", status: "in_progress");

      expect(statuses, contains(IssuesStatus.updated));
    });
  });
}
