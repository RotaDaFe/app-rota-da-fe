
import 'package:rota_da_fe/config/database_helper.dart';
import 'package:rota_da_fe/models/user.model.dart';

class UserRepository {
  final HiveHelper helper;
  final String boxName = 'logins';
  UserRepository(this.helper);

  Future<int> addUser(UserModel user) async {
    final box = helper.getBox(boxName);
    return await box.add(user.toMap());
  }

  Future<void> updateUser(int id, UserModel user) async {
    final box = helper.getBox(boxName);
    await box.put(id, user.toMap());
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final box = helper.getBox(boxName);
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final box = helper.getBox(boxName);
    final user = box.get(id);
    if (user != null) {
      return Map<String, dynamic>.from(user);
    }
    return null;
  }
}
