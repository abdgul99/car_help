import 'dart:io';

import 'package:car_help_app/models/users.dart';
import 'package:car_help_app/screens/auth/login.dart';
import 'package:car_help_app/screens/home/home.dart';
import 'package:car_help_app/screens/main_layout.dart';
import 'package:car_help_app/ui_helper/snakbar.dart';
import 'package:car_help_app/ui_helper/ui_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  XFile? _xfile;
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

      _userModel = userModel;
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

  Future<String?> uploadPic() async {
    // Get the file from the image picker and store it
    FirebaseStorage storage = FirebaseStorage.instance;
    final ImagePicker picker = ImagePicker();

    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    _xfile = image;
    setState(() {});
    if (image == null) {
      // If no image is selected, return null or handle the case as needed.
      return null;
    }

    // Create a reference to the location you want to upload to in Firebase
    var reference = storage.ref().child("images/${image.name}");

    // Upload the file to Firebase
    File file = File(image.path);
    await reference.putFile(file);

    // Get the download URL
    String downloadUrl = await reference.getDownloadURL();
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"image": downloadUrl});

    // Return the download URL
    return downloadUrl;
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
                          if (_xfile != null)
                            CircleAvatar(
                              radius: 50,
                              foregroundImage: FileImage(File(_xfile!.path)),
                              child: IconButton(
                                  onPressed: () {
                                    uploadPic();
                                  },
                                  icon: Icon(Icons.camera_alt_rounded)),
                            ),
                          if (_xfile == null)
                            CircleAvatar(
                              radius: 50,
                              foregroundImage: _userModel == null
                                  ? null
                                  : NetworkImage(_userModel!.image),
                              child: IconButton(
                                  onPressed: () {
                                    uploadPic();
                                  },
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
