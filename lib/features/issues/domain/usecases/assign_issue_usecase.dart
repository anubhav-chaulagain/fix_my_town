// assign_issue_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fix_my_town/core/usecases/app_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/features/issues/data/repositories/issues_repository.dart';
import 'package:fix_my_town/features/issues/domain/repositories/issues_repository.dart';

class AssignIssueParams extends Equatable {
  final String issueId;
  final String assigneeId;

  const AssignIssueParams({required this.issueId, required this.assigneeId});

  @override
  List<Object?> get props => [issueId, assigneeId];
}

final assignIssueUsecaseProvider = Provider<AssignIssueUsecase>((ref) {
  return AssignIssueUsecase(
    issueRepository: ref.read(issuesRepositoryProvider),
  );
});

class AssignIssueUsecase implements UsecaseWithParams<bool, AssignIssueParams> {
  final IIssueRepository _issueRepository;

  AssignIssueUsecase({required IIssueRepository issueRepository})
    : _issueRepository = issueRepository;

  @override
  Future<Either<Failure, bool>> call(AssignIssueParams params) {
    return _issueRepository.assignIssue(params.issueId, params.assigneeId);
  }
}
