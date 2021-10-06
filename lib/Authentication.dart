import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum LogInState { loggedIn, loggedOut }

class Authentication extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late LogInState logInState;

  Authentication() {
    _auth.userChanges().listen((User? user) {
      if (user == null) {
        logInState = LogInState.loggedOut;
      } else
        logInState = LogInState.loggedIn;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("User does not exist");
      } else if (e.code == "") {
        print("wrong-password");
      }
    }
  }

  Future<void> registerAccount(String username, String email, String password) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await cred.user!.updateDisplayName(username);
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        print("Email already exists");
      } else if (e.code == "weak-password") {
        print("Password too weak");
      }
    }
  }

  void signOut() {
    _auth.signOut();
    logInState = LogInState.loggedOut;
  }
}