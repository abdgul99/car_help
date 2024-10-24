import 'package:car_help_app/models/contacts.dart';
import 'package:car_help_app/ui_helper/snakbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Addcontacts extends StatefulWidget {
  const Addcontacts({
    super.key,
  });

  @override
  State<Addcontacts> createState() => _AddcontactsState();
}

class _AddcontactsState extends State<Addcontacts> {
  List<Contact> contacts = [];
  List<ContactModel> sContacts = [];
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    getContacts();
    super.initState();
  }

  Future<void> getContacts() async {
    try {
      isLoading = true;
      setState(() {});
      List<Contact> contacts = await FlutterContacts.getContacts(
        withProperties: true,
      );
      this.contacts = contacts;
    } catch (e) {}
    loadContactsList();
    isLoading = false;
    setState(() {});
  }

  Future<void> loadContactsList() async {
    SharedPreferences.getInstance().then((prefs) {
      List<String>? jsonList = prefs.getStringList('contacts');
      if (jsonList != null) {
        sContacts =
            jsonList.map((jsonStr) => ContactModel.fromJson(jsonStr)).toList();
      }
    });
  }

  void saveContactsList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = sContacts.map((item) => item.toJson()).toList();
    await prefs.setStringList('contacts', jsonList);
    loadContactsList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.0,
      width: 500.0,
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 16),
              const Text("Add Contact"),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close)),
            ],
          ),
          isLoading ? CircularProgressIndicator() : SizedBox(),
          Expanded(
            child: contacts.isEmpty && !isLoading
                ? const Text("No contacts found")
                : ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final data = contacts[index];

                      return data.phones.isEmpty
                          ? const SizedBox()
                          : ListTile(
                              title: Text(data.displayName),
                              subtitle:
                                  Text(data.phones.first.normalizedNumber),
                              trailing: IconButton(
                                  onPressed: () {
                                    ContactModel newContact = ContactModel(
                                      name: data.displayName,
                                      contact:
                                          data.phones.first.normalizedNumber,
                                    );
                                    if (sContacts.length > 9) {
                                      if (sContacts.contains(newContact)) {
                                        // If it exists, remove it
                                        sContacts.remove(newContact);
                                        saveContactsList();
                                        setState(() {});
                                        return;
                                      }
                                      kSnakbar(context,
                                          "Only 10 contacts are allowed to SOS.");
                                      return;
                                    }

                                    if (sContacts.contains(newContact)) {
                                      // If it exists, remove it
                                      sContacts.remove(newContact);
                                    } else {
                                      // If it doesn't exist, add it
                                      sContacts.add(newContact);
                                    }
                                    saveContactsList();
                                    setState(() {});
                                  },
                                  icon: !sContacts.contains(ContactModel(
                                    name: data.displayName,
                                    contact: data.phones.first.normalizedNumber,
                                  ))
                                      ? const Icon(Icons.add)
                                      : Icon(Icons.remove)),
                              // subtitle: Text(data.phones),
                            );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
