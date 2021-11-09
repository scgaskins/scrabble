import 'package:flutter/material.dart';
import 'package:scrabble/game/classes/Tile.dart';
import 'package:scrabble/gui/game_gui/PlayerHand.dart';

class TileSwapGui extends StatefulWidget {
  TileSwapGui({Key? key, required this.playerHand, required this.onTilesSubmitted}):super(key: key);

  final PlayerHand playerHand;
  final void Function(List<Tile?>) onTilesSubmitted;
  final List<Tile?> _tilesToSwap = List.filled(7, null);

  @override
  State<StatefulWidget> createState() => _TileSwapGuiState();
}

class _TileSwapGuiState extends State<TileSwapGui> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.blueGrey,
      height: widget.playerHand.tileHeight! * 5,
      width: widget.playerHand.tileWidth! * 9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _returnHand(),
          widget.playerHand,
          _swapButton()
        ],
      ),
    );
  }

  PlayerHand _returnHand() {
    return PlayerHand(
      tileWidth: widget.playerHand.tileWidth,
      tileHeight: widget.playerHand.tileHeight,
      playerHand: widget._tilesToSwap,
    );
  }

  ElevatedButton _swapButton() {
    return ElevatedButton(
        onPressed: () => widget.onTilesSubmitted(widget._tilesToSwap),
        child: Text("Swap Tiles")
    );
  }
}
