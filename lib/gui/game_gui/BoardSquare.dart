import 'package:flutter/material.dart';
import 'package:scrabble/utility/Position.dart';
import 'package:scrabble/game/classes/Tile.dart';
import 'package:scrabble/game/classes/Board.dart';
import 'package:scrabble/gui/game_gui/BoardSquareGui.dart';
import 'package:scrabble/gui/game_gui/TileGui.dart';
import 'package:scrabble/gui/game_gui/DraggableTile.dart';
import 'package:scrabble/gui/game_gui/TileTarget.dart';

class BoardSquare extends StatefulWidget {
  BoardSquare({Key? key,
    required this.position,
    required this.board,
    required this.currentPositions,
    required this.setBlankTileController,
    this.width,
    this.height,
  }): super(key: key);

  final Position position;
  final Board board;
  final List<Position> currentPositions; // All the board positions with tiles that aren't locked yet
  final TextEditingController setBlankTileController;
  final double? width;
  final double? height;

  @override
  State<StatefulWidget> createState() => _BoardSquareState();
}

class _BoardSquareState extends State<BoardSquare> {
  GlobalKey<FormState> _setBlankTileFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (_tile == null) {
      return _tileTarget();
    } else if (!_tile!.isLocked) {
      return _draggableTile();
    } else {
      return _staticTile();
    }
  }

  Tile? get _tile => widget.board.getTileAtPosition(widget.position);

  TileTarget _tileTarget() {
    return TileTarget(
      gui: _boardSquareGui(),
      onTileReceived: _receiveTile,
    );
  }

  void _receiveTile(Tile? tile) {
    setState(() {
      print(tile);
      if (tile != null) {
        widget.board.addTileToPosition(tile, widget.position);
        if (!_tile!.letterIsLocked)
          _showSetBlankTileDialog();
        widget.currentPositions.add(widget.position);
        print(widget.board);
      }
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
      tile: _tile!,
      width: widget.width,
      height: widget.height,
      childWhenDragging: _boardSquareGui(),
      onDragCompleted: _removeTileFromSquare,
    );
  }

  void _removeTileFromSquare() {
    setState(() {
      widget.board.removeTileFromPosition(widget.position);
      widget.currentPositions.remove(widget.position);
      print(widget.currentPositions);
    });
  }

  TileGui _staticTile() {
    return TileGui(
      tile: _tile!,
      height: widget.height,
      width: widget.width,
    );
  }


  void _showSetBlankTileDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return SimpleDialog(
            title: Text("Select a letter for the blank tile"),
            children: [
              _blankTileSetForm()
            ],
          );
        });
  }

  Form _blankTileSetForm() {
    return Form(
      key: _setBlankTileFormKey,
      child: Column(
        children: [
          _blankTileSetFormField(),
          ElevatedButton(
            child: Text("Submit"),
            onPressed: () {
              print(_setBlankTileFormKey.currentState);
              print(widget.board);
              if (_setBlankTileFormKey.currentState!.validate()) {
                setState(() {
                  _tile!.setBlankTile(widget.setBlankTileController.text);
                });
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
    );
  }

  TextFormField _blankTileSetFormField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Enter a letter",
        border: OutlineInputBorder(),
      ),
      controller: widget.setBlankTileController,
      validator: (String? value) {
        if (value == null || value.length != 1 || !value.toUpperCase().contains(RegExp("[A-Z]")))
          return "Please enter a single letter";
      },
    );
  }
}
