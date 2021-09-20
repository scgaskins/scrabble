import 'package:scrabble/game/Position.dart';
import 'package:scrabble/game/Tile.dart';

class Board {
  final int boardSize = 15;
  final Position centerSquare = Position(8, 8);
  late List<List<Tile?>> _board;

  Board() {
    _board = List.filled(boardSize, List.filled(boardSize, null));
  }

  Tile? getTileAtPosition(Position p) {
    if (p.column >= 0 && p.column < boardSize && p.row >= 0 && p.row < boardSize) {
      return _board[p.column][p.row];
    }
    return null;
  }

  bool positionOccupied(Position p) {
    Tile? tileAtPos = getTileAtPosition(p);
    return tileAtPos != null;
  }

  void addTileToPosition(Tile tile, Position p) {
    if (!positionOccupied(p)) {
      _board[p.column][p.row] = tile;
    }
  }

  Tile? removeTileFromPosition(Position p) {
    Tile? tile = getTileAtPosition(p);
    if (tile != null) {
      _board[p.column][p.row] = null;
      tile.resetBlankTile();
    }
    return tile;
  }

  bool checkWord(List<Position> positionList) {
    if (!positionOccupied(centerSquare)) {
      return false;
    }
    if (!_positionsInALine(positionList)) {
      return false;
    }
    return true;
  }

  bool _positionsInALine(List<Position> positionList) {
    if (positionList.length > 1) {
      return _positionsInHorizontalLine(positionList) || _positionsInVerticalLine(positionList);
    }
    return true;
  }

  bool _positionsInVerticalLine(List<Position> positionList) {
    for (Position p in positionList) {
      if (p.inAVerticalLineWith(positionList[0])) {
        return false;
      }
    }
    return true;
  }

  bool _positionsInHorizontalLine(List<Position> positionList) {
    for (Position p in positionList) {
      if (p.inAHorizontalLineWith(positionList[0])) {
        return false;
      }
    }
    return true;
  }
}
