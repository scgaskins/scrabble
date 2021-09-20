import 'package:scrabble/game/Direction.dart';
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
    if (positionOnBoard(p)) {
      return _board[p.column][p.row];
    }
    return null;
  }

  bool positionOccupied(Position p) {
    Tile? tileAtPos = getTileAtPosition(p);
    return tileAtPos != null;
  }

  bool positionOnBoard(Position p) {
    return p.column >= 0 && p.column < boardSize && p.row >= 0 && p.row < boardSize;
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

  // For a play to be valid, the tiles must either connect to a
  // tile that was placed on a prior turn or pass over the center square
  bool positionsConnectedToBoard(List<Position> positionList) {
    for (Position p in positionList) {
      if (p == centerSquare || _positionBordersPlacedTile(p)) {
        return true;
      }
    }
    return false;
  }

  bool _positionBordersPlacedTile(Position p) {
    for (Direction dir in Direction.values) {
      Position neighbor = p.getNeighbor(dir);
      Tile? neighboringTile = getTileAtPosition(neighbor);
      if (neighboringTile != null && neighboringTile.isPlaced) {
        return true;
      }
    }
    return false;
  }

  bool positionsAreInALine(List<Position> positionList) {
    if (positionList.length > 1) {
      return _positionsAreInHorizontalLine(positionList) || _positionsAreInVerticalLine(positionList);
    }
    return true;
  }

  bool _positionsAreInVerticalLine(List<Position> positionList) {
    for (Position p in positionList) {
      if (!p.inAVerticalLineWith(positionList[0])) {
        return false;
      }
    }
    return true;
  }

  bool _positionsAreInHorizontalLine(List<Position> positionList) {
    for (Position p in positionList) {
      if (!p.inAHorizontalLineWith(positionList[0])) {
        return false;
      }
    }
    return true;
  }

  List<Position> getFullWord(List<Position> positionList) {
    positionList.sort();
    if (_positionsAreInVerticalLine(positionList)) {
      return _getWordOffPosition(positionList[0], Direction.north, Direction.south);
    } else {
      return _getWordOffPosition(positionList[0], Direction.west, Direction.east);
    }
  }

  List<Position> _getWordOffPosition(Position start, Direction up, Direction down) {
    List<Position> beginningPositions = _getOccupiedPositionBeforePosInDir(start, up);
    List<Position> endingPositions = _getOccupiedPositionAfterPosInDir(start, down);
    return beginningPositions + [start] + endingPositions;
  }

  List<Position> _getOccupiedPositionBeforePosInDir(Position start, Direction dir) {
    List<Position> positions = [];
    Position lastPos = start;
    while (true) {
      Position nextPos = lastPos.getNeighbor(dir);
      if (positionOnBoard(nextPos) && positionOccupied(nextPos)) {
        positions.insert(0, nextPos);
        lastPos = nextPos;
      } else {
        return positions;
      }
    }
  }

  List<Position> _getOccupiedPositionAfterPosInDir(Position start, Direction dir) {
    List<Position> positions = [];
    Position lastPos = start;
    while (true) {
      Position nextPos = lastPos.getNeighbor(dir);
      if (positionOnBoard(nextPos) && positionOccupied(nextPos)) {
        positions.add(nextPos);
        lastPos = nextPos;
      } else {
        return positions;
      }
    }
  }
}
