import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:friendly_chat/models/local_contact.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:math' as math;
import 'dart:typed_data';
import '../db/dbhelper.dart';

class GoogleChooser extends StatefulWidget {
  const GoogleChooser({Key? key}) : super(key: key);

  @override
  State<GoogleChooser> createState() => _GoogleChooserState();
}

class _GoogleChooserState extends State<GoogleChooser> {
  List<Contact>? contacts;
  //final bool _permissionDenied = false;

  // Get the phone's contact list on startup
  @override
  void initState() {
    super.initState();
    getContactList();
  }

  /*
    Get the contacts from the phone
   */
  void getContactList() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            title: Text("choose_google_contacts_title".tr(),
                style: const TextStyle(color: Colors.white)),
            centerTitle: true,
            elevation: 5),
        body: (contacts == null)
            ? const Center(child: CircularProgressIndicator())
            /* Create a list of the contacts */
            : ListView.builder(
                itemCount: contacts!.length,
                padding: const EdgeInsets.all(5.0),
                itemBuilder: (BuildContext context, int index) {
                  // Get the image if available
                  Uint8List? image = contacts![index].photo;
                  // Get the phone number
                  String number = (contacts![index].phones.isNotEmpty)
                      ? (contacts![index].phones.first.number)
                      : "No phone number";
                  return Card(
                    color: const Color.fromRGBO(255, 255, 10, 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: ListTile(
                      dense: false,
                      // Show an avatar of the contact's picture, or show first letter avatar
                      leading: (image == null)
                          ? CircleAvatar(
                              radius: 25.0,
                              backgroundColor: Color(
                                      (math.Random().nextDouble() * 0xFFFFFF)
                                          .toInt())
                                  .withOpacity(1.0),
                              child: Icon(Icons.person))
                          // If no image available...
                          : CircleAvatar(backgroundImage: MemoryImage(image)),
                      trailing: IconButton(
                          icon: const CircleAvatar(
                              child: Icon(
                            Icons.add_call,
                            size: 30,
                          )),
                          iconSize: 40.0,
                          onPressed: () async {
                            // Add the selected contact to the local database
                            if (number == "No phone number") {
                              return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                          "choose_google_contacts_no_phone"
                                              .tr()),
                                      content: Text(
                                          "choose_google_contacts_no_phone_dialog_content"
                                              .tr()),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: Text(
                                                "choose_google_contacts_no_phone_dialog_ok"
                                                    .tr())),
                                      ],
                                    );
                                  });
                            } else {
                              await DatabaseHandler()
                                  .insertContact(LocalContact(
                                      name: contacts![index].name.last,
                                      firstName: contacts![index].name.first,
                                      phoneNr:
                                          contacts![index].phones.first.number))
                                  .whenComplete(
                                      () => Navigator.of(context).pop());
                            }
                          }),
                      /* Show the name of the contact */
                      title: Text(
                          "${contacts![index].name.first} ${contacts![index].name.last}"),
                      subtitle: Text(number),
                    ),
                  );
                }));
  }
}
