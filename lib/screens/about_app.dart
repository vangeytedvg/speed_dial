/*
  abaut_app.dart
  Show a simple about dialog
  Author : DenkaTech
  Created : 19/05/2022
 */
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("About"),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: _aboutLayout(),
      );
}

Widget _aboutLayout() {
  return Column(
    children: [
      const SizedBox(
        height: 45,
      ),
      const ListTile(
        title: Center(
            child: Text(
          'DenkaTech',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              fontFamily: "BrushKing-MVVPp"),
        )),
      ),
      const ListTile(
        title: Center(
            child: Text(
          'Software',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              fontFamily: "BrushKing-MVVPp"),
        )),
        subtitle: Center(
            child:
                Text('Quick Dial Application', style: TextStyle(fontSize: 20))),
      ),
      const SizedBox(
        height: 45,
      ),
      Container(
          alignment: Alignment.center,
          child: Image.asset("assets/splash.png", fit: BoxFit.cover)),
      const ListTile(
        title: Center(child: Text('Versie 0.1.1')),
        subtitle: Center(child: Text('Geschreven in Flutter 3.0')),
      ),
    ],
  );
}
