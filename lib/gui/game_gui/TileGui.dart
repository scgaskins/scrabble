import "package:flutter/material.dart";
import 'package:scrabble/game/Tile.dart';

class TileGui extends StatelessWidget {
  TileGui({Key? key, required this.tile, this.height, this.width}): super(key: key);

  final Tile tile;
  final double? height;
  final double? width;
  final TextStyle _tileStyle = TextStyle(fontSize: 14, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amberAccent,
      height: height,
      width: width,
      child: Column(
        children: [
          Text(
            tile.letter,
            textAlign: TextAlign.center,
            style: _tileStyle,
          ),
          Text(
            tile.letter != " " ? tile.score.toString() : " ",
            style: _tileStyle.apply(fontSizeFactor: 0.6),
          )
        ],
      ),
    );
  }
}
