import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scrabble/networking/GameAccess.dart';
import 'package:scrabble/gui/game_gui/GameGui.dart';
import 'package:scrabble/gui/game_gui/ScoreListDrawer.dart';
import 'package:scrabble/game/classes/Game.dart';
import 'package:scrabble/gui/LoadingDialog.dart';
import 'package:scrabble/utility/Pair.dart';
import 'package:scrabble/networking/User.dart';

class GamePageArguments {
  final GameAccess gameAccess;
  final Map<String, User> uidsToPlayers;

  GamePageArguments(this.gameAccess, this.uidsToPlayers);
}

class GamePage extends StatefulWidget {
  GamePage({Key? key, required this.gameAccess, required this.uidsToPlayers}): super(key: key);

  final GameAccess gameAccess;
  final Map<String, User> uidsToPlayers;

  @override
  State<StatefulWidget> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.gameAccess.gameAndUserStream,
        builder: (BuildContext context, AsyncSnapshot<Pair<DocumentSnapshot, DocumentSnapshot>> gameAndUserSnap) {
          if (gameAndUserSnap.hasData) {
            DocumentSnapshot gameSnap = gameAndUserSnap.data!.a;
            DocumentSnapshot userSnap = gameAndUserSnap.data!.b;
            Game game = widget.gameAccess.getGameStateFromSnapshot(gameSnap);
            game.user = widget.gameAccess.getPlayerStateFromSnapshot(userSnap);
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: Text("Game Preview"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              endDrawer: ScoreListDrawer(
                game: game,
                uidsToPlayers: widget.uidsToPlayers,
              ),
              body: GameGui(
                game: game,
                uidsToPlayers: widget.uidsToPlayers,
                pushGameStateToFirebase: updateFirebase,
              ),
            );
          }

          if (gameAndUserSnap.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: appBar(),
              body: const Center(child: SizedBox(
                width: 60,
                height: 80,
                child: CircularProgressIndicator(),
              )),
            );
          }

          return Scaffold(
            appBar: appBar(),
            body: Text("Something went wrong"),
          );
        }
    );
  }

  AppBar appBar() {
    return AppBar(
        title: Text("Game Preview")
    );
  }

  Future<bool> updateFirebase(Game gameState) async {
    gameState.endTurn();
    Future pushFuture = widget.gameAccess.updateState(gameState);
    showLoadingDialog(pushFuture);
    return pushFuture
        .then((_) => true) // if the push completes successfully
        .onError((_, __) => false); // if there is an error
  }

  void showLoadingDialog(Future uploadFuture) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => LoadingDialog(
          future: uploadFuture,
          successWidget: successfulPushDialog(),
          errorWidget: failedPushDialog(),
        )
    );
  }

  AlertDialog failedPushDialog() {
    return AlertDialog(
      title: Text("Could Not Submit Turn"),
      content: Text("Try again later"),
      actions: [
        SimpleDialogOption(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {});
          },
        )
      ],
    );
  }

  AlertDialog successfulPushDialog() {
    return AlertDialog(
      title: Text("Turn Submitted Successfully"),
      actions: [
        SimpleDialogOption(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {});
          },
        )
      ],
    );
  }
}
