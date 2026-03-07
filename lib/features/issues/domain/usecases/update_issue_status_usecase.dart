// update_issue_status_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fix_my_town/core/usecases/app_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/features/issues/data/repositories/issues_repository.dart';
import 'package:fix_my_town/features/issues/domain/repositories/issues_repository.dart';

class UpdateIssueStatusParams extends Equatable {
  final String issueId;
  final String status;

  const UpdateIssueStatusParams({required this.issueId, required this.status});

  @override
  List<Object?> get props => [issueId, status];
}

final updateIssueStatusUsecaseProvider = Provider<UpdateIssueStatusUsecase>((
  ref,
) {
  return UpdateIssueStatusUsecase(
    issueRepository: ref.read(issuesRepositoryProvider),
  );
});

class UpdateIssueStatusUsecase
    implements UsecaseWithParams<bool, UpdateIssueStatusParams> {
  final IIssueRepository _issueRepository;

  UpdateIssueStatusUsecase({required IIssueRepository issueRepository})
    : _issueRepository = issueRepository;

  @override
  Future<Either<Failure, bool>> call(UpdateIssueStatusParams params) {
    return _issueRepository.updateIssueStatus(params.issueId, params.status);
  }
}
