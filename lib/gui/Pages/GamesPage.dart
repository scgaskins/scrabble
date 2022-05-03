import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrabble/ai/Dawg.dart';
import 'package:scrabble/game/classes/SinglePlayerGame.dart';
import 'package:scrabble/game/game_data/ValidWords.dart';
import 'package:scrabble/networking/FriendAccess.dart';
import 'package:scrabble/networking/GameListAccess.dart';
import 'package:scrabble/gui/GameList.dart';
import 'package:scrabble/gui/Pages/CreateGamePage.dart';
import 'package:scrabble/gui/Pages/SinglePlayerGamePage.dart';
import 'package:scrabble/networking/User.dart';
import 'package:scrabble/ai/heuristics/HighestScore.dart';
import 'package:scrabble/ai/heuristics/AvoidGivingOpenings.dart';

class GamesPage extends StatefulWidget {
  GamesPage({Key? key, required this.userName, required this.uid, required this.database, required this.gameListAccess}): super(key: key);

  final String uid;
  final String userName;
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
          showDialog(context: context, builder: (BuildContext context) {
            return SimpleDialog(
              title: const Text("Start a Single or Multi Player Game?"),
              children: [
                SimpleDialogOption(
                  onPressed: goToCreateGamesPage,
                  child: Text("Multi Player")
                ),
                SimpleDialogOption(
                  onPressed: makeSinglePlayerGame,
                  child: Text("Single Player"),
                )
              ],
            );
          });
        },
      ),
    );
  }

  void goToCreateGamesPage() {
    Navigator.pushNamed(context, "/createGame",
        arguments: CreateGamePageArguments(
            widget.uid,
            FriendAccess(widget.database, widget.uid),
            widget.gameListAccess
        )
    );
  }

  void makeSinglePlayerGame() {
    Dawg dawg = Dawg(validWords.toList());
    SinglePlayerGame game = SinglePlayerGame(widget.uid, "COMPUTER_PLAYER", dawg, highestScore);
    Map<String, User> uidsToPlayers = {
      //widget.uid: User(widget.userName, ""),
      "COMPUTER_PLAYER": User("computer", "")
    };
    Navigator.pushNamed(context, "/singlePlayerGame",
      arguments: SinglePlayerGamePageArguments(game, uidsToPlayers)
    );
  }
}
