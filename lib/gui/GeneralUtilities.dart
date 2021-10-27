import 'package:flutter/material.dart';

TextFormField submissionForm(String label, TextEditingController controller, {bool obscureText = false}) {
  return TextFormField(
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
    ),
    controller: controller,
    obscureText: obscureText,
    validator: (String? value) {
      return (value == null || value.length == 0) ? 'This field is required' : null;
    },
  );
}

void showErrorDialogue(BuildContext context, String titleText, String content) {
  showDialog(
      context: context,
      builder: (BuildContext context) => simpleAlert(context, titleText, content)
  );
}

AlertDialog simpleAlert(BuildContext context, String titleText, String content) {
  return AlertDialog(
    title: Text(titleText),
    content: Text(content),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text("Ok"),
      )
    ],
  );
}
