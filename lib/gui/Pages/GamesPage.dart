import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrabble/networking/FriendAccess.dart';
import 'package:scrabble/networking/GameListAccess.dart';
import 'package:scrabble/gui/GameList.dart';
import 'package:scrabble/gui/Pages/CreateGamePage.dart';

class GamesPage extends StatefulWidget {
  GamesPage({Key? key, required this.uid, required this.database, required this.gameListAccess}): super(key: key);

  final String uid;
  final FirebaseFirestore database;
  final GameListAccess gameListAccess;

  @override
  State<StatefulWidget> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameList(
        gameListAccess: widget.gameListAccess,
        uid: widget.uid,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: "Start a game",
        onPressed: () {
          Navigator.pushNamed(context, "/createGame",
              arguments: CreateGamePageArguments(
                  widget.uid,
                  FriendAccess(widget.database, widget.uid),
                  widget.gameListAccess
              )
          );
        },
      ),
    );
  }
}
