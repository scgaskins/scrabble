import 'package:flutter/material.dart';
import 'package:scrabble/gui/game_gui/BoardGui.dart';
import 'package:scrabble/gui/game_gui/PlayerHand.dart';
import 'package:scrabble/gui/game_gui/TileSwapGui.dart';
import 'package:scrabble/utility/Position.dart';
import 'package:scrabble/utility/Pair.dart';
import 'package:scrabble/game/classes/Tile.dart';
import 'package:scrabble/game/classes/Game.dart';
import 'package:scrabble/gui/GeneralUtilities.dart';

class GameGui extends StatefulWidget {
  GameGui({Key? key, required this.game, required this.pushGameStateToFirebase}): super(key: key);

  final int boardSize = 15;
  final Game game;
  final Function(Game) pushGameStateToFirebase;

  @override
  State<StatefulWidget> createState() => _GameGuiState();
}

class _GameGuiState extends State<GameGui> {
  List<Position> currentPositions = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _boardGui(),
        _playerHandGui(),
        _submitButton(),
        _passButton(),
        _swapTilesButton()
      ],
    );
  }

  double _tileSize() =>
      (MediaQuery.of(context).size.width) / widget.boardSize;

  BoardGui _boardGui() {
    return BoardGui(
      board: widget.game.board,
      currentPositions: currentPositions,
      boardSize: widget.boardSize,
      tileWidth: _tileSize(),
      tileHeight: _tileSize(),
    );
  }

  PlayerHand _playerHandGui() {
    return PlayerHand(
      playerHand: widget.game.user.hand,
      tileHeight: _tileSize(),
      tileWidth: _tileSize(),
    );
  }

  ElevatedButton _submitButton() {
    return ElevatedButton(
        onPressed: widget.game.isUsersTurn ? _tryToSubmitPlay : () {},
        child: Text("Submit")
    );
  }

  ElevatedButton _passButton() {
    return ElevatedButton(
        onPressed: widget.game.isUsersTurn ? _passTurn : () {},
        child: Text("Pass")
    );
  }

  ElevatedButton _swapTilesButton() {
    return ElevatedButton(
        onPressed: widget.game.isUsersTurn ? _showTileSwapDialog : () {},
        child: Text("Swap")
    );
  }

  void _tryToSubmitPlay() {
    currentPositions.sort();
    if (_checkPositions()) {
      List<Pair<String, int>> wordsAndScores = widget.game.getWordsAndScoresOffList(currentPositions);
      if (_checkWords(wordsAndScores.map((p) => p.a).toList()))
        _submitWordsAndScores(wordsAndScores);
    }
  }

  void _submitWordsAndScores(List<Pair<String, int>> wordsAndScores) {
    setState(() {
      widget.game.submitPlay(wordsAndScores, currentPositions);
      currentPositions = [];
      widget.pushGameStateToFirebase(widget.game);
      _successfulPlayAlert(wordsAndScores);
    });
  }

  bool _checkPositions() {
    if (currentPositions.isEmpty) {
      _invalidPlayAlert("You need to use at least one tile");
      return false;
    } else if (!widget.game.positionsConnectedToBoard(currentPositions)) {
      _invalidPlayAlert("Tiles must play off another word or the center square");
      return false;
    } else if (!widget.game.positionsConnectedToEachOther(currentPositions)) {
      _invalidPlayAlert("Tiles must be in a continuous line");
      return false;
    }
    return true;
  }

  bool _checkWords(List<String> words) {
    List<String> invalidWords = widget.game.findInvalidWords(words);
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
      widget.game.returnTiles(currentPositions);
      currentPositions = [];
      widget.pushGameStateToFirebase(widget.game);
    });
  }

  void _showTileSwapDialog() {
    setState(() {
      widget.game.returnTiles(currentPositions);
      currentPositions = [];
    });
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
      widget.game.swapTiles(tilesToSwap);
      widget.pushGameStateToFirebase(widget.game);
    });
  }
}
