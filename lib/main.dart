import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:scrabble/networking/Authentication.dart';
import 'package:scrabble/gui/Pages/Start.dart';
import 'package:scrabble/gui/Pages/RegisterPage.dart';
import 'package:scrabble/gui/Pages/SignInPage.dart';
import 'package:scrabble/gui/Pages/GamePage.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return ErrorPage(errorMessage: "Unable to initialize firebase",);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider(
              create: (context) => Authentication(),
            builder: (context, _) => MyApp(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}

class ErrorPage extends StatefulWidget {
  ErrorPage({Key? key, required this.errorMessage}) : super(key: key);

  final String errorMessage;

  @override
  State createState() => ErrorPageState();
}

class ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(widget.errorMessage, textDirection: TextDirection.ltr,));
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrabble',
      theme: ThemeData(
        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => Consumer<Authentication>(
          builder: (context, authState, _) => Start(logInState: authState.logInState),
        ),
        '/register': (context) => Consumer<Authentication>(
          builder: (context, authState, _) => RegisterPage(signUp: authState.registerAccount),
        ),
        "/signIn": (context) => Consumer<Authentication>(
          builder: (context, authState, _) => SignInPage(signIn: authState.signIn)
        ),
        "/game": (context) => GamePage(),
      },
    );
  }
}

