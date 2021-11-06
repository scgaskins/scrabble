import 'package:scrabble/utility/Direction.dart';
import 'package:scrabble/utility/Position.dart';
import 'Tile.dart';
import 'package:scrabble/game/game_data/PremiumSquares.dart';
import 'package:scrabble/utility/Pair.dart';

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
      } else throw Exception("The tile at $p is locked in place");
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

  // A valid play requires that the new tiles placed on the board
  // are part of a continuous line that runs horizontally or diagonally
  bool positionsConnectedToEachOther(List<Position> positionList) {
    if (positionList.length == 1)
      return true;
    if (positionsAreInALine(positionList)) {
      List<Position> fullListToEnd;
      if (_positionListRunsInDirection(positionList, Direction.north, Direction.south))
        fullListToEnd = _getOccupiedPositionsAfterPosInDir(positionList[0], Direction.south);
      else
        fullListToEnd = _getOccupiedPositionsAfterPosInDir(positionList[0], Direction.east);
      return fullListToEnd.contains(positionList.last);
    }
    return false;
  }

  bool positionsAreInALine(List<Position> positionList) {
    if (positionList.length > 1) {
      return _positionsInALineThruDirection(positionList, Direction.south) || _positionsInALineThruDirection(positionList, Direction.east);
    }
    return true;
  }

  bool _positionsInALineThruDirection(List<Position> positionList, Direction dir) {
    for (int i=1; i<positionList.length; i++) {
      Position p = positionList[i];
      if (!p.inALineThruDirectionWith(positionList[0], dir))
        return false;
    }
    return true;
  }

  List<Position> _getWordPositionsOffPosition(Position start, Direction up, Direction down) {
    List<Position> beginningPositions = _getOccupiedPositionBeforePosInDir(start, up);
    List<Position> endingPositions = _getOccupiedPositionsAfterPosInDir(start, down);
    return beginningPositions + [start] + endingPositions;
  }

  List<Position> _getOccupiedPositionBeforePosInDir(Position start, Direction dir) {
    List<Position> positions = [];
    for (Position pos=start.getNeighbor(dir); isPositionOnBoard(pos) && isPositionOccupied(pos); pos=pos.getNeighbor(dir))
      positions.insert(0, pos);
    return positions;
  }

  List<Position> _getOccupiedPositionsAfterPosInDir(Position start, Direction dir) {
    List<Position> positions = [];
    for (Position pos=start.getNeighbor(dir); isPositionOnBoard(pos) && isPositionOccupied(pos); pos=pos.getNeighbor(dir))
      positions.add(pos);
    return positions;
  }
  
  List<Pair<String, int>> getWordsAndScoresOffList(List<Position> positionList) {
    if (_positionListRunsInDirection(positionList, Direction.north, Direction.south))
      return _getAllNewWordsAndScores(positionList, Direction.north, Direction.south, Direction.west, Direction.east);
    else
      return _getAllNewWordsAndScores(positionList, Direction.west, Direction.east, Direction.north, Direction.south);
  }
  
  List<Pair<String, int>> _getAllNewWordsAndScores(List<Position> positionList, Direction up, Direction down, Direction left, Direction right) {
    List<Position> initialWordPositions = _getWordPositionsOffPosition(positionList.first, up, down);
    List<Pair<String, int>> wordsAndScores = _getAllNewIntersectingWordsAndScores(initialWordPositions, left, right);
    wordsAndScores.add(_getWordAndScoreFromPositionList(initialWordPositions));
    return wordsAndScores;
  }

  List<Pair<String, int>> _getAllNewIntersectingWordsAndScores(List<Position> positionList, Direction left, Direction right) {
    List<Pair<String, int>> wordsAndScores = [];
    for (Position p in positionList) {
      Tile tile = getTileAtPosition(p)!;
      if (!tile.isLocked) { // Only looking at new tiles
        List<Position> intersectingWordPositions = _getWordPositionsOffPosition(p, left, right);
        if (intersectingWordPositions.length > 1) // One letter words are not valid
          wordsAndScores.add(_getWordAndScoreFromPositionList(intersectingWordPositions));
      }
    }
    return wordsAndScores;
  }

  Pair<String, int> _getWordAndScoreFromPositionList(List<Position> wordPositions) {
    String word = "";
    int score = 0;
    int doubleWord = 0;
    int tripleWord = 0;
    for (Position pos in wordPositions) {
      Tile tile = getTileAtPosition(pos)!;
      word += tile.letter;
      score += _calculateTileScore(pos, tile);
      if (!tile.isLocked) { // Premium letter squares only apply to newly placed tiles
        if (doubleWordSquares.contains(pos))
          doubleWord += 1;
        else if (tripleWordSquares.contains(pos))
          tripleWord += 1;
      }
    }
    for (int i=0; i<doubleWord; i++)
      score *= 2;
    for (int i=0; i<tripleWord; i++)
      score *= 3;
    return Pair(word, score);
  }

  int _calculateTileScore(Position tilePos, Tile tile) {
    if (!tile.isLocked) { // Premium letter squares only apply to newly placed tiles
      if (doubleLetterSquares.contains(tilePos))
        return tile.score * 2;
      if (tripleLetterSquares.contains(tilePos))
        return tile.score * 3;
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
