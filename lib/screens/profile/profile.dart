import 'package:car_help_app/models/users.dart';
import 'package:car_help_app/screens/auth/login.dart';
import 'package:car_help_app/screens/home/home.dart';
import 'package:car_help_app/screens/main_layout.dart';
import 'package:car_help_app/ui_helper/snakbar.dart';
import 'package:car_help_app/ui_helper/ui_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final _formKey = GlobalKey<FormState>();
  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _message = TextEditingController();
  final _phoneC = TextEditingController();
  // final _passwordC = TextEditingController();
  // final _cPasswordC = TextEditingController();
  bool _isLoading = false;
  UserModel? _userModel;
  bool error = false;
  @override
  void initState() {
    // TODO: implement initState
    getUser();
    super.initState();
  }

  getUser() async {
    _isLoading = true;
    error = false;
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
      var userModel = firebase.data();

      userModel = userModel;
      _nameC.text = userModel!.name;
      _emailC.text = userModel.email;
      _phoneC.text = userModel.phoneNumber;
      _message.text = userModel.message;
    } catch (e) {
      error = true;
      setState(() {});
    }
    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : error
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Something went wrong!"),
                          IconButton(
                              onPressed: () {
                                getUser();
                              },
                              icon: const Icon(Icons.refresh))
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 60),
                          CircleAvatar(
                            radius: 50,
                            child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.camera_alt_rounded)),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _nameC,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person),
                              hintText: 'Name',
                            ),
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _emailC,
                            enabled: false,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.email),
                              hintText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _phoneC,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.phone),
                              hintText: 'Contact Number',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your contact number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _message,
                            maxLength: 100,
                            maxLines: null,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.message),
                              hintText: 'Custom SOS message',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your contact number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.center,
                            child: SmallButton(
                              onPressed: () {
                                if (_isLoading) return;
                                if (_userModel == null) {
                                  kSnakbar(context,
                                      "Something went wrong please reopen your app and make sure to connect to the internet.");
                                  return;
                                }
                                if (_formKey.currentState!.validate()) {
                                  UserModel userModel = UserModel(
                                    name: _nameC.text,
                                    email: _emailC.text,
                                    phoneNumber: _phoneC.text,
                                    createdAt: _userModel!.createdAt,
                                    message: _message.text,
                                    image: _userModel!.image,
                                    modifiedAt: Timestamp.now(),
                                  );
                                  updateuser(userModel);
                                  kSnakbar(context, "Updated!");
                                }
                              },
                              text: _isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text('Update'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const SizedBox(height: 70),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  void updateuser(UserModel userModel) {
    final firebase = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    firebase.set(userModel.toMap());
  }
}
