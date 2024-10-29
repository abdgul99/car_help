import 'dart:async';

import 'package:background_sms/background_sms.dart';
import 'package:car_help_app/models/contacts.dart';
import 'package:car_help_app/models/message.dart';
import 'package:car_help_app/models/users.dart';
import 'package:car_help_app/ui_helper/snakbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({
    super.key,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool readOnly = true;
  int sendCount = 0;
  int countdown = 0; // Countdown in seconds
  final messagesC = TextEditingController();
  List<ContactModel> sContacts = [];
  bool isLoading = false;
  String? mapLinks;

  @override
  void initState() {
    getMessage(context);
    // TODO: implement initState
  }

// http://maps.apple.com/?q=help&ll=${position.latitude},${position.longitude}\n\n
  getLocationLink(Position position) {
    mapLinks =
        "Find on Map: https://www.google.com/maps/search/?api=1&q=help&query=${position.latitude},${position.longitude}";
  }

  Future<void> getMessage(BuildContext context) async {
    isLoading = true;

    setState(() {});
    try {
      final firebase = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .withConverter(
              fromFirestore: (snapshot, options) =>
                  UserModel.fromMap(snapshot.data()!),
              toFirestore: (value, options) => value.toMap())
          .get();

      messagesC.text = firebase.data()!.message; // Set the text
      var position = await Geolocator.getCurrentPosition();
      getLocationLink(position);
      setState(() {});
    } catch (e) {
      // Handle error (e.g., show a snackbar)
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      // Dismiss the loading dialog
      isLoading = false;

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Align(
              //     alignment: Alignment.topCenter,
              //     child: const Text("Your final message")),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  child: TextFormField(
                    controller: messagesC,
                    readOnly: readOnly,
                    maxLength: 100,
                    maxLines: null,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            readOnly = !readOnly;
                            if (readOnly) {
                              print("save");
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({"message": messagesC.text});
                            }
                            setState(() {});
                          },
                          icon: readOnly ? Icon(Icons.edit) : Icon(Icons.save)),
                      border: const OutlineInputBorder(),
                      label: Text("Custom SOS message"),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      backgroundColor: Colors.red,
                      shape: const CircleBorder(),
                      side: const BorderSide(
                        width: 10,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      // _animationController!.stop();
                      // _animationController!.forward();
                      // _animationController!
                      //     .repeat(period: const Duration(seconds: 1));
                      // getting contacts from local database
                      if (countdown > 0) {
                        kSnakbar(context, "SOS is already in progress");
                      }
                      final isSend = await showConfirmationDialog(context);
                      if (isSend == null) return;
                      if (isSend) {
                        sendMessages(context);
                        // print(isSend);
                      }
                    },
                    child: countdown > 0
                        ? Text(
                            "Please Wait ${countdown.toString()}\n${sendCount}/${sContacts.length}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        : const Text(
                            'SOS',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Stack(
                children: [
                  Center(
                    child: CustomPaint(
                      painter: TrianglePainter(
                        strokeColor: Colors.blue,
                        strokeWidth: 0,
                        paintingStyle: PaintingStyle.fill,
                      ),
                      child: const SizedBox(
                        height: 15,
                        width: 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text.rich(
                            TextSpan(text: "${messagesC.text}\n", children: [
                              if (mapLinks != null) TextSpan(text: mapLinks),
                            ]),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          );
  }

// Find on Map: http://maps.apple.com/?q=help&ll=$latitude,$longitude\n\nhttps://www.google.com/maps/search/?api=1&q=help&query=$latitude,$longitude
  Future<void> sendMessages(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('contacts');

    // Check if null or empty return it.
    if (jsonList != null) {
      if (jsonList.isEmpty) {
        kSnakbar(context, "Please add Contacts for SOS");
        return;
      }
      sContacts =
          jsonList.map((jsonStr) => ContactModel.fromJson(jsonStr)).toList();
    } else {
      kSnakbar(context, "Please add Contacts for SOS");
      return;
    }

    countdown =
        5 * sContacts.length; // Total countdown based on number of contacts
    sendCount = 0;
    startCountdown();
    setState(() {});
    for (int i = 0; i < sContacts.length; i++) {
      // Wait for the countdown before sending the message
      await Future.delayed(const Duration(seconds: 5));
      String sendIngLink = mapLinks ?? "";
      var result = await BackgroundSms.sendMessage(
          phoneNumber: sContacts[i].contact,
          message: "${messagesC.text}\n$sendIngLink");

      if (result == SmsStatus.sent) {
        print("Message to ${sContacts[i].contact} sent successfully!");
        saveMessage(
            phoneNmuber: sContacts[i].contact,
            name: sContacts[i].name,
            message: "${messagesC.text}\n$sendIngLink");
        kSnakbar(
            context, "Message to ${sContacts[i].contact} sent successfully!");
      } else {
        print("Message to ${sContacts[i].contact} failed to send.");
        kSnakbar(context, "Message to ${sContacts[i].contact} failed to send.");
      }
      sendCount++;
    }
  }

  void startCountdown() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        countdown--;

        setState(() {});
      } else {
        timer.cancel();
      }
    });
  }
}

void saveMessage(
    {required String phoneNmuber,
    required String name,
    required String message}) {
  final firebase = FirebaseFirestore.instance.collection("messages").doc();
  final messageModel = MessageModel(
      name: name,
      contact: phoneNmuber,
      sendBy: FirebaseAuth.instance.currentUser!.uid,
      createdAt: Timestamp.now(),
      message: message);
  firebase.set(messageModel.toJson());
}

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter(
      {this.strokeColor = Colors.black,
      this.strokeWidth = 3,
      this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

Future<bool?> showConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm'),
        content: Text('Are you sure you want to send this message?'),
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
