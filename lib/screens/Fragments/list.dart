/*
  list.dart
  Application main UI.  Shows the local contacts and allows adding or deleteing them
  Author : DenkaTech
  Create : 18/05/2022
    LM : 18/05/2022
 */

import 'package:flutter/material.dart';
import '../.././models/local_contact.dart';
import '../../db/dbhelper.dart';
import '../ChooseGoogleContacts.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  DatabaseHandler? handler;
  Future<List<LocalContact>>? _contacts;
  int? nrOfLocalContacts;

  /*
    State management
   */
  @override
  void initState() {
    super.initState();
    // Create instance of database helper
    handler = DatabaseHandler();
    handler?.initializeDB().whenComplete(() async {
      setState(() {
        _contacts = getList();
      });
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
    UI definition
    */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Quick Dialer"),
      ),
      floatingActionButton: FloatingActionButton(
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
          if (snapshot.data!.isEmpty) {
            return const Center(
                child: Text(
                  "Geen locale contacten, druk op (+) om er toe te voegen!",
                  style: TextStyle(color: Colors.white,
                  fontSize: 20),
            ));
          }
          return Scrollbar(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  if (items.isEmpty) {
                    return const Center(
                        child: Text("No local contacts in database!"));
                  }
                  /* Allow swipe delete */
                  return Dismissible(
                    direction: DismissDirection.startToEnd,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: const Icon(Icons.delete_forever),
                    ),
                    key: ValueKey<int?>(items[index].id),
                    // Ask for permission to delete
                    confirmDismiss: (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirmeer wissen"),
                            content: const Text(
                                "Bent U zeker dat u dit locaal contact wilt verwijderen?"),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("Verwijder")),
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("Annuleer"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (DismissDirection direction) async {
                      // Remove from database and listview
                      await handler?.deleteContact(items[index].id);
                      setState(() {
                        items.remove(items[index]);
                        _onRefresh();
                      });
                    },
                    child: Card(
                        color: const Color.fromRGBO(255, 255, 10, 30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8.0),
                          title: Text(
                              '${items[index].name} ${items[index].firstName}'),
                          subtitle: Text('${items[index].phoneNr}'),
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
