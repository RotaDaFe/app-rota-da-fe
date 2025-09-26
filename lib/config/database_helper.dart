import 'package:hive_flutter/hive_flutter.dart';

class HiveHelper {
  Future<void> init() async {
    await Hive.initFlutter();
  }

  Future<void> openBox(String boxName) async {
    await Hive.openBox(boxName);
  }

  Box getBox(String boxName) {
    return Hive.box(boxName);
  }
}
