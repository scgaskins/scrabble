import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scrabble/networking/GameAccess.dart';
import 'package:scrabble/gui/GeneralUtilities.dart';
import 'package:scrabble/gui/game_gui/GameGui.dart';
import 'package:scrabble/game/classes/Game.dart';
import 'package:scrabble/gui/LoadingDialog.dart';

class GamePageArguments {
  final GameAccess gameAccess;

  GamePageArguments(this.gameAccess);
}

class GamePage extends StatefulWidget {
  GamePage({Key? key, required this.gameAccess}): super(key: key);

  final GameAccess gameAccess;

  @override
  State<StatefulWidget> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Game Preview"),
        ),
      body: StreamBuilder(
        stream: widget.gameAccess.gameStream,
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> gameSnap) {
          if (gameSnap.hasData) {
            return StreamBuilder(
                stream: widget.gameAccess.userStream,
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> userSnap) {
                  if (gameSnap.hasError) {
                    return Text('Something went wrong');
                  }

                  if (gameSnap.connectionState == ConnectionState.waiting) {
                    return const Center(child: SizedBox(
                      width: 60,
                      height: 80,
                      child: CircularProgressIndicator(),
                    ));
                  }

                  Game game = widget.gameAccess.getGameStateFromSnapshot(gameSnap.data!);
                  game.user = widget.gameAccess.getPlayerStateFromSnapshot(userSnap.data!);
                  return GameGui(
                    game: game,
                    pushGameStateToFirebase: updateFirebase,
                  );
                }
            );

          }

          if (gameSnap.connectionState == ConnectionState.waiting) {
            return const Center(child: SizedBox(
              width: 60,
              height: 80,
              child: CircularProgressIndicator(),
            ));
          }

          return Text('Something went wrong');
        },
      ),
    );
  }

  void updateFirebase(Game gameState) {
    gameState.endTurn();
    Future pushFuture = widget.gameAccess.updateState(gameState);
    showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {
      return LoadingDialog(
        future: pushFuture,
        successWidget: successfulPushDialog(),
        errorWidget: failedPushDialog(),
      );
    });
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
