import 'package:dartz/dartz.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/features/category/domain/entities/category_entity.dart';
import 'package:fix_my_town/features/category/domain/repositories/category_repository.dart';
import 'package:fix_my_town/features/category/domain/usecases/create_category_usecase.dart';
import 'package:fix_my_town/features/category/domain/usecases/get_all_categories_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryRepository extends Mock implements ICategoryRepository {}

void main() {
  late MockCategoryRepository mockCategoryRepository;

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    registerFallbackValue(const CategoryEntity(name: ''));
  });

  // ── GetAllCategoriesUsecase ───────────────────────────────────────────────

  group("GetAllCategoriesUsecase", () {
    late GetAllCategoriesUsecase getAllCategoriesUsecase;

    setUp(() {
      getAllCategoriesUsecase = GetAllCategoriesUsecase(
        categoryRepository: mockCategoryRepository,
      );
    });

    test("success → returns list of categories from repository", () async {
      final fakeCategories = [
        const CategoryEntity(name: "Roads"),
        const CategoryEntity(name: "Water"),
      ];

      when(
        () => mockCategoryRepository.getAllCategories(),
      ).thenAnswer((_) async => Right(fakeCategories));

      final result = await getAllCategoriesUsecase();

      expect(result, Right(fakeCategories));
      verify(() => mockCategoryRepository.getAllCategories()).called(1);
    });

    test("failure → returns ApiFailure from repository", () async {
      when(() => mockCategoryRepository.getAllCategories()).thenAnswer(
        (_) async => Left(ApiFailure(message: "Failed to fetch categories")),
      );

      final result = await getAllCategoriesUsecase();

      expect(result, Left(ApiFailure(message: "Failed to fetch categories")));
      verify(() => mockCategoryRepository.getAllCategories()).called(1);
    });
  });

  // ── CreateCategoryUsecase ─────────────────────────────────────────────────

  group("CreateCategoryUsecase", () {
    late CreateCategoryUsecase createCategoryUsecase;

    setUp(() {
      createCategoryUsecase = CreateCategoryUsecase(
        categoryRepository: mockCategoryRepository,
      );
    });

    test(
      "success → calls repository with correct entity and returns true",
      () async {
        when(
          () => mockCategoryRepository.createCategory(any()),
        ).thenAnswer((_) async => const Right(true));

        final result = await createCategoryUsecase(
          CreateCategoryParams(
            name: "Electricity",
            description: "Power issues",
          ),
        );

        expect(result, const Right(true));
        verify(() => mockCategoryRepository.createCategory(any())).called(1);
      },
    );

    test("failure → returns ApiFailure from repository", () async {
      when(() => mockCategoryRepository.createCategory(any())).thenAnswer(
        (_) async => Left(ApiFailure(message: "Category already exists")),
      );

      final result = await createCategoryUsecase(
        CreateCategoryParams(name: "Electricity"),
      );

      expect(result, Left(ApiFailure(message: "Category already exists")));
      verify(() => mockCategoryRepository.createCategory(any())).called(1);
    });

    test("passes correct entity fields to repository", () async {
      CategoryEntity? capturedEntity;

      when(() => mockCategoryRepository.createCategory(any())).thenAnswer((
        invocation,
      ) async {
        capturedEntity = invocation.positionalArguments[0] as CategoryEntity;
        return const Right(true);
      });

      await createCategoryUsecase(
        CreateCategoryParams(name: "Electricity", description: "Power issues"),
      );

      expect(capturedEntity?.name, "Electricity");
      expect(capturedEntity?.description, "Power issues");
    });
  });
}
