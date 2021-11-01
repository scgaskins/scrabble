import 'package:flutter/material.dart';
import 'package:scrabble/utility/Position.dart';
import 'package:scrabble/game/Tile.dart';
import 'package:scrabble/gui/game_gui/BoardSquareGui.dart';
import 'package:scrabble/gui/game_gui/TileGui.dart';
import 'package:scrabble/gui/game_gui/DraggableTile.dart';
import 'package:scrabble/gui/game_gui/TileTarget.dart';

class BoardSquare extends StatefulWidget {
  BoardSquare({Key? key, required this.position, this.width, this.height,}): super(key: key);

  final Position position;
  final double? width;
  final double? height;

  @override
  State<StatefulWidget> createState() => _BoardSquareState();
}

class _BoardSquareState extends State<BoardSquare> {
  Tile? tile;

  @override
  Widget build(BuildContext context) {
    if (tile == null) {
      return _tileTarget();
    } else if (!tile!.isLocked) {
      return _draggableTile();
    } else {
      return _staticTile();
    }
  }

  TileTarget _tileTarget() {
    return TileTarget(
      gui: _boardSquareGui(),
      onTileReceived: _receiveTile,
    );
  }

  void _receiveTile(Tile? tile) {
    setState(() {
      this.tile = tile;
    });
  }

  BoardSquareGui _boardSquareGui() {
    return BoardSquareGui(
      position: widget.position,
      width: widget.width,
      height: widget.height,
    );
  }

  DraggableTile _draggableTile() {
    return DraggableTile(
      tile: tile!,
      width: widget.width,
      height: widget.height,
      childWhenDragging: _boardSquareGui(),
      onDragCompleted: _removeTileFromSquare,
    );
  }

  void _removeTileFromSquare() {
    setState(() {
      tile = null;
    });
  }

  TileGui _staticTile() {
    return TileGui(
      tile: tile!,
      height: widget.height,
      width: widget.width,
    );
  }
}
