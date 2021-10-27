import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scrabble/gui/GeneralUtilities.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key, required this.signUp}) : super(key: key);

  final Future<bool> Function(
      String username,
      String email,
      String password,
      void Function(FirebaseAuthException e) errorCallback
      ) signUp;

  @override
  State createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> _formKey = GlobalKey(debugLabel: "_registerForm");
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register"),),
      body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                submissionForm("Username", _usernameController),
                submissionForm("Email", _emailController),
                submissionForm("Password", _passwordController, obscureText: true),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool registrationSuccessful = await widget.signUp(
                            _usernameController.text,
                            _emailController.text,
                            _passwordController.text,
                                (e) =>
                                    showErrorDialogue(context, "Registration Failed", e.code)
                        );
                        if (registrationSuccessful) {
                          Navigator.of(context).pop();
                        }
                      }},
                    child: Text("Sign Up")
                )
              ],
            ),
          )
      ),
    );
  }
}
