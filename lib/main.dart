import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
        primarySwatch: Colors.blue,
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
  List<Contact>? contacts;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
                const Text("Speed Dial", style: TextStyle(color: Colors.white)),
            centerTitle: true,
            elevation: 5),
        body: (contacts == null)
            ? const Center(child: CircularProgressIndicator())
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
                    child: ListTile(
                    dense: false,
                    // Show an avatar of the contact's picture, or show first letter avatar
                    leading: (image == null)
                        ? const CircleAvatar(child: Icon(Icons.person))
                        // If no image available...
                        : CircleAvatar(
                            backgroundImage: MemoryImage(image),
                          ),
                    title: Text(
                        "${contacts![index].name.first} ${contacts![index].name.last}"),
                    subtitle: Text(number),
                    onLongPress: () {},
                    onTap: () {
                      launchUrlString('tel: $number');
                    },
                  ),);
                }));
  }
}
