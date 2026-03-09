import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fix_my_town/core/usecases/app_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/features/issues/data/repositories/issues_repository.dart';
import 'package:fix_my_town/features/issues/domain/repositories/issues_repository.dart';

class DeleteIssueParams extends Equatable {
  final String issueId;

  const DeleteIssueParams({required this.issueId});

  @override
  List<Object?> get props => [issueId];
}

final deleteIssueUsecaseProvider = Provider<DeleteIssueUsecase>((ref) {
  return DeleteIssueUsecase(
    issueRepository: ref.read(issuesRepositoryProvider),
  );
});

class DeleteIssueUsecase implements UsecaseWithParams<bool, DeleteIssueParams> {
  final IIssueRepository _issueRepository;

  DeleteIssueUsecase({required IIssueRepository issueRepository})
    : _issueRepository = issueRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteIssueParams params) {
    return _issueRepository.deleteIssue(params.issueId);
  }
}
