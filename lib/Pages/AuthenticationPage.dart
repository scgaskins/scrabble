import 'package:flutter/material.dart';

class AuthenticationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {},
                child: Text("Sign In")
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed("/register"),
              child: Text("Register"),
            ),
          ],
        ),
      )
    );
  }

}
