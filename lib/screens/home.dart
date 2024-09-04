import 'package:car_help_app/repo/user_profile.dart';
import 'package:car_help_app/screens/auth/login.dart';
import 'package:car_help_app/screens/edit_credentials.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final userW = ref.watch(userProfileProvider);
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber.shade300,
        ),
        drawer: Drawer(
            child: userW.when(
          data: (data) => ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.amber.shade300,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name, // Replace with actual user name
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      data.email, // Replace with actual email
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text('Edit Credentials'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditCredentials(
                        userModel: data,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Log Out'),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ),
                      (f) => false);
                },
              ),
              // Add more drawer items here if needed
            ],
          ),
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => LinearProgressIndicator(),
        )),
        body: const Center(
          child: Text('Home Screen'),
        ),
      );
    });
  }
}
