/*
  Get a list of the call history to a given contact
 */
import 'package:flutter/material.dart';
import 'package:friendly_chat/models/history.dart';
import 'package:friendly_chat/models/local_contact.dart';

import '../db/dbhelper.dart';

class CallHistory extends StatefulWidget {
  const CallHistory({Key? key}) : super(key: key);

  @override
  State<CallHistory> createState() => _CallHistoryState();
}

class _CallHistoryState extends State<CallHistory> {
  DatabaseHandler? handler;
  Future<List<History>>? _history;
  int? nrOfHistories;
  LocalContact? myContact;

  /*
    State management
   */
  @override
  void initState() {
    super.initState();
    // Create instance of database helper
    handler = DatabaseHandler();
    handler?.initializeDB().whenComplete(() async {});
  }

  /*
    UI definition
    */
  @override
  Widget build(BuildContext context) {
    final contact = ModalRoute.of(context)!.settings.arguments as LocalContact;

    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        backgroundColor: Colors.green.shade900,
        title: Text('Oproep geschiedenis'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Text(
                  style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                  "${contact.firstName} ${contact.name}")),
          FutureBuilder<List<History>>(
            future: handler?.getCallHistory(contact.id!),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                /* If expanded is not added here, the system will complain with
                * "A RenderFlex overflowed by 309 pixels on the bottom."
                * */
                return Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: snapshot.data!
                        .map(
                          (history) => ListTile(
                            title: Text(
                                style: TextStyle(color: Colors.white),
                                "Oproep gedaan op:"),
                            subtitle: Text(
                                style:
                                    TextStyle(color: Colors.white, fontSize: 20),
                                history.called.toString()),
                          ),
                        )
                        .toList(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
