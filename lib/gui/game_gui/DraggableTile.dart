import "package:flutter/material.dart";
import 'package:scrabble/game/Tile.dart';
import 'package:scrabble/gui/game_gui/TileGui.dart';

class DraggableTile extends StatefulWidget {
  DraggableTile({Key? key, required this.tile, this.width, this.height, this.childWhenDragging}): super(key: key);

  final Tile tile;
  final double? width;
  final double? height;
  final Widget? childWhenDragging;

  @override
  State<StatefulWidget> createState() => _DraggableTileState();
}

class _DraggableTileState extends State<DraggableTile> {
  @override
  Widget build(BuildContext context) {
    return Draggable(
      data: widget.tile,
      child: _tileGui(),
      feedback: _tileGui(),
      childWhenDragging: widget.childWhenDragging,
    );
  }

  TileGui _tileGui() {
    return TileGui(
      tile: widget.tile,
      height: widget.height,
      width: widget.width,
    );
  }
}
