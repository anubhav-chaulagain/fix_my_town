import 'package:fix_my_town/core/constants/hive_table_constants.dart';
import 'package:fix_my_town/features/auth/data/models/user_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

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
  }

  // Register all type adapters
  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.userTypeId)) {
      Hive.registerAdapter(UserHiveModelAdapter());
    }
  }

  // Open all boxes
  Future<void> _openBoxes() async {
    await Hive.openBox<UserHiveModel>(HiveTableConstant.userTable);
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

  // // Create a new user
  // Future<UserHiveModel> createUser(UserHiveModel auth) async {
  //   await _authBox.put(auth.userId, auth);
  //   return auth;
  // }

  // // Get all users
  // List<UserHiveModel> getAllUsers() {
  //   return _authBox.values.toList();
  // }

  // // Get user by Id
  // UserHiveModel? getUserById(String userId) {
  //   return _authBox.get(userId);
  // }

  // // Upadate user
  // Future<void> updateUser(UserHiveModel auth) async {
  //   await _authBox.put(auth.userId, auth);
  // }

  // Future<void> deleteUser(String userId) async {
  //   await _authBox.delete(userId);
  // }
}
