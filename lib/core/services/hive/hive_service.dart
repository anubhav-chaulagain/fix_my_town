import 'package:fix_my_town/core/constants/hive_table_constants.dart';
import 'package:fix_my_town/features/auth/data/models/user_hive_model.dart';
import 'package:fix_my_town/features/issues/data/models/issues_hive_model.dart';
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
    await _openBoxes();

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

    if (!Hive.isAdapterRegistered(HiveTableConstant.reportTypeId)) {
      Hive.registerAdapter(IssuesHiveModelAdapter());
    }
  }

  // Open all boxes
  Future<void> _openBoxes() async {
    await Hive.openBox<UserHiveModel>(HiveTableConstant.userTable);
    await Hive.openBox<CategoryHiveModel>(HiveTableConstant.categoryTable);
    await Hive.openBox<IssuesHiveModel>(HiveTableConstant.reportTable);
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
    await _authBox.put(user.email, user);
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
  UserHiveModel? getCurrentUser(String email) {
    return _authBox.get(email);
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

  // ISSUE QUERIES ------------------------------------
  Box<IssuesHiveModel> get _issueBox =>
      Hive.box<IssuesHiveModel>(HiveTableConstant.reportTable);

  Future<IssuesHiveModel> createIssue(IssuesHiveModel issue) async {
    await _issueBox.put(issue.issueId, issue);
    return issue;
  }

  List<IssuesHiveModel> getAllIssues() {
    return _issueBox.values.toList();
  }

  IssuesHiveModel? getIssueById(String issueId) {
    return _issueBox.get(issueId);
  }

  Future<bool> updateIssue(IssuesHiveModel issue) async {
    if (_issueBox.containsKey(issue.issueId)) {
      await _issueBox.put(issue.issueId, issue);
      return true;
    }
    return false;
  }

  Future<void> deleteIssue(String issueId) async {
    await _issueBox.delete(issueId);
  }

  List<IssuesHiveModel> getIssuesByStatus(String status) {
    return _issueBox.values.where((issue) => issue.status == status).toList();
  }

  List<IssuesHiveModel> getIssuesByCategory(String category) {
    return _issueBox.values
        .where((issue) => issue.category == category)
        .toList();
  }

  List<IssuesHiveModel> getIssuesByReportedBy(String reportedBy) {
    return _issueBox.values
        .where((issue) => issue.reportedBy == reportedBy)
        .toList();
  }

  List<IssuesHiveModel> getIssuesByPriority(String priority) {
    return _issueBox.values
        .where((issue) => issue.priority == priority)
        .toList();
  }

  List<IssuesHiveModel> getIssuesByAssignedTo(String assignedTo) {
    return _issueBox.values
        .where((issue) => issue.assignedTo == assignedTo)
        .toList();
  }
}
