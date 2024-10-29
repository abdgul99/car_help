import 'dart:convert';
import 'dart:developer';

import 'package:background_sms/background_sms.dart';
import 'package:car_help_app/models/contacts.dart';
import 'package:car_help_app/repo/user_profile.dart';
import 'package:car_help_app/screens/auth/login.dart';
import 'package:car_help_app/screens/home/add_contacts.dart';
import 'package:car_help_app/screens/home/home.dart';
import 'package:car_help_app/screens/home/sos_contact_list.dart';
import 'package:car_help_app/screens/messages/messages.dart';
import 'package:car_help_app/screens/profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  int currentIndex = 0;

  // AnimationController? _animationController;

  @override
  void initState() {
    // _animationController =
    //     AnimationController(vsync: this, duration: const Duration(seconds: 1));

    // _animationController!.reverse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final userW = ref.watch(userProfileProvider);
      return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          backgroundColor: Colors.amber.withOpacity(0.8),
          onTap: (value) {
            currentIndex = value;
            setState(() {});
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: "Message",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(onPressed: () async {
        //   // await Permission.sms.request();
        //   var result = await BackgroundSms.sendMessage(
        //       phoneNumber: "03407777777", message: "how are you");
        //   if (result == SmsStatus.sent) {
        //     print("Sent");
        //   } else {
        //     print("Failed");
        //   }
        // }),
        appBar: AppBar(
          title: Text(tabName(currentIndex)),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.amber, Colors.white]),
            ),
          ),
          actions: [
            if (currentIndex != 2)
              IconButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12.0)), //this right here
                          child: const SoSContactList(),
                        );
                      });
                },
                icon: Icon(Icons.list),
              ),
            if (currentIndex != 2)
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12.0)), //this right here
                          child: const Addcontacts(),
                        );
                      });
                },
                icon: const Icon(Icons.add),
              ),
            if (currentIndex == 2)
              IconButton(
                onPressed: () async {
                  final logout = await showLogoutDialog(context);
                  if (logout == null) return;
                  if (logout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                        (_) => false);
                  }
                },
                icon: const Icon(Icons.logout),
              ),
          ],
        ),
        body: _tab[currentIndex],
      );
    });
  }

  final List<Widget> _tab = [
    const HomeTab(),
    const MessagesTab(),
    const ProfileTab()
  ];
  String tabName(int index) {
    if (index == 0) {
      return "Home";
    } else if (index == 1) {
      return "Messages";
    } else {
      return "Update Profile";
    }
    ;
  }
}

Future<bool?> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm'),
        content: Text('Are you sure you want to Log Out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Return false for No
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Return true for Yes
            },
            child: Text('Yes'),
          ),
        ],
      );
    },
  );
}
