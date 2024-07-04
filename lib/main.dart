import 'package:flutter/material.dart';
import 'package:flutter_advance/models/expence.dart';
import 'package:flutter_advance/pages/expences.dart';
import 'package:flutter_advance/server/categories_adapter.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  //init hive
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenceModelAdapter());
  Hive.registerAdapter(CategoryAdapter());

  await Hive.openBox("expenceDatabase");

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Expences(),
    );
  }
}
