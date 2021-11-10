import 'package:flutter/material.dart';
import 'package:scrabble/game/classes/Tile.dart';
import 'package:scrabble/gui/game_gui/TileTarget.dart';
import 'package:scrabble/gui/game_gui/DraggableTile.dart';

class HandSquare extends StatefulWidget {
  HandSquare({Key? key, required this.playerHand, required this.index, this.tileWidth, this.tileHeight}): super(key: key);

  final List<Tile?> playerHand;
  final int index;
  final double? tileWidth;
  final double? tileHeight;

  @override
  State<StatefulWidget> createState() => _HandSquareState();
}

class _HandSquareState extends State<HandSquare> {
  @override
  Widget build(BuildContext context) {
    if (_tile != null)
      return _draggableTile();
    else
      return _emptySquare();
  }

  Tile? get _tile => widget.playerHand[widget.index];

  TileTarget _emptySquare() {
    return TileTarget(
        gui: _emptySquareGui(),
        onTileReceived: _receiveTile
    );
  }

  void _receiveTile(Tile? tile) {
    if (tile != null) {
      setState(() {
        tile.resetBlankTile();
        widget.playerHand[widget.index] = tile;
      });
    }
  }

  Container _emptySquareGui() {
    return Container(
      width: widget.tileWidth,
      height: widget.tileHeight,
      color: Colors.grey,
    );
  }

  DraggableTile _draggableTile() {
    return DraggableTile(
      width: widget.tileWidth,
      height: widget.tileHeight,
      tile: _tile!,
      childWhenDragging: _emptySquareGui(),
      onDragCompleted: _removeTileFromSquare
    );
  }

  void _removeTileFromSquare() {
    setState(() {
      widget.playerHand[widget.index] = null;
    });
  }
}
