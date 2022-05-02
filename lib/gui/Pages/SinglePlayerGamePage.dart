import 'package:flutter/material.dart';
import 'package:scrabble/game/classes/SinglePlayerGame.dart';
import 'package:scrabble/gui/game_gui/GameGui.dart';
import 'package:scrabble/gui/game_gui/ScoreListDrawer.dart';
import 'package:scrabble/game/classes/Game.dart';
import 'package:scrabble/utility/Pair.dart';
import 'package:scrabble/networking/User.dart';

class SinglePlayerGamePageArguments {
  final SinglePlayerGame game;
  final Map<String, User> uidsToPlayers;

  SinglePlayerGamePageArguments(this.game, this.uidsToPlayers);
}

class SinglePlayerGamePage extends StatefulWidget {
  SinglePlayerGamePage({Key? key, required this.game, required this.uidsToPlayers}): super(key: key);

  final Map<String, User> uidsToPlayers;
  final SinglePlayerGame game;

  @override
  State<StatefulWidget> createState() => _SinglePlayerGamePageState();
}

class _SinglePlayerGamePageState extends State<SinglePlayerGamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Scrabble"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      endDrawer: ScoreListDrawer(
        game: widget.game,
        uidsToPlayers: widget.uidsToPlayers,
      ),
      body: GameGui(
        game: widget.game,
        uidsToPlayers: widget.uidsToPlayers,
        pushGameStateToFirebase: updateFirebase,
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
        title: Text("Scrabble")
    );
  }

  Future<bool> updateFirebase(Game gameState) async {
    gameState.endTurn();
    List<Pair<String, int>> wordsAndScores = widget.game.computerPlayer.makeMove();
    gameState.updateScores(wordsAndScores.map((e) => e.b).toList());
    widget.game.fillComputerHand();
    gameState.endTurn();
    return true;
  }
}
