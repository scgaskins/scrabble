import 'package:flutter/material.dart';
import 'package:scrabble/utility/Position.dart';
import 'package:scrabble/game/Tile.dart';

class BoardSquare extends StatefulWidget {
  BoardSquare({Key? key, required this.position}): super(key: key);

  final Position position;

  @override
  State<StatefulWidget> createState() => _BoardSquareState();
}

class _BoardSquareState extends State<BoardSquare> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
