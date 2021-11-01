import 'package:flutter/material.dart';
import 'package:scrabble/gui/game_gui/BoardSquare.dart';
import 'package:scrabble/gui/game_gui/TileGui.dart';
import 'package:scrabble/gui/game_gui/PlayerHand.dart';
import 'package:scrabble/gui/game_gui/BoardSquareGui.dart';
import 'package:scrabble/utility/Position.dart';
import 'package:scrabble/game/Tile.dart';

class GamePage extends StatefulWidget {
  GamePage({Key? key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    List<Tile?> playersHand = [
      Tile("A"),
      Tile("B"),
      Tile("C"),
      Tile("D"),
      Tile("E"),
      null,
      Tile("F")
    ];
    PlayerHand handGUI = PlayerHand(
      playerHand: playersHand,
      tileWidth: (MediaQuery.of(context).size.width-20) / 15,
      tileHeight: (MediaQuery.of(context).size.width-20) / 15,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Game Preview"),
      ),
        body: Center(
          child: Column(
            children: [
              BoardSquare(
                position: Position(0,0),
                width: (MediaQuery.of(context).size.width-20) / 15,
                height: (MediaQuery.of(context).size.width-20) / 15,
              ),
              BoardSquare(
                position: Position(7,7),
                width: (MediaQuery.of(context).size.width-20) / 15,
                height: (MediaQuery.of(context).size.width-20) / 15,
              ),
              handGUI
            ],
          ),
        )
    );
  }
}
