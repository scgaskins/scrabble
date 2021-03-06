import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:scrabble/networking/Authentication.dart';
import 'package:scrabble/gui/Pages/Start.dart';
import 'package:scrabble/gui/Pages/RegisterPage.dart';
import 'package:scrabble/gui/Pages/SignInPage.dart';
import 'package:scrabble/gui/Pages/GamePage.dart';
import 'package:scrabble/gui/Pages/CreateGamePage.dart';
import 'package:scrabble/gui/Pages/SinglePlayerGamePage.dart';

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
      home: Consumer<Authentication>(
        builder: (context, authState, _) => Start(logInState: authState.logInState),
      ),
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == "/register") {
          return MaterialPageRoute(builder: (context) => Consumer<Authentication>(
            builder: (context, authState, _) => RegisterPage(signUp: authState.registerAccount),
          ));
        } else if (settings.name == "/signIn") {
          return MaterialPageRoute(builder: (context) => Consumer<Authentication>(
              builder: (context, authState, _) => SignInPage(signIn: authState.signIn)
          ));
        } else if (settings.name == "/createGame") {
          final args = settings.arguments as CreateGamePageArguments;
          return MaterialPageRoute(builder: (context) => CreateGamePage(
              uid: args.uid,
              gameListAccess: args.gameListAccess,
              friendAccess: args.friendAccess
          ));
        } else if (settings.name == "/game") {
          final args = settings.arguments as GamePageArguments;
          return MaterialPageRoute(builder: (context) => GamePage(
            gameAccess: args.gameAccess,
            uidsToPlayers: args.uidsToPlayers,
          ));
        } else if (settings.name == "/singlePlayerGame") {
          final args = settings.arguments as SinglePlayerGamePageArguments;
          return MaterialPageRoute(builder: (context) => SinglePlayerGamePage(
              game: args.game,
              uidsToPlayers: args.uidsToPlayers
          ));
        }
        },
    );
  }
}

