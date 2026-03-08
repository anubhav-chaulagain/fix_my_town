import 'package:dartz/dartz.dart';
import 'package:fix_my_town/core/error/failures.dart';
import 'package:fix_my_town/features/category/domain/entities/category_entity.dart';
import 'package:fix_my_town/features/category/domain/usecases/create_category_usecase.dart';
import 'package:fix_my_town/features/category/domain/usecases/delete_category_usecase.dart';
import 'package:fix_my_town/features/category/domain/usecases/get_all_categories_usecase.dart';
import 'package:fix_my_town/features/category/domain/usecases/get_category_by_id_usecase.dart';
import 'package:fix_my_town/features/category/domain/usecases/update_category_usecase.dart';
import 'package:fix_my_town/features/category/presentation/state/category_state.dart';
import 'package:fix_my_town/features/category/presentation/view_model/category_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllCategoriesUsecase extends Mock
    implements GetAllCategoriesUsecase {}

class MockGetCategoryByIdUsecase extends Mock
    implements GetCategoryByIdUsecase {}

class MockCreateCategoryUsecase extends Mock implements CreateCategoryUsecase {}

class MockUpdateCategoryUsecase extends Mock implements UpdateCategoryUsecase {}

class MockDeleteCategoryUsecase extends Mock implements DeleteCategoryUsecase {}

ProviderContainer makeCategoryContainer({
  required MockGetAllCategoriesUsecase getAllCategoriesUsecase,
  required MockGetCategoryByIdUsecase getCategoryByIdUsecase,
  required MockCreateCategoryUsecase createCategoryUsecase,
  required MockUpdateCategoryUsecase updateCategoryUsecase,
  required MockDeleteCategoryUsecase deleteCategoryUsecase,
}) {
  return ProviderContainer(
    overrides: [
      getAllCategoriesUsecaseProvider.overrideWithValue(
        getAllCategoriesUsecase,
      ),
      getCategoryByIdUsecaseProvider.overrideWithValue(getCategoryByIdUsecase),
      createCategoryUsecaseProvider.overrideWithValue(createCategoryUsecase),
      updateCategoryUsecaseProvider.overrideWithValue(updateCategoryUsecase),
      deleteCategoryUsecaseProvider.overrideWithValue(deleteCategoryUsecase),
    ],
  );
}

void main() {
  late MockGetAllCategoriesUsecase mockGetAllCategoriesUsecase;
  late MockGetCategoryByIdUsecase mockGetCategoryByIdUsecase;
  late MockCreateCategoryUsecase mockCreateCategoryUsecase;
  late MockUpdateCategoryUsecase mockUpdateCategoryUsecase;
  late MockDeleteCategoryUsecase mockDeleteCategoryUsecase;
  late ProviderContainer container;

  // ✅ using correct constructor — only 'name' is required
  final fakeCategories = [
    const CategoryEntity(name: "Roads", description: "Road issues"),
    const CategoryEntity(name: "Water", description: "Water issues"),
  ];

  setUp(() {
    mockGetAllCategoriesUsecase = MockGetAllCategoriesUsecase();
    mockGetCategoryByIdUsecase = MockGetCategoryByIdUsecase();
    mockCreateCategoryUsecase = MockCreateCategoryUsecase();
    mockUpdateCategoryUsecase = MockUpdateCategoryUsecase();
    mockDeleteCategoryUsecase = MockDeleteCategoryUsecase();

    container = makeCategoryContainer(
      getAllCategoriesUsecase: mockGetAllCategoriesUsecase,
      getCategoryByIdUsecase: mockGetCategoryByIdUsecase,
      createCategoryUsecase: mockCreateCategoryUsecase,
      updateCategoryUsecase: mockUpdateCategoryUsecase,
      deleteCategoryUsecase: mockDeleteCategoryUsecase,
    );

    registerFallbackValue(GetCategoryByIdParams(categoryId: ''));
    registerFallbackValue(CreateCategoryParams(name: ''));
    registerFallbackValue(UpdateCategoryParams(categoryId: '', name: ''));
    registerFallbackValue(DeleteCategoryParams(categoryId: ''));
  });

  tearDown(() => container.dispose());

  group("CategoryViewmodel", () {
    test(
      "getAllCategories success → state becomes loaded with categories",
      () async {
        when(
          () => mockGetAllCategoriesUsecase.call(),
        ).thenAnswer((_) async => Right(fakeCategories));

        await container
            .read(categoryViewmodelProvider.notifier)
            .getAllCategories();

        final state = container.read(categoryViewmodelProvider);
        expect(state.status, CategoryStatus.loaded);
        expect(state.categories, fakeCategories);
      },
    );

    test(
      "getAllCategories failure → state becomes error with message",
      () async {
        when(() => mockGetAllCategoriesUsecase.call()).thenAnswer(
          (_) async => Left(ApiFailure(message: "Failed to fetch categories")),
        );

        await container
            .read(categoryViewmodelProvider.notifier)
            .getAllCategories();

        final state = container.read(categoryViewmodelProvider);
        expect(state.status, CategoryStatus.error);
        expect(state.errorMessage, "Failed to fetch categories");
      },
    );

    test("createCategory success → state becomes created", () async {
      when(
        () => mockCreateCategoryUsecase.call(any()),
      ).thenAnswer((_) async => const Right(true));
      when(
        () => mockGetAllCategoriesUsecase.call(),
      ).thenAnswer((_) async => Right(fakeCategories));

      // ✅ collect every status transition
      final statuses = <CategoryStatus>[];
      container.listen(
        categoryViewmodelProvider.select((s) => s.status),
        (_, next) => statuses.add(next),
        fireImmediately: false,
      );

      await container
          .read(categoryViewmodelProvider.notifier)
          .createCategory(name: "Electricity");

      // ✅ assert 'created' appeared somewhere in the transitions
      expect(statuses, contains(CategoryStatus.created));
    });

    test("createCategory failure → state becomes error with message", () async {
      when(() => mockCreateCategoryUsecase.call(any())).thenAnswer(
        (_) async => Left(ApiFailure(message: "Category already exists")),
      );

      await container
          .read(categoryViewmodelProvider.notifier)
          .createCategory(name: "Electricity");

      final state = container.read(categoryViewmodelProvider);
      expect(state.status, CategoryStatus.error);
      expect(state.errorMessage, "Category already exists");
    });

    test("deleteCategory success → state becomes deleted", () async {
      when(
        () => mockDeleteCategoryUsecase.call(any()),
      ).thenAnswer((_) async => const Right(true));
      when(
        () => mockGetAllCategoriesUsecase.call(),
      ).thenAnswer((_) async => Right(fakeCategories));

      final statuses = <CategoryStatus>[];
      container.listen(
        categoryViewmodelProvider.select((s) => s.status),
        (_, next) => statuses.add(next),
        fireImmediately: false,
      );

      await container
          .read(categoryViewmodelProvider.notifier)
          .deleteCategory("1");

      expect(statuses, contains(CategoryStatus.deleted));
    });
  });
}
