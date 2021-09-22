import 'package:scrabble/game/Direction.dart';
import 'package:scrabble/game/Position.dart';
import 'package:scrabble/game/Tile.dart';

class Board {
  final int boardSize = 15;
  final Position centerSquare = Position(7, 7);
  late List<List<Tile?>> _board;

  Board() {
    _board = List.generate(boardSize, (index) {
      List<Tile?> column = List.filled(boardSize, null);
      return column;
    });
  }

  Tile? getTileAtPosition(Position p) {
    if (positionOnBoard(p)) {
      return _board[p.column][p.row];
    }
    if (p.column >= boardSize || p.column < 0) {
      throw IndexError(p.column, _board);
    }
    else if (p.row >= boardSize || p.row < 0) {
      throw IndexError(p.row, _board[p.column]);
    }
  }

  bool positionOnBoard(Position p) {
    return p.column >= 0 && p.column < boardSize && p.row >= 0 && p.row < boardSize;
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
      if (!tile.isPlaced) {
        _board[p.column][p.row] = null;
        tile.resetBlankTile();
      } else return null;
    }
    return tile;
  }

  void lockTiles(List<Position> positionList) {
    for (Position pos in positionList) {
      Tile? tile = getTileAtPosition(pos);
      if (tile != null) {
        tile.lockTile();
      }
    }
  }

  // For a play to be valid, the tiles must either connect to a
  // tile that was placed on a prior turn or pass over the center square
  bool positionsConnectedToBoard(List<Position> positionList) {
    for (Position p in positionList) {
      if (p == centerSquare || _positionBordersLockedTile(p)) {
        return true;
      }
    }
    return false;
  }

  bool _positionBordersLockedTile(Position p) {
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
    for (int i=1; i<positionList.length; i++) {
      Position p = positionList[i];
      if (!p.inAVerticalLineWith(positionList[0]))
        return false;
    }
    return true;
  }

  bool _positionsAreInHorizontalLine(List<Position> positionList) {
    for (int i=1; i<positionList.length; i++) {
      Position p = positionList[i];
      if (!p.inAHorizontalLineWith(positionList[0]))
        return false;
    }
    return true;
  }

  List<Position> getFullWord(List<Position> positionList) {
    positionList.sort();
    List<Position> fullWord;
    if (_positionsAreInVerticalLine(positionList)) {
      fullWord = _getWordOffPosition(positionList[0], Direction.north, Direction.south);
    } else {
      fullWord = _getWordOffPosition(positionList[0], Direction.west, Direction.east);
    }
    assert(fullWord.contains(positionList.last), "All tiles from initial list must be in final");
    return fullWord;
  }

  List<Position> _getWordOffPosition(Position start, Direction up, Direction down) {
    List<Position> beginningPositions = _getOccupiedPositionBeforePosInDir(start, up);
    List<Position> endingPositions = _getOccupiedPositionAfterPosInDir(start, down);
    return beginningPositions + [start] + endingPositions;
  }

  List<Position> _getOccupiedPositionBeforePosInDir(Position start, Direction dir) {
    /*Position nextPos = start.getNeighbor(dir);
    if (!positionOnBoard(nextPos) || !positionOccupied(nextPos)) {
      return [];
    } else {
      return _getOccupiedPositionBeforePosInDir(nextPos.getNeighbor(dir), dir) + [nextPos];
    }*/
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

  @override
  String toString() {
    String boardString = "";
    for (int row=0; row<boardSize; row++) {
      String rowString = _rowToString(row);
      boardString += rowString + "\n";
    }
    return boardString;
  }

  String _rowToString(int rowIndex) {
    String rowString = "";
    for (int col=0; col<boardSize; col++) {
      rowString += _positionToString(col, rowIndex);
      rowString += "  ";
    }
    return rowString;
  }

  String _positionToString(int col, int row) {
    Tile? tile = _board[col][row];
    if (tile != null) {
      if (tile.score == 0) {
        return tile.letter.toLowerCase();
      } else {
        return tile.letter;
      }
    } else {
      return "*";
    }
  }
}
