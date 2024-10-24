import 'package:car_help_app/screens/auth/login.dart';
import 'package:car_help_app/screens/main_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

const String contacts = "contacts";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterContacts.requestPermission();

  var status = await Permission.sms.status;
  if (!status.isGranted) {
    var permission = await Permission.sms.request();
    if (permission.isGranted) {
      // What you want to do after user has granted the permission
    }
  }
  var locationPermission = await Geolocator.checkPermission();
  if (locationPermission == LocationPermission.denied) {
    await Geolocator.requestPermission();
  }
// change
  // Hive.registerAdapter("contact", fromJson)
  // Hive.box(name: contacts);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Roadside Car Help App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: FirebaseAuth.instance.currentUser != null
          ? const MainLayout()
          : const Login(),
    );
  }
}

// somethinng went wrong