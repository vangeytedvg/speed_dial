/*
  main.dart
  Author : DenkaTech
  Created : 17/05/2022
    LM : 17/05/2022
    LM : 13/06/2022  - Started adding localization support.
 */
import 'package:flutter/material.dart';
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
