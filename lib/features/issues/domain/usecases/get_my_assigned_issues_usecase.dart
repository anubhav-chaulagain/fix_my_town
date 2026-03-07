// get_my_assigned_issues_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:fix_my_town/core/usecases/app_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/features/issues/data/repositories/issues_repository.dart';
import 'package:fix_my_town/features/issues/domain/entities/issues_entity.dart';
import 'package:fix_my_town/features/issues/domain/repositories/issues_repository.dart';

final getMyAssignedIssuesUsecaseProvider = Provider<GetMyAssignedIssuesUsecase>(
  (ref) {
    return GetMyAssignedIssuesUsecase(
      issueRepository: ref.read(issuesRepositoryProvider),
    );
  },
);

class GetMyAssignedIssuesUsecase
    implements UsecaseWithoutParams<List<IssuesEntity>> {
  final IIssueRepository _issueRepository;

  GetMyAssignedIssuesUsecase({required IIssueRepository issueRepository})
    : _issueRepository = issueRepository;

  @override
  Future<Either<Failure, List<IssuesEntity>>> call() {
    return _issueRepository.getMyAssignedIssues();
  }
}
