import 'package:scrabble/game/Direction.dart';
import 'package:scrabble/game/Position.dart';
import 'package:scrabble/game/Tile.dart';
import 'package:scrabble/game/PremiumSquares.dart';

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
    if (isPositionOnBoard(p)) {
      return _board[p.column][p.row];
    }
    if (p.column >= boardSize || p.column < 0) {
      throw IndexError(p.column, _board);
    }
    else if (p.row >= boardSize || p.row < 0) {
      throw IndexError(p.row, _board[p.column]);
    }
  }

  bool isPositionOnBoard(Position p) {
    return p.column >= 0 && p.column < boardSize && p.row >= 0 && p.row < boardSize;
  }

  bool isPositionOccupied(Position p) {
    Tile? tileAtPos = getTileAtPosition(p);
    return tileAtPos != null;
  }

  void addTileToPosition(Tile tile, Position p) {
    if (!isPositionOccupied(p)) {
      _board[p.column][p.row] = tile;
    }
  }

  Tile? removeTileFromPosition(Position p) {
    Tile? tile = getTileAtPosition(p);
    if (tile != null) {
      if (!tile.isLocked) {
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
      if (p == centerSquare || _positionBordersLockedTile(p))
        return true;
    }
    return false;
  }

  bool _positionBordersLockedTile(Position p) {
    for (Direction dir in Direction.values) {
      Position neighbor = p.getNeighbor(dir);
      if (isPositionOnBoard(neighbor)) {
        Tile? neighboringTile = getTileAtPosition(neighbor);
        if (neighboringTile != null && neighboringTile.isLocked)
          return true;
      }
    }
    return false;
  }

  // Checks if the list runs from up to down
  bool _positionListRunsInDirection(List<Position> positionList, Direction up, Direction down) {
    if (positionList.length > 1)
      return positionList[0].inALineThruDirectionWith(positionList[1], down);
    Position p = positionList.first;
    return _positionHasOccupiedNeighborInDirection(p, up) ||
        _positionHasOccupiedNeighborInDirection(p, down);
  }

  bool _positionHasOccupiedNeighborInDirection(Position pos, Direction dir) {
    Position neighbor = pos.getNeighbor(dir);
    return isPositionOnBoard(neighbor) && isPositionOccupied(neighbor);
  }

  bool positionsConnectedToEachOther(List<Position> positionList) {
    if (positionsAreInALine(positionList)) {
      List<Position> fullListToEnd;
      if (_positionListRunsInDirection(positionList, Direction.north, Direction.south))
        fullListToEnd = _getOccupiedPositionAfterPosInDir(positionList[0], Direction.south);
      else
        fullListToEnd = _getOccupiedPositionAfterPosInDir(positionList[0], Direction.east);
      return fullListToEnd.contains(positionList.last);
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
      if (!p.inALineThruDirectionWith(positionList[0], Direction.south))
        return false;
    }
    return true;
  }

  bool _positionsAreInHorizontalLine(List<Position> positionList) {
    for (int i=1; i<positionList.length; i++) {
      Position p = positionList[i];
      if (!p.inALineThruDirectionWith(positionList[0], Direction.east))
        return false;
    }
    return true;
  }

  List<Position> _getWordPositionsOffPosition(Position start, Direction up, Direction down) {
    List<Position> beginningPositions = _getOccupiedPositionBeforePosInDir(start, up);
    List<Position> endingPositions = _getOccupiedPositionAfterPosInDir(start, down);
    return beginningPositions + [start] + endingPositions;
  }

  List<Position> _getOccupiedPositionBeforePosInDir(Position start, Direction dir) {
    List<Position> positions = [];
    Position lastPos = start;
    while (true) {
      Position nextPos = lastPos.getNeighbor(dir);
      if (isPositionOnBoard(nextPos) && isPositionOccupied(nextPos)) {
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
      if (isPositionOnBoard(nextPos) && isPositionOccupied(nextPos)) {
        positions.add(nextPos);
        lastPos = nextPos;
      } else {
        return positions;
      }
    }
  }
  
  Map<String, int> getAllIntersectingWordsAndScores(List<Position> positionList) {
    if (_positionListRunsInDirection(positionList, Direction.north, Direction.south))
      return _getAllWordsAndScores(positionList, Direction.north, Direction.south, Direction.west, Direction.east);
    else
      return _getAllWordsAndScores(positionList, Direction.west, Direction.east, Direction.north, Direction.south);
  }
  
  Map<String, int> _getAllWordsAndScores(List<Position> positionList, Direction up, Direction down, Direction left, Direction right) {
    List<MapEntry<String, int>> wordsAndScores = [];
    List<Position> initialWordPositions = _getWordPositionsOffPosition(positionList.first, up, down);
    wordsAndScores.add(_getWordAndScoreFromPositionList(initialWordPositions));
    for (Position pos in initialWordPositions) {
      List<Position> intersectingWordPositions = _getWordPositionsOffPosition(pos, left, right);
      wordsAndScores.add(_getWordAndScoreFromPositionList(intersectingWordPositions));
    }
    return Map.fromEntries(wordsAndScores);
  }

  MapEntry<String, int> _getWordAndScoreFromPositionList(List<Position> wordPositions) {
    String word = "";
    int score = 0;
    bool doubleWord = false;
    bool tripleWord = false;
    for (Position pos in wordPositions) {
      Tile tile = getTileAtPosition(pos)!;
      word += tile.letter;
      score += _calculateTileScore(pos, tile);
      if (doubleWordSquares.contains(pos))
        doubleWord = true;
      else if (tripleWordSquares.contains(pos))
        tripleWord = true;
    }
    if (doubleWord)
      score *= 2;
    if (tripleWord)
      score *= 3;
    return MapEntry(word, score);
  }

  int _calculateTileScore(Position tilePos, Tile tile) {
    if (!tile.isLocked) { // Premium letter squares only apply to newly placed tiles
      if (doubleLetterSquares.contains(tilePos))
        return tile.score * 3;
      if (tripleLetterSquares.contains(tilePos))
        return tile.score * 2;
    }
    return tile.score;
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
