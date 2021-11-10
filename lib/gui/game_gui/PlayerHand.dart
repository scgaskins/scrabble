import 'package:flutter/material.dart';
import 'package:scrabble/game/classes/Tile.dart';
import 'package:scrabble/gui/game_gui/HandSquare.dart';

class PlayerHand extends StatelessWidget {
  PlayerHand({Key? key, required this.playerHand, this.tileWidth, this.tileHeight}): super(key: key);

  final List<Tile?> playerHand;
  final double? tileWidth;
  final double? tileHeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _squaresOfHand(),
    );
  }

  List<Widget> _squaresOfHand() {
    List<Widget> squares = [];
    for (int i=0; i<playerHand.length; i++) {
      squares.add(_handSquare(i));
    }
    return squares;
  }

  HandSquare _handSquare(int index) {
    return HandSquare(
        tileWidth: tileWidth,
        tileHeight: tileHeight,
        playerHand: playerHand,
        index: index
    );
  }
}
