import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum LogInState { loggedIn, loggedOut }

class Authentication extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  LogInState? _logInState;
  String? _displayName;
  String? _userId;

  Authentication() {
    _auth.userChanges().listen((User? user) {
      if (user == null) {
        _logInState = LogInState.loggedOut;
      } else {
        _logInState = LogInState.loggedIn;
        _displayName = user.displayName;
        _userId = user.uid;
      }
      notifyListeners();
    });
  }

  LogInState? get logInState => _logInState;
  String? get displayName => _displayName;
  String? get userId => _userId;

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
      User user = cred.user!;
      await user.updateDisplayName(username);
      await _addUserToDatabase(user, username, email);
      return true;
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
      return false;
    }
  }

  Future<void> _addUserToDatabase(User user, String username, String email) async {
    CollectionReference users = FirebaseFirestore.instance.collection("users");
    await users.doc(user.uid).set({
      "username": username,
      "email": email
    })
    .catchError((e) => print("Error adding user: $e"));
  }

  void signOut() {
    _auth.signOut();
    _logInState = LogInState.loggedOut;
  }
}