// ignore: slash_for_doc_comments
/**
 * sms_details.dart
 * Created : 17/06/2022
 *    LM   : 17/06/2022
 */
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SMSform extends StatefulWidget {
  final String contactName;
  final String contactPhoneNr;
  const SMSform(
      {Key? key, required this.contactName, required this.contactPhoneNr})
      : super(key: key);

  @override
  State<SMSform> createState() => _SMSformState();
}

class _SMSformState extends State<SMSform> {
  Future<void> _sendSMS(String message, List<String> recipients) async {
    try {
      String _result = await sendSMS(
        message: message,
        recipients: recipients,
        sendDirect: false,
      );
      Fluttertoast.showToast(
          msg: "SMS is verzonden!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      debugPrint(_result);
    } catch (error) {
      debugPrint(error.toString());
      Fluttertoast.showToast(
          msg: error.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    // ignore: use_build_context_synchronously
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Snelle SMS verzenden"),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: IntrinsicWidth(
          stepWidth: 150.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                child: Text("Bel me!"),
                onPressed: () {},
              ),
              ElevatedButton(
                child: Text("Stuur mij een bericht!"),
                onPressed: () {},
              ),
              ElevatedButton(
                child: Text("Kom langs!"),
                onPressed: () {},
              ),
              ElevatedButton(
                child: Text("Dit is mijn locatie"),
                onPressed: () {},
              ),
            ],
          ),
        ),
      )),
    );
  }
}
