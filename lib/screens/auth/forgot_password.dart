import 'package:car_help_app/screens/auth/signup.dart';
import 'package:car_help_app/screens/home/home.dart';
import 'package:car_help_app/screens/main_layout.dart';
import 'package:car_help_app/ui_helper/snakbar.dart';
import 'package:car_help_app/ui_helper/ui_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  static const String id = "/ForgotPassword";
  const ForgotPassword({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailC = TextEditingController();
  final _passwordC = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.amber.shade300,
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.amber, Colors.white]),
          ),
        ),
        leading: null,
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //   icon: const Center(
        //     child: Icon(Icons.arrow_back_ios),
        //   ),
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Forgot Passowrd',
                style: TextStyle(
                  fontSize: 34,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailC,
                decoration: InputDecoration(
                  icon: const Icon(Icons.email),
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
              const SizedBox(height: 20),
              SizedBox(
                width: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 150,
                      child: SmallButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _isLoading = true;
                            setState(() {});
                            try {
                              final UserCredential? credential =
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: _emailC.text,
                                          password: _passwordC.text);
                              if (credential != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MainLayout(),
                                  ),
                                );
                              }
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                print('No user found for that email.');
                              } else if (e.code == 'wrong-password') {
                                print('Wrong password provided for that user.');
                              }
                              kSnakbar(
                                  context, e.message ?? "something went wrong");
                              _isLoading = false;
                              setState(() {});
                            }
                          }
                        },
                        text: _isLoading
                            ? CircularProgressIndicator()
                            : Text('Send Reset link'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
