import 'package:flutter/material.dart';
import 'package:scrabble/gui/game_gui/BoardGui.dart';
import 'package:scrabble/gui/game_gui/PlayerHand.dart';
import 'package:scrabble/utility/Position.dart';
import 'package:scrabble/game/classes/Tile.dart';
import 'package:scrabble/game/classes/Board.dart';

class GamePage extends StatefulWidget {
  GamePage({Key? key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<Tile?> playersHand = [
    Tile("A"),
    Tile("B"),
    Tile("C"),
    Tile("D"),
    Tile("E"),
    null,
    Tile(" ")
  ];

  @override
  Widget build(BuildContext context) {
    PlayerHand handGUI = PlayerHand(
      playerHand: playersHand,
      tileWidth: (MediaQuery.of(context).size.width-20) / 15,
      tileHeight: (MediaQuery.of(context).size.width-20) / 15,
    );
    Board b = Board();
    List<Position> currentPositions = [];
    BoardGui boardGui = BoardGui(
      board: b,
      currentPositions: currentPositions,
      boardSize: 15,
      tileHeight: (MediaQuery.of(context).size.width-20) / 15,
      tileWidth: (MediaQuery.of(context).size.width-20) / 15,
    );
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Game Preview"),
        ),
        body: Center(
          child: Column(
            children: [
              boardGui,
              handGUI
            ],
          ),
        )
    );
  }
}
