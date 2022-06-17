/*
  main.dart
  Author : DenkaTech
  Created : 17/05/2022
    LM : 17/05/2022
    LM : 13/06/2022  - Started adding localization support.
 */
import 'package:flutter/material.dart';
import './screens/Fragments/list.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    // For internationalization the app must be wrapped as this
    EasyLocalization(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('nl', 'BE'),
          Locale('fr', 'BE')
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: const QuickDialApp()),
  );
}

class QuickDialApp extends StatelessWidget {
  const QuickDialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Quick Dial',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: const ListScreen(),
    );
  }
}
