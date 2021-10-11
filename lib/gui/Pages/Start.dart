import 'package:flutter/material.dart';
import 'package:scrabble/Authentication.dart';
import 'package:scrabble/gui/Pages/AuthenticationPage.dart';
import 'package:scrabble/gui/Pages/BottomNavPage.dart';

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