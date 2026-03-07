// issues_view_model.dart
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

final issuesViewModelProvider = NotifierProvider<IssuesViewModel, IssuesState>(
  IssuesViewModel.new,
);

class IssuesViewModel extends Notifier<IssuesState> {
  late final GetAllIssuesUsecase _getAllIssuesUsecase;
  late final GetIssueByIdUsecase _getIssueByIdUsecase;
  late final GetUserIssuesUsecase _getUserIssuesUsecase;
  late final GetMyRecentIssuesUsecase _getMyRecentIssuesUsecase;
  late final GetMyAssignedIssuesUsecase _getMyAssignedIssuesUsecase;
  late final CreateIssueUsecase _createIssueUsecase;
  late final UpdateIssueUsecase _updateIssueUsecase;
  late final DeleteIssueUsecase _deleteIssueUsecase;
  late final UpdateIssueStatusUsecase _updateIssueStatusUsecase;
  late final AssignIssueUsecase _assignIssueUsecase;
  late final ResolveIssueUsecase _resolveIssueUsecase;

  @override
  IssuesState build() {
    _getAllIssuesUsecase = ref.read(getAllIssuesUsecaseProvider);
    _getIssueByIdUsecase = ref.read(getIssueByIdUsecaseProvider);
    _getUserIssuesUsecase = ref.read(getUserIssuesUsecaseProvider);
    _getMyRecentIssuesUsecase = ref.read(getMyRecentIssuesUsecaseProvider);
    _getMyAssignedIssuesUsecase = ref.read(getMyAssignedIssuesUsecaseProvider);
    _createIssueUsecase = ref.read(createIssueUsecaseProvider);
    _updateIssueUsecase = ref.read(updateIssueUsecaseProvider);
    _deleteIssueUsecase = ref.read(deleteIssueUsecaseProvider);
    _updateIssueStatusUsecase = ref.read(updateIssueStatusUsecaseProvider);
    _assignIssueUsecase = ref.read(assignIssueUsecaseProvider);
    _resolveIssueUsecase = ref.read(resolveIssueUsecaseProvider);
    return const IssuesState();
  }

  // ── READ ─────────────────────────────────────────────────────────────────

  Future<void> getAllIssues() async {
    state = state.copyWith(status: IssuesStatus.loading);

    final result = await _getAllIssuesUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: IssuesStatus.error,
        errorMessage: failure.message,
      ),
      (issues) =>
          state = state.copyWith(status: IssuesStatus.loaded, issues: issues),
    );
  }

  Future<void> getIssueById(String issueId) async {
    state = state.copyWith(status: IssuesStatus.loading);

    final result = await _getIssueByIdUsecase(
      GetIssueByIdParams(issueId: issueId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: IssuesStatus.error,
        errorMessage: failure.message,
      ),
      (issue) => state = state.copyWith(
        status: IssuesStatus.loaded,
        selectedIssue: issue,
      ),
    );
  }

  Future<void> getUserIssues() async {
    state = state.copyWith(status: IssuesStatus.loading);

    final result = await _getUserIssuesUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: IssuesStatus.error,
        errorMessage: failure.message,
      ),
      (issues) => state = state.copyWith(
        status: IssuesStatus.loaded,
        userIssues: issues,
      ),
    );
  }

  Future<void> getMyRecentIssues() async {
    state = state.copyWith(status: IssuesStatus.loading);

    final result = await _getMyRecentIssuesUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: IssuesStatus.error,
        errorMessage: failure.message,
      ),
      (issues) => state = state.copyWith(
        status: IssuesStatus.loaded,
        recentIssues: issues,
      ),
    );
  }

  Future<void> getMyAssignedIssues() async {
    state = state.copyWith(status: IssuesStatus.loading);

    final result = await _getMyAssignedIssuesUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: IssuesStatus.error,
        errorMessage: failure.message,
      ),
      (issues) => state = state.copyWith(
        status: IssuesStatus.loaded,
        assignedIssues: issues,
      ),
    );
  }

  // ── CREATE ───────────────────────────────────────────────────────────────

  Future<void> createIssue({
    required String title,
    required String category,
    required String location,
    required String latitude,
    required String longitude,
    required String description,
    required String priority,
    required List<File> issueImages,
  }) async {
    state = state.copyWith(status: IssuesStatus.loading);

    final result = await _createIssueUsecase(
      CreateIssueParams(
        title: title,
        category: category,
        location: location,
        latitude: latitude,
        longitude: longitude,
        description: description,
        priority: priority,
        issueImages: issueImages,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: IssuesStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(status: IssuesStatus.created);
        getAllIssues();
      },
    );
  }

  // ── UPDATE ───────────────────────────────────────────────────────────────

  Future<void> updateIssue({
    required IssuesEntity issue,
    required List<File> issueImages,
  }) async {
    state = state.copyWith(status: IssuesStatus.loading);

    final result = await _updateIssueUsecase(
      UpdateIssueParams(issue: issue, issueImages: issueImages),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: IssuesStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(status: IssuesStatus.updated);
        getAllIssues();
      },
    );
  }

  Future<void> updateIssueStatus({
    required String issueId,
    required String status,
  }) async {
    state = state.copyWith(status: IssuesStatus.loading);

    final result = await _updateIssueStatusUsecase(
      UpdateIssueStatusParams(issueId: issueId, status: status),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: IssuesStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(status: IssuesStatus.updated);
        getAllIssues();
      },
    );
  }

  Future<void> assignIssue({
    required String issueId,
    required String assigneeId,
  }) async {
    state = state.copyWith(status: IssuesStatus.loading);

    final result = await _assignIssueUsecase(
      AssignIssueParams(issueId: issueId, assigneeId: assigneeId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: IssuesStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(status: IssuesStatus.assigned);
        getAllIssues();
      },
    );
  }

  Future<void> resolveIssue(String issueId) async {
    state = state.copyWith(status: IssuesStatus.loading);

    final result = await _resolveIssueUsecase(
      ResolveIssueParams(issueId: issueId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: IssuesStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(status: IssuesStatus.resolved);
        getAllIssues();
      },
    );
  }

  // ── DELETE ───────────────────────────────────────────────────────────────

  Future<void> deleteIssue(String issueId) async {
    state = state.copyWith(status: IssuesStatus.loading);

    final result = await _deleteIssueUsecase(
      DeleteIssueParams(issueId: issueId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: IssuesStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(status: IssuesStatus.deleted);
        getAllIssues();
      },
    );
  }

  // ── HELPERS ───────────────────────────────────────────────────────────────

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void clearSelectedIssue() {
    state = state.copyWith(selectedIssue: null);
  }
}
