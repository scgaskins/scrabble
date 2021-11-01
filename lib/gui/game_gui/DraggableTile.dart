import "package:flutter/material.dart";
import 'package:scrabble/game/Tile.dart';
import 'package:scrabble/gui/game_gui/TileGui.dart';

class DraggableTile extends StatelessWidget {
  DraggableTile({Key? key, required this.tile, this.width, this.height, this.childWhenDragging, required this.onDragCompleted}): super(key: key);

  final Tile tile;
  final double? width;
  final double? height;
  final Widget? childWhenDragging;
  final void Function() onDragCompleted;

  @override
  Widget build(BuildContext context) {
    return Draggable<Tile>(
      data: tile,
      child: _tileGui(),
      feedback: _tileGui(),
      childWhenDragging: childWhenDragging,
      onDragCompleted: onDragCompleted,
    );
  }

  TileGui _tileGui() {
    return TileGui(
      tile: tile,
      height: height,
      width: width,
    );
  }
}
