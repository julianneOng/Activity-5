import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Contact> contacts = [];
   String url =
      'https://cdn.pixabay.com/photo/2022/08/18/20/18/red-maple-leaves-7395624_960_720.jpg';

  @override
  void initState() {
    checkPermission();

    super.initState();
  }

  checkPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      await getContacts();
    }
  }

  getContacts() async {
    contacts = await FlutterContacts.getContacts(withProperties: true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
      ),
      body: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(contacts[index].displayName),
              subtitle: Text(contacts[index].phones.isNotEmpty
                  ? contacts[index].phones.first.number
                  : "--"),
            );
          }),
    );
  }
}
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Save image example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Display the network image
            Image.network(url),
            ElevatedButton(
                onPressed: () async {
                  //Save image to file.
                  var response = await http.get(Uri.parse(url));
                  Directory? externalStorageDirectory =
                      await getExternalStorageDirectory();
                  File file = new File(path.join(
                      externalStorageDirectory!.path, path.basename(url)));
                  await file.writeAsBytes(response.bodyBytes);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text("Image saved Successfully!"),
                            content: Image.file(file),
                          ));
                },
                child: Text("Save image"))
          ],
        ),
      ),
    );
  }

