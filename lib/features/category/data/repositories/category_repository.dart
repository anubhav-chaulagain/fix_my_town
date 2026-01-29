import 'package:dartz/dartz.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/features/category/data/datasources/category_datasource.dart';
import 'package:fix_my_town/features/category/data/models/category_hive_model.dart';
import 'package:fix_my_town/features/category/domain/entities/category_entity.dart';
import 'package:fix_my_town/features/category/domain/repositories/category_repository.dart';

class CategoryRepository implements ICategoryRepository {
  final ICategoryDatasource _categoryDatasource;

  CategoryRepository({required ICategoryDatasource categoryDatasource})
    : _categoryDatasource = categoryDatasource;

  @override
  Future<Either<Failure, bool>> createCategory(CategoryEntity category) async {
    try {
      final categoryModel = CategoryHiveModel.fromEntity(category);
      final result = await _categoryDatasource.createCategory(categoryModel);
      if (result) {
        return const Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: "Failed to create category"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteCategory(String categoryId) async {
    try {
      final result = await _categoryDatasource.deleteCategory(categoryId);
      if (result) {
        return const Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: "Failed to delete category"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
    try {
      final models = await _categoryDatasource.getAllCategories();
      final entities = CategoryHiveModel.toEntityList(models);
      return Right(entities);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(
    String categoryId,
  ) async {
    try {
      final model = await _categoryDatasource.getCategoryById(categoryId);
      if (model != null) {
        final entity = model.toEntity();
        return Right(entity);
      }
      return const Left(LocalDatabaseFailure(message: 'Category not found'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateCategory(CategoryEntity category) async {
    try {
      final categoryModel = CategoryHiveModel.fromEntity(category);
      final result = await _categoryDatasource.updateCategory(categoryModel);
      if (result) {
        return const Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: "Failed to update category"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
