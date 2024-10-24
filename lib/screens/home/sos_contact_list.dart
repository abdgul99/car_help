import 'package:car_help_app/models/contacts.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoSContactList extends StatefulWidget {
  const SoSContactList({
    super.key,
  });

  @override
  State<SoSContactList> createState() => _SoSContactListState();
}

class _SoSContactListState extends State<SoSContactList> {
  // List<Contact> contacts = [];
  List<ContactModel> sContacts = [];
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    loadContactsList();
    super.initState();
  }

  Future<void> loadContactsList() async {
    SharedPreferences.getInstance().then((prefs) {
      List<String>? jsonList = prefs.getStringList('contacts');
      if (jsonList != null) {
        sContacts =
            jsonList.map((jsonStr) => ContactModel.fromJson(jsonStr)).toList();
      }
      setState(() {});
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
    return SizedBox(
      height: 500.0,
      width: 500.0,
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 16),
              const Text("SOS Contacts"),
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
            child: sContacts.isEmpty && !isLoading
                ? const Text("No contacts found")
                : ListView.builder(
                    itemCount: sContacts.length,
                    itemBuilder: (context, index) {
                      final data = sContacts[index];

                      return ListTile(
                        title: Text(data.name),
                        subtitle: Text(data.contact),
                        trailing: IconButton(
                            onPressed: () {
                              sContacts.remove(data);
                              saveContactsList();
                              setState(() {});
                            },
                            icon: Icon(Icons.remove)),
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
