import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key, required this.signUp}) : super(key: key);

  final Future<void> Function(
      String username,
      String email,
      String password,
      void Function(FirebaseAuthException e) errorCallback
      ) signUp;

  State createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:
      Text("Register"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            signInForm("Username", _usernameController),
            signInForm("Email", _emailController),
            signInForm("Password", _passwordController, obscureText: true),
            ElevatedButton(
                onPressed: () async {
                  await widget.signUp(
                    _usernameController.text,
                    _emailController.text,
                    _passwordController.text,
                      (e) => showErrorDialogue(context, "Registration Failed", e)
                  );
                  Navigator.of(context).pop();
                },
                child: Text("Sign Up")
            )
          ],
        ),
      ),
    );
  }

  TextFormField signInForm(String label, TextEditingController controller, {bool obscureText = false}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      controller: controller,
      obscureText: obscureText,
      validator: (String? value) {
        return (value != null) ? 'This field is required' : null;
      },
    );
  }

  void showErrorDialogue(BuildContext context, String titleText, FirebaseAuthException e) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(titleText),
          content: Text("${e.code}"),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Ok")
            )
          ],
        )
    );
  }
}
