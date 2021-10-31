import "package:flutter/material.dart";
import 'package:scrabble/game/Tile.dart';
import 'package:scrabble/gui/game_gui/TileGui.dart';

class DraggableTile extends StatefulWidget {
  DraggableTile({Key? key, required this.tile}): super(key: key);

  final Tile tile;

  @override
  State<StatefulWidget> createState() => _DraggableTileState();
}

class _DraggableTileState extends State<DraggableTile> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
