import 'package:dartz/dartz.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/core/usecases/app_usecase.dart';
import 'package:fix_my_town/features/category/data/repositories/category_repository.dart';
import 'package:fix_my_town/features/category/domain/entities/category_entity.dart';
import 'package:fix_my_town/features/category/domain/repositories/category_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllCategoriesUsecaseProvider = Provider<GetAllCategoriesUsecase>((
  ref,
) {
  final categoryRepository = ref.read(categoryRepositoryProvider);
  return GetAllCategoriesUsecase(categoryRepository: categoryRepository);
});

class GetAllCategoriesUsecase
    implements UsecaseWithoutParams<List<CategoryEntity>> {
  final ICategoryRepository _categoryRepository;

  GetAllCategoriesUsecase({required ICategoryRepository categoryRepository})
    : _categoryRepository = categoryRepository;

  @override
  Future<Either<Failure, List<CategoryEntity>>> call() {
    return _categoryRepository.getAllCategories();
  }
}
