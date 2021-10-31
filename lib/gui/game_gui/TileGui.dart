import "package:flutter/material.dart";
import 'package:scrabble/game/Tile.dart';

class TileGui extends StatelessWidget {
  TileGui({Key? key, required this.tile, this.height, this.width}): super(key: key);

  final Tile tile;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    print(tile.score.toString());
    return Container(
      color: Colors.amberAccent,
      height: height,
      width: width,
      child: Column(
        children: [
          Text(
            tile.letter,
            textAlign: TextAlign.center,
          ),
          Text(
            tile.letter != " " ? tile.score.toString() : " ",
            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.6),
          )
        ],
      ),
    );
  }
}
