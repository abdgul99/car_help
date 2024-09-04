import 'package:car_help_app/screens/home.dart';
import 'package:car_help_app/ui_helper/snakbar.dart';
import 'package:car_help_app/ui_helper/ui_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  static const String id = "/SignIp";
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailC = TextEditingController();
  final _passwordC = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber.shade300,
        surfaceTintColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Center(child: Icon(Icons.arrow_back_ios)),
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
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 34,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 60),
                  child: Text(
                    'Enter your credentials to Login',
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
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordC,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.lock),
                    hintText: 'Enter Password',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SmallButton(
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
                                    builder: (context) => const Home(),
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
                            : Text('Login'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {},
                      child: const Text('SignUp'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
