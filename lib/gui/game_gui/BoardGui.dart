import 'package:flutter/material.dart';
import 'package:scrabble/game/classes/Board.dart';
import 'package:scrabble/game/classes/Tile.dart';
import 'package:scrabble/utility/Position.dart';
import 'package:scrabble/gui/game_gui/BoardSquare.dart';

class BoardGui extends StatefulWidget {
  BoardGui({Key? key,
    required this.board,
    required this.currentPositions,
    required this.boardSize,
    this.tileWidth,
    this.tileHeight
  }): super(key: key);

  final Board board;
  final List<Position> currentPositions;
  final int boardSize;
  final double? tileWidth;
  final double? tileHeight;

  @override
  State<StatefulWidget> createState() => _BoardGuiState();
}

class _BoardGuiState extends State<BoardGui> {
  TextEditingController _setBlankTileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _generateBoardSquares();
  }

  Column _generateBoardSquares() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _generateBoardRows(),
    );
  }

  List<Row> _generateBoardRows() {
    List<Row> rows = [];
    for (int rowIndex=0; rowIndex < widget.boardSize; rowIndex++) {
      rows.add(_generateRow(rowIndex));
    }
    return rows;
  }

  Row _generateRow(int rowIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _generateAllSquaresInRow(rowIndex),
    );
  }

  List<BoardSquare> _generateAllSquaresInRow(int rowIndex) {
    List<BoardSquare> squares = [];
    for (int columnIndex=0; columnIndex<widget.boardSize; columnIndex++) {
      squares.add(_boardSquare(Position(columnIndex, rowIndex)));
    }
    return squares;
  }

  BoardSquare _boardSquare(Position p) {
    return BoardSquare(
      position: p,
      board: widget.board,
      currentPositions: widget.currentPositions,
      setBlankTileController: _setBlankTileController,
      height: widget.tileHeight,
      width: widget.tileWidth,
    );
  }
}
