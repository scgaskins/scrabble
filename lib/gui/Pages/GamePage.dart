import 'package:flutter/material.dart';
import 'package:scrabble/gui/game_gui/TileGui.dart';
import 'package:scrabble/game/Tile.dart';

class GamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TileGui(
        tile: Tile("A"),
        height: (MediaQuery.of(context).size.width-20) / 15,
        width: (MediaQuery.of(context).size.width-20) / 15,
      ),
    );
  }
}
