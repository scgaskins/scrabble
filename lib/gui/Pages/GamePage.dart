import 'package:flutter/material.dart';
import 'package:scrabble/gui/game_gui/BoardGui.dart';
import 'package:scrabble/gui/game_gui/PlayerHand.dart';
import 'package:scrabble/gui/game_gui/TileSwapGui.dart';
import 'package:scrabble/utility/Position.dart';
import 'package:scrabble/utility/Pair.dart';
import 'package:scrabble/game/classes/Tile.dart';
import 'package:scrabble/game/classes/Game.dart';
import 'package:scrabble/gui/GeneralUtilities.dart';

class GamePage extends StatefulWidget {
  GamePage({Key? key}): super(key: key);

  final int boardSize = 15;

  @override
  State<StatefulWidget> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Game game = Game();
  List<Position> currentPositions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Game Preview"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _boardGui(),
              _playerHandGui(),
              _submitButton(),
              _passButton(),
              _swapTilesButton()
            ],
          ),
        )
    );
  }

  double _tileSize() =>
      (MediaQuery.of(context).size.width-20) / widget.boardSize;

  BoardGui _boardGui() {
    return BoardGui(
      board: game.board,
      currentPositions: currentPositions,
      boardSize: widget.boardSize,
      tileWidth: _tileSize(),
      tileHeight: _tileSize(),
    );
  }

  PlayerHand _playerHandGui() {
    return PlayerHand(
      playerHand: game.userHand,
      tileHeight: _tileSize(),
      tileWidth: _tileSize(),
    );
  }

  ElevatedButton _submitButton() {
    return ElevatedButton(
        onPressed: _tryToSubmitPlay,
        child: Text("Submit")
    );
  }

  ElevatedButton _passButton() {
    return ElevatedButton(
        onPressed: _passTurn,
        child: Text("Pass")
    );
  }

  ElevatedButton _swapTilesButton() {
    return ElevatedButton(
        onPressed: _showTileSwapDialog,
        child: Text("Swap")
    );
  }
  
  void _tryToSubmitPlay() {
    currentPositions.sort();
    if (_checkPositions()) {
      List<Pair<String, int>> wordsAndScores = game.getWordsAndScoresOffList(currentPositions);
      if (_checkWords(wordsAndScores.map((p) => p.a).toList()))
        _submitWordsAndScores(wordsAndScores);
    }
  }

  void _submitWordsAndScores(List<Pair<String, int>> wordsAndScores) {
    setState(() {
      game.submitPlay(wordsAndScores, currentPositions);
      currentPositions = [];
      _successfulPlayAlert(wordsAndScores);
    });
  }

  bool _checkPositions() {
    if (currentPositions.isEmpty) {
      _invalidPlayAlert("You need to use at least one tile");
      return false;
    } else if (!game.positionsConnectedToBoard(currentPositions)) {
      _invalidPlayAlert("Tiles must play off another word or the center square");
      return false;
    } else if (!game.positionsConnectedToEachOther(currentPositions)) {
      _invalidPlayAlert("Tiles must be in a continuous line");
      return false;
    }
    return true;
  }

  bool _checkWords(List<String> words) {
    List<String> invalidWords = game.findInvalidWords(words);
    if (invalidWords.isNotEmpty) {
      _invalidPlayAlert("These words are not valid: ${_invalidWordString(invalidWords)}");
      return false;
    }
    return true;
  }

  String _invalidWordString(List<String> invalidWords) {
    String invalidWordString = "";
    for (String word in invalidWords)
      invalidWordString += "\n" + word;
    return invalidWordString;
  }

  void _showStatusAlert(String playStatus, content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
         return simpleAlert(context, playStatus, content);
        });
  }

  void _invalidPlayAlert(String message) =>
      _showStatusAlert("Invalid Play", message);

  void _successfulPlayAlert(List<Pair<String, int>> wordsAndScores) {
    String wordAndScoreString = "";
    for (Pair<String, int> pair in wordsAndScores)
      wordAndScoreString += "\n${pair.a}: ${pair.b}";
    _showStatusAlert("Successful Play", "You played: $wordAndScoreString");
  }

  void _passTurn() {
    setState(() {
      game.returnTiles(currentPositions);
      currentPositions = [];
    });
  }

  void _showTileSwapDialog() {
    setState(() => game.returnTiles(currentPositions));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return TileSwapGui(
              playerHand: _playerHandGui(),
              onTilesSubmitted: (List<Tile?> tiles) {
                Navigator.of(context).pop();
                _swapTiles(tiles);
              }
          );
        }
        );
  }

  void _swapTiles(List<Tile?> tilesToSwap) {
    setState(() {
      game.swapTiles(tilesToSwap);
    });
  }
}
