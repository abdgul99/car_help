import 'package:car_help_app/models/users.dart';
import 'package:car_help_app/screens/auth/login.dart';
import 'package:car_help_app/screens/home.dart';
import 'package:car_help_app/ui_helper/snakbar.dart';
import 'package:car_help_app/ui_helper/ui_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _phoneC = TextEditingController();
  final _passwordC = TextEditingController();
  final _cPasswordC = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber.shade300,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Center(
            child: Icon(Icons.arrow_back_ios),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                const Text(
                  'SignUp',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Text(
                  'Enter your credentials to Signup',
                  style: TextStyle(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nameC,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Enter Name',
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
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email),
                    hintText: 'Enter Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
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
                  controller: _passwordC,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.lock),
                    hintText: 'Enter Password',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _cPasswordC,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.lock),
                    hintText: 'Confirm Password',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (_cPasswordC.text != _passwordC.text) {
                      return "Passsword didn't match";
                    }
                    // Add your logic to match the password with the first one here
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: SmallButton(
                    onPressed: () {
                      if (_isLoading) return;
                      if (_formKey.currentState!.validate()) {
                        _isLoading = true;
                        setState(() {});
                        singUp().then((user) {
                          if (user != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Home(),
                              ),
                            );
                          }
                        });
                      }
                    },
                    text: _isLoading
                        ? CircularProgressIndicator()
                        : Text('Signup'),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      },
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<UserCredential?> singUp() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailC.text,
        password: _cPasswordC.text,
      );
      createUserDoc(credential);
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      kSnakbar(context, e.message ?? "Something went wrong!");
      _isLoading = false;
      setState(() {});
      return null;
    } catch (e) {
      print(e);
      _isLoading = false;
      setState(() {});
      kSnakbar(context, "Something went wrong!");
      return null;
    }
  }

  void createUserDoc(UserCredential userCredential) {
    final firebase = FirebaseFirestore.instance
        .collection("users")
        .doc(userCredential.user!.uid);
    final user = UserModel(
        name: _nameC.text,
        email: _emailC.text,
        phoneNumber: _phoneC.text,
        createdAt: Timestamp.now(),
        modifiedAt: Timestamp.now(),
        userType: UserType.normalUser);
    firebase.set(user.toMap());
  }
}
