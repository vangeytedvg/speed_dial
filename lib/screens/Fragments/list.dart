/*
  list.dart
  Application main UI.  Shows the local contacts and allows adding or deleteing them
  Author : DenkaTech
  Create : 18/05/2022
    History : 22/05/2022
      - Changed card color and avatar color
 */

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:friendly_chat/models/history.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:friendly_chat/screens/sms_details.dart';

import '../.././models/local_contact.dart';
import '../../db/dbhelper.dart';
import '../ChooseGoogleContacts.dart';
import '../about_app.dart';
import '../call_history.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  DatabaseHandler? handler;
  Future<List<LocalContact>>? _contacts;
  int? nrOfLocalContacts;
  int _smsClicksCounter = 0;

  /*
    State management
   */
  @override
  void initState() {
    super.initState();
    // Create instance of database helper
    handler = DatabaseHandler();
    // handler?.createHistory();
    handler?.initializeDB().whenComplete(() async {
      setState(() {
        _contacts = getList();
      });
    });
  }

  // SMS Counter increment
  void _incrementSMSClickCounter() {
    setState(() {
      _smsClicksCounter++;
    });
  }

  /*
    Get the list of contacts
   */
  Future<List<LocalContact>> getList() async {
    return await handler!.contacts();
  }

  /*
    Refresh the contacts list
   */
  Future<void> _onRefresh() async {
    setState(() {
      _contacts = getList();
    });
  }

  /*
    Handle selection from the appbar dropdown menu
   */
  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        // Empty the database screen
        break;
      case 1:
        // Information about the app
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const AboutPage()));
        break;
    }
  }

  /* 
    SMS Dialog
  */
  void _showSMSDialog(String phoneNr) {
    List<String> recipient = [phoneNr];
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Quick SMS"),
            content: const Text("Kies de snelle boodschap:"),
            actions: <Widget>[
              TextButton(
                  onPressed: () => _sendSMS("Bel mij aub!", recipient),
                  child: const Text("Bel mij aub!")),
              TextButton(
                  onPressed: () => _sendSMS("Kom langs aub!", recipient),
                  child: Text("Kom langs aub!")),
              TextButton(
                  onPressed: () =>
                      _sendSMS("Stuur mij een bericht!", recipient),
                  child: Text("Stuur mij een bericht!")),
            ],
          );
        });
  }

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

  /*
    UI definition
    */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("about_title".tr()),
        centerTitle: true,
        actions: [
          PopupMenuButton<int>(
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(value: 1, child: Text("about".tr())),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // Handle the user pressing the (+) key
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GoogleChooser()),
          ).whenComplete(() => _onRefresh());
        },
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<LocalContact>>(
        future: _contacts,
        builder:
            (BuildContext context, AsyncSnapshot<List<LocalContact>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // If we have some data ....
          final items = snapshot.data ?? <LocalContact>[];
          if (snapshot.hasError) return Text('${snapshot.error}');
          return items.isEmpty
              ? Center(
                  child: Text("list_no_records".tr(),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20)),
                )
              : Scrollbar(
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        /* Allow swipe delete */
                        return Dismissible(
                          direction: DismissDirection.startToEnd,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: const Icon(Icons.delete_forever),
                          ),
                          key: ValueKey<int?>(items[index].id),
                          // Ask for permission to delete
                          confirmDismiss: (DismissDirection direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                /* 
                                  CONFIRM DELETE DIALOG
                                 */
                                return AlertDialog(
                                  title: Text(
                                      "list_alert_confirm_delete_title".tr()),
                                  content:
                                      Text("list_alert_delete_question".tr()),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: Text(
                                          "list_alert_confirm_yes".tr(),
                                          style: const TextStyle(
                                              color: Colors.red),
                                        )),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text("list_alert_confirm_no".tr()),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          /** 
                            SWIPED TO DELETE
                           */
                          onDismissed: (DismissDirection direction) async {
                            // Remove from database and listview
                            await handler?.deleteContact(items[index].id);
                            setState(() {
                              items.remove(items[index]);
                              _onRefresh();
                            });
                          },
                          child: Card(
                              color: const Color.fromRGBO(255, 255, 100, 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.green,
                                  child: Text(
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                      "${items[index].firstName?.substring(0, 1)}"),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.list),
                                  iconSize: 30,
                                  color: Colors.black45,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CallHistory(),
                                          settings: RouteSettings(
                                            arguments: items[index],
                                          )),
                                    );
                                  },
                                ),
                                contentPadding: const EdgeInsets.all(8.0),
                                title: Text(
                                  '${items[index].firstName} ${items[index].name}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text('${items[index].phoneNr}'),
                                /**
                                 * After 3 taps show SMS Dialog
                                 */
                                onTap: () {
                                  _incrementSMSClickCounter();
                                  if (_smsClicksCounter > 2) {
                                    // Implement SMS and reset counter

                                    setState(() {
                                      _smsClicksCounter = 0;
                                    });
                                    String? phoneNr = items[index].phoneNr;
                                    if (phoneNr != null) {
                                      // Call the selected number without delay
                                      //_showSMSDialog(phoneNr);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SMSform(),
                                              settings: RouteSettings(
                                                arguments: items[index],
                                              )));
                                    }
                                  }
                                },
                                /**
                                 * Call the contact.
                                 */
                                onLongPress: () async {
                                  final int? callId = items[index].id;
                                  await DatabaseHandler()
                                      .insertCallHistory(History(
                                    called: DateTime.now().toString(),
                                    calledId: callId,
                                  ));

                                  String? phoneNr = items[index].phoneNr;
                                  if (phoneNr != null) {
                                    // Call the selected number without delay
                                    await FlutterPhoneDirectCaller.callNumber(
                                        phoneNr);
                                  }
                                },
                              )),
                        );
                      },
                    ),
                  ),
                );
        },
      ),
    );
  }
}
