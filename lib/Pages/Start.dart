import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrabble/Authentication.dart';
import 'package:scrabble/Pages/AuthenticationPage.dart';
import 'package:scrabble/Pages/BottomNavPage.dart';

class Start extends StatelessWidget {
  const Start({
    required this.logInState
  });

  final LogInState? logInState;

  @override
  Widget build(BuildContext context) {
    if (logInState == null) {
      return CircularProgressIndicator();
    } else if (logInState == LogInState.loggedOut) {
      return AuthenticationPage();
    } else
      return BottomNavPage();
  }
}