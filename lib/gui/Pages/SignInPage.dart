import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scrabble/gui/GeneralUtilities.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key, required this.signIn}) : super(key: key);

  final Future<bool> Function(
      String email,
      String password,
      void Function(FirebaseAuthException e) errorCallback
      ) signIn;

  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  GlobalKey<FormState> _formKey = GlobalKey(debugLabel: "_signInKey");
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              submissionForm("Email", _emailController),
              submissionForm("Password", _passwordController, obscureText: true),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool signInSuccessful = await widget.signIn(
                          _emailController.text,
                          _passwordController.text,
                              (e) =>
                              showErrorDialogue(context, "Sign In Failed", e.code)
                      );
                      if (signInSuccessful) {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: Text("Sign In")
              )
            ]
        )
      )
      )
    );
  }
}
