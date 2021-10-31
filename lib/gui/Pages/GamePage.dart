import 'package:flutter/material.dart';
import 'package:scrabble/gui/game_gui/TileGui.dart';
import 'package:scrabble/gui/game_gui/DraggableTile.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Game Preview"),
      ),
        body: Center(
          child: BoardSquareGui(
            position: Position(2,1),
            height: (MediaQuery.of(context).size.width-20) / 15,
            width: (MediaQuery.of(context).size.width-20) / 15,
          ),
        )
    );
  }
}
