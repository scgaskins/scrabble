import 'package:flutter/material.dart';
import 'package:scrabble/utility/Position.dart';
import 'package:scrabble/game/game_data/PremiumSquares.dart';

class BoardSquareGui extends StatelessWidget {
  BoardSquareGui({Key? key, required this.position, this.height, this.width}): super(key: key);

  final Position position;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _getSquareColor(),
      width: width,
      height: height,
      child: Center(
        child: Text(_getSquareText(), textAlign: TextAlign.center,),
      )
    );
  }

  Color _getSquareColor() {
    if (doubleLetterSquares.contains(position)) {
      return Colors.cyanAccent;
    } else if (tripleLetterSquares.contains(position)) {
      return Colors.blue;
    } else if (doubleWordSquares.contains(position)) {
      return Colors.pinkAccent;
    } else if (tripleWordSquares.contains(position)) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  String _getSquareText() {
    if (doubleLetterSquares.contains(position)) {
      return "DL";
    } else if (tripleLetterSquares.contains(position)) {
      return "TL";
    } else if (doubleWordSquares.contains(position)) {
      return "DW";
    } else if (tripleWordSquares.contains(position)) {
      return "TW";
    } else {
      return "";
    }
  }
}
