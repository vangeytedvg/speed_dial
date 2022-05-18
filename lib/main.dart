/*
  main.dart
  Author : DenkaTech
  Created : 17/05/2022
    LM : 17/06/2022
 */
import 'package:flutter/material.dart';
import 'package:friendly_chat/db/dbhelper.dart';
import './models/local_contact.dart';
import './screens/Fragments/list.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QuickDialApp());
}


class QuickDialApp extends StatelessWidget {
  const QuickDialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'todos',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: const ListScreen(),
    );
  }
}