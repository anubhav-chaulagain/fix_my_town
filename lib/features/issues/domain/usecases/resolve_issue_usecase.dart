import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fix_my_town/core/usecases/app_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/features/issues/data/repositories/issues_repository.dart';
import 'package:fix_my_town/features/issues/domain/repositories/issues_repository.dart';

class ResolveIssueParams extends Equatable {
  final String issueId;

  const ResolveIssueParams({required this.issueId});

  @override
  List<Object?> get props => [issueId];
}

final resolveIssueUsecaseProvider = Provider<ResolveIssueUsecase>((ref) {
  return ResolveIssueUsecase(
    issueRepository: ref.read(issuesRepositoryProvider),
  );
});

class ResolveIssueUsecase
    implements UsecaseWithParams<bool, ResolveIssueParams> {
  final IIssueRepository _issueRepository;

  ResolveIssueUsecase({required IIssueRepository issueRepository})
    : _issueRepository = issueRepository;

  @override
  Future<Either<Failure, bool>> call(ResolveIssueParams params) {
    return _issueRepository.resolveIssue(params.issueId);
  }
}
