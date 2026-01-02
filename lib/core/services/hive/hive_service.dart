import 'package:fix_my_town/core/constants/hive_table_constants.dart';
import 'package:fix_my_town/features/auth/data/models/auth_hive_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

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
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
  }

  // Open all boxes
  Future<void> _openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.userTable);
  }

  // Delete all users
  Future<void> _deleteAllUsers() async {
    await _authBox.clear();
  }

  // Close all boxes
  Future<void> close() async {
    await Hive.close();
  }

  // -----------  U S E R   C R U D   O P E R A T I O N S  --------------

  // Get user box
  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.userTable);

  // Create a new user
  Future<AuthHiveModel> createUser(AuthHiveModel auth) async {
    await _authBox.put(auth.userId, auth);
    return auth;
  }

  // Get all users
  List<AuthHiveModel> getAllUsers() {
    return _authBox.values.toList();
  }

  // Get user by Id
  AuthHiveModel? getUserById(String userId) {
    return _authBox.get(userId);
  }

  // Upadate user
  Future<void> updateUser(AuthHiveModel auth) async {
    await _authBox.put(auth.userId, auth);
  }

  Future<void> deleteUser(String userId) async {
    await _authBox.delete(userId);
  }
}
