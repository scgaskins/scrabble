import 'package:flutter/material.dart';
import 'package:scrabble/game/classes/Tile.dart';

class TileTarget extends StatelessWidget {
  TileTarget({Key? key, required this.gui, required this.onTileReceived}): super(key: key);
  
  final Widget gui;
  final void Function(Tile?) onTileReceived;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Tile>(
      builder: (
          BuildContext context,
          List<Tile?> accepted,
          List<dynamic> rejected
          ) => gui,
      onAccept: onTileReceived,
    );
  }
}
