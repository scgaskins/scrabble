import 'dart:developer';

import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key, required this.signOut, required this.userName}) : super(key: key);

  final void Function() signOut;
  final String? userName;

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          children: [
            Text("Hello ${widget.userName}"),
            ElevatedButton(
                onPressed: widget.signOut,
                child: Text("Sign Out")
            )
          ]
      ),
    );
  }
}
