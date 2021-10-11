import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scrabble/gui/SignInUtilities.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key, required this.signIn}) : super(key: key);

  final Future<void> Function(
      String email,
      String password,
      void Function(FirebaseAuthException e) errorCallback
      ) signIn;

  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              signInForm("Email", _emailController),
              signInForm("Password", _passwordController, obscureText: true),
              ElevatedButton(
                  onPressed: () async {
                    await widget.signIn(
                      _emailController.text,
                      _passwordController.text,
                        (e) => showErrorDialogue(context, "Sign In Failed", e)
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text("Sign In")
              )
            ]
        )
      )
    );
  }
}
