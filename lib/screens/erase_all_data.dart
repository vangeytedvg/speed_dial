import 'package:flutter/material.dart';

class EraseData extends StatelessWidget {
  const EraseData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text("Database leegmaken"),
      centerTitle: true,
      backgroundColor: Colors.red,
    ),
  );
}
