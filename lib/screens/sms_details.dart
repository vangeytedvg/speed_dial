///
/// sms_details.dart
/// Sends predefined SMS's to a contact
/// Author : DenkTech
/// Created : 17/06/2022
///   LM    : 18/06/2022
///
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';

class SMSform extends StatefulWidget {
  final String contactName;
  final String contactPhoneNr;
  const SMSform(
      {Key? key, required this.contactName, required this.contactPhoneNr})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<SMSform> createState() => _SMSformState(contactName, contactPhoneNr);
}

class _SMSformState extends State<SMSform> {
  final String contactName;
  final String contactPhonenr;
  _SMSformState(this.contactName, this.contactPhonenr);

  /// Determine the current location of the phone
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  /*
   * This method Sends the actual SMS
   */
  Future<void> _sendSMS(String message, phoneNr) async {
    List<String> recipients = [];
    recipients.add(phoneNr);
    try {
      String result = await sendSMS(
        message: message,
        recipients: recipients,
        sendDirect: false,
      );
      Fluttertoast.showToast(
          msg: "sms_details_sent".tr(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      debugPrint(result);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        title: Text(
          "SMS -> $contactName",
          overflow: TextOverflow.fade,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(240, 80), primary: Colors.deepOrange),
                child: Text(
                  "sms_details_callme".tr(),
                  style: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  _sendSMS("sms_details_callme".tr(), contactPhonenr);
                },
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(240, 80), primary: Colors.deepOrange),
                child: Text("sms_details_textme".tr(),
                    style: const TextStyle(fontSize: 20)),
                onPressed: () {
                  _sendSMS("sms_details_textme".tr(), contactPhonenr);
                },
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(240, 80), primary: Colors.deepOrange),
                child: Text("sms_details_comeover".tr(),
                    style: const TextStyle(fontSize: 20)),
                onPressed: () {
                  _sendSMS("sms_details_comeover".tr(), contactPhonenr);
                },
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(240, 80), primary: Colors.deepOrange),
                child: Text("sms_details_mylocation".tr(),
                    style: const TextStyle(fontSize: 20)),
                onPressed: () async {
                  // Obtain the GPS location of the device and send it via SMS
                  String smsText = "";
                  Position position = await _determinePosition();
                  String geolocurl =
                      "http://maps.google.com/?q=${position.latitude},${position.longitude}";
                  smsText = "${"sms_details_mylocation".tr()}  $geolocurl";
                  _sendSMS(smsText, contactPhonenr);
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}
