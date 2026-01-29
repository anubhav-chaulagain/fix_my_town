import 'package:fix_my_town/core/constants/hive_table_constants.dart';
import 'package:fix_my_town/features/auth/data/models/user_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fix_my_town/features/category/data/models/category_hive_model.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  // Initialize Hive
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${HiveTableConstant.dbName}';
    Hive.init(path);
    _registerAdapters();
    _openBoxes();

    // insert dummy data
    await insertCategoryDummyData();
  }

  // Category dummy data
  Future<void> insertCategoryDummyData() async {
    final categoryBox = Hive.box<CategoryHiveModel>(
      HiveTableConstant.categoryTable,
    );

    if (categoryBox.isNotEmpty) {
      return;
    }

    final dummyCategories = [
      CategoryHiveModel(
        name: 'Drinking Water',
        description:
            'Water supply issues, leakage, contamination, low pressure',
      ),
      CategoryHiveModel(
        name: 'Road & Potholes',
        description: 'Damaged roads, potholes, broken footpaths',
      ),
      CategoryHiveModel(
        name: 'Garbage & Waste',
        description: 'Overflowing bins, irregular garbage collection, dumping',
      ),
      CategoryHiveModel(
        name: 'Street Lights',
        description: 'Non-functioning or damaged street lights',
      ),
      CategoryHiveModel(
        name: 'Drainage & Sewage',
        description: 'Blocked drains, sewage overflow, bad odor',
      ),
      CategoryHiveModel(
        name: 'Electricity',
        description: 'Power outages, exposed wires, transformer issues',
      ),
      CategoryHiveModel(
        name: 'Public Safety',
        description: 'Open manholes, fallen trees, unsafe public areas',
      ),
      CategoryHiveModel(
        name: 'Other',
        description: 'Any other community-related issues',
      ),
    ];

    for (var category in dummyCategories) {
      await categoryBox.put(category.categoryId, category);
    }
  }

  // Register all type adapters
  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.userTypeId)) {
      Hive.registerAdapter(UserHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(HiveTableConstant.categoryTypeId)) {
      Hive.registerAdapter(CategoryHiveModelAdapter());
    }
  }

  // Open all boxes
  Future<void> _openBoxes() async {
    await Hive.openBox<UserHiveModel>(HiveTableConstant.userTable);
    await Hive.openBox<CategoryHiveModel>(HiveTableConstant.categoryTable);
  }

  // Delete all batches
  Future<void> deleteAllBatches() async {
    await _authBox.clear();
  }

  // Close all boxes
  Future<void> close() async {
    await Hive.close();
  }

  // -----------  U S E R   C R U D   O P E R A T I O N S  --------------

  // Get user box
  Box<UserHiveModel> get _authBox =>
      Hive.box<UserHiveModel>(HiveTableConstant.userTable);

  // Register a new user
  Future<UserHiveModel> register(UserHiveModel user) async {
    await _authBox.put(user.userId, user);
    return user;
  }

  // login
  Future<UserHiveModel?> login(String email, String password) async {
    final users = _authBox.values.where(
      (user) => user.email == email && user.password == password,
    );
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  // logout
  Future<void> logout() async {}

  // get current user
  UserHiveModel? getCurrentUser(String userId) {
    return _authBox.get(userId);
  }

  // if email exists
  Future<bool> ifEmailExists(String email) async {
    final users = _authBox.values.where((user) => user.email == email);
    return users.isNotEmpty;
  }

  // CATEGORY QUERIES ------------------------------------
  Box<CategoryHiveModel> get _categoryBox =>
      Hive.box<CategoryHiveModel>(HiveTableConstant.categoryTable);

  Future<CategoryHiveModel> createCategory(CategoryHiveModel category) async {
    await _categoryBox.put(category.categoryId, category);
    return category;
  }

  List<CategoryHiveModel> getAllCategories() {
    return _categoryBox.values.toList();
  }

  CategoryHiveModel? getCategoryById(String categoryId) {
    return _categoryBox.get(categoryId);
  }

  Future<bool> updateCategory(CategoryHiveModel category) async {
    if (_categoryBox.containsKey(category.categoryId)) {
      await _categoryBox.put(category.categoryId, category);
      return true;
    }
    return false;
  }

  Future<void> deleteCategory(String categoryId) async {
    await _categoryBox.delete(categoryId);
  }
}
