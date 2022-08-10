import 'package:hive_flutter/hive_flutter.dart';

class HiveDB {
  late Box<String> dashboardBox;

  Future<void> init(String path) async {
    Hive.initFlutter(path);
    dashboardBox = await Hive.openBox<String>("dashboardBox",path: path);
  }
}