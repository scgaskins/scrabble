import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
