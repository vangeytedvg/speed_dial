import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Speed Dialer",
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
      // Hide that louzy banner!
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // For the contacts information.  Not that it must be nullable otherwise
  // an error will occur... ? char
  //List<Contact>? contacts;
  FToast? fToast;
  // Create an empty list for the local contacts
  List<Contact>? contacts;

  bool isLoading = true;

  void _refreshLocalContacts() async {
  }

  @override
  void initState() {
    super.initState();
    // Prepare the toast
    fToast = FToast();
    fToast?.init(context);
    // Get phone contacts
    getPhoneData();
  }

  // Read the contacts
  void getPhoneData() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      setState(() {});
    }
  }

  // Temporary function to show details of a contact
  void showDetails(String name, String phonenr) {
    fToast?.showToast(child: Text("$name, $phonenr"));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            title:
            const Text("Speed Dial", style: TextStyle(color: Colors.white)),
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
                      ? const CircleAvatar(child: Icon(Icons.person))
                  // If no image available...
                      : CircleAvatar(backgroundImage: MemoryImage(image)),
                  trailing: IconButton(
                      icon: const CircleAvatar(
                          child: Icon(
                            Icons.cabin,
                            size: 30,
                          )),
                      iconSize: 40.0,
                      onPressed: () {
                        showDetails(contacts![index].name.first,
                            contacts![index].phones.first.number);
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
