import 'package:flutter/material.dart';
import 'package:scrabble/game/Tile.dart';
import 'package:scrabble/gui/game_gui/TileTarget.dart';
import 'package:scrabble/gui/game_gui/DraggableTile.dart';

class PlayerHand extends StatefulWidget {
  PlayerHand({Key? key, required this.playerHand, this.tileWidth, this.tileHeight}): super(key: key);

  final List<Tile?> playerHand;
  final double? tileWidth;
  final double? tileHeight;

  @override
  State<StatefulWidget> createState() => _PlayerHandState();
}

class _PlayerHandState extends State<PlayerHand> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: _squaresOfHand(),
    );
  }

  List<Widget> _squaresOfHand() {
    List<Widget> squares = [];
    for (int i=0; i<widget.playerHand.length; i++) {
      Tile? tile = widget.playerHand[i];
      if (tile == null) {
        squares.add(_emptySquare(i));
      } else {
        squares.add(_draggableTile(tile, i));
      }
    }
    return squares;
  }

  TileTarget _emptySquare(int index) {
    return TileTarget(
        gui: _emptySquareGui(),
        onTileReceived: (Tile? tile) {
          setState(() {
            widget.playerHand[index] = tile;
          });
        }
    );
  }

  Container _emptySquareGui() {
    return Container(
      width: widget.tileWidth,
      height: widget.tileHeight,
      color: Colors.grey,
    );
  }

  DraggableTile _draggableTile(Tile tile, int index) {
    return DraggableTile(
      width: widget.tileWidth,
      height: widget.tileHeight,
      tile: tile,
      childWhenDragging: _emptySquareGui(),
      onDragCompleted: () {
        setState(() {
          widget.playerHand[index] = null;
        });
      },
    );
  }
}
