// get_issue_by_id_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fix_my_town/core/usecases/app_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/features/issues/data/repositories/issues_repository.dart';
import 'package:fix_my_town/features/issues/domain/entities/issues_entity.dart';
import 'package:fix_my_town/features/issues/domain/repositories/issues_repository.dart';

class GetIssueByIdParams extends Equatable {
  final String issueId;

  const GetIssueByIdParams({required this.issueId});

  @override
  List<Object?> get props => [issueId];
}

final getIssueByIdUsecaseProvider = Provider<GetIssueByIdUsecase>((ref) {
  return GetIssueByIdUsecase(
    issueRepository: ref.read(issuesRepositoryProvider),
  );
});

class GetIssueByIdUsecase
    implements UsecaseWithParams<IssuesEntity, GetIssueByIdParams> {
  final IIssueRepository _issueRepository;

  GetIssueByIdUsecase({required IIssueRepository issueRepository})
    : _issueRepository = issueRepository;

  @override
  Future<Either<Failure, IssuesEntity>> call(GetIssueByIdParams params) {
    return _issueRepository.getIssueById(params.issueId);
  }
}
