import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum LogInState { loggedIn, loggedOut }

class Authentication extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  LogInState? logInState;
  String? displayName;

  Authentication() {
    _auth.userChanges().listen((User? user) {
      if (user == null) {
        logInState = LogInState.loggedOut;
      } else {
        logInState = LogInState.loggedIn;
        displayName = user.displayName;
      }
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password, void Function(FirebaseAuthException e) errorCallback) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
      return false;
    }
  }

  Future<bool> registerAccount(String username, String email, String password, void Function(FirebaseAuthException e) errorCallback) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await cred.user!.updateDisplayName(username);
      return true;
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
      return false;
    }
  }

  void signOut() {
    _auth.signOut();
    logInState = LogInState.loggedOut;
  }
}