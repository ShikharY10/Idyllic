import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'db/hivehandler.dart';
import 'screens/home.dart';

Future<String> getAppDirectory(String folderName) async {

  final Directory appDocDir = await getApplicationDocumentsDirectory();
  final Directory appDocDirFolder = Directory('${appDocDir.path}/$folderName/');

  if (await appDocDirFolder.exists()) {
    return appDocDirFolder.path;
  } else {
    final Directory appDocDirNewFolder = await appDocDirFolder.create(recursive: true);
    return appDocDirNewFolder.path;
  }
}

HiveDB hive = HiveDB();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String path = await getAppDirectory("idyllic");
  await hive.init(path);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(hive: hive),
    );
  }
}
