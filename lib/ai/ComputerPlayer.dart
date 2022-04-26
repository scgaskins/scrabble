import 'package:scrabble/game/classes/Tile.dart';
import 'package:scrabble/game/classes/Board.dart';
import 'package:scrabble/game/game_data/ValidWords.dart';
import 'package:scrabble/utility/Position.dart';
import 'package:scrabble/utility/Direction.dart';
import 'package:scrabble/utility/Pair.dart';
import 'package:scrabble/ai/Dawg.dart';
import 'package:scrabble/ai/Node.dart';
import 'package:scrabble/ai/Edge.dart';

class ComputerPlayer {
  Dawg _wordGraph;
  late List<List<Set<String>>> _downCrosschecks;
  late List<List<Set<String>>> _acrossCrosschecks;
  List<String> _alphabetList = [
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
    "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
  ];
  Board board;
  List<Tile> hand;
  List<Tile> _tilesBeingConsidered = [];
  List<Pair<Position, Tile>> _bestMove = [];
  int _bestScore = 0;

  ComputerPlayer(this._wordGraph, this.hand, this.board) {
    Set<String> alphabetSet = Set.from(_alphabetList);
    _downCrosschecks = List.generate(board.boardSize, (index) {
      return List.generate(board.boardSize, (i) => alphabetSet);
    });
    _acrossCrosschecks = List.generate(board.boardSize, (index) {
      return List.generate(board.boardSize, (i) => alphabetSet);
    });
  }

  Tile? _drawTileWithLetter(String letter) {
    for (int i=0; i<hand.length; i++) {
      if (hand[i].letter == letter)
        return hand.removeAt(i);
      else if (!hand[i].letterIsLocked) {
        hand[i].setBlankTile(letter);
        return hand.removeAt(i);
      }
    }
  }

  bool _haveTileWithLetter(String letter) {
    for (Tile t in hand) {
      if (t.letter == letter || !t.letterIsLocked)
        return true;
    }
    return false;
  }

  void _returnTileToHand(Tile tile) {
    tile.resetBlankTile();
    hand.add(tile);
  }

  List<Pair<Position, Tile>> makeMove() {
    List<Position> downAnchors = getAnchorPositions(Direction.south);
    _genAndEvaluateAllMoves(downAnchors, Direction.south);
    List<Position> acrossAnchors = getAnchorPositions(Direction.east);
    _genAndEvaluateAllMoves(acrossAnchors, Direction.east);
    return _bestMove;
  }

  void _genAndEvaluateAllMoves(List<Position> anchors, Direction right) {
    Direction left = right == Direction.east ? Direction.west : Direction.north;
    for (Position anchor in anchors) {
      int limit = _emptySquaresLeftOfSquare(anchor, left);
      _leftPart("", _wordGraph.rootNode, false, limit, anchor, right);
    }
  }

  int _emptySquaresLeftOfSquare(Position start, Direction left) {
    int c = 0;
    for (Position p=start.getNeighbor(left); board.isPositionOnBoard(p); p=p.getNeighbor(left)) {
      if (!board.isPositionOccupied(p))
        c++;
    }
    return c;
  }

  /// This recursively builds the left parts of all possible words
  /// built off of the anchor square that can be made with the tiles
  /// on hand
  void _leftPart(String partialWord, Node n, bool terminalNode, int limit, Position anchorSquare, Direction right) {
    _extendRight(partialWord, n, terminalNode, anchorSquare, right);
    if (limit > 0) {
      for (Edge edge in n.edges) {
        Tile? tileForEdge = _drawTileWithLetter(edge.label);
        if (tileForEdge != null) {
          _tilesBeingConsidered.add(tileForEdge);
          Node nextNode = edge.nextNode;
          _leftPart(partialWord + tileForEdge.letter, nextNode, edge.isTerminal, limit - 1, anchorSquare, right);
          _returnTileToHand(_tilesBeingConsidered.removeLast());
        }
      }
    }
  }

  /// This is called by _leftPart. It recursively builds all possible words
  /// that can be made off of the left part and checks each one to see if it is a
  /// valid move
  void _extendRight(String partialWord, Node n, bool terminalNode, Position startPos, Direction right) {
    if (!board.isPositionOccupied(startPos)) {
      if (terminalNode)
        checkMove(startPos, right);
      for (Edge edge in n.edges) {
        if (_haveTileWithLetter(edge.label) && _crossCheckLetter(edge.label, startPos, right)) {
          Tile tile = _drawTileWithLetter(edge.label)!;
          _tilesBeingConsidered.add(tile);
          Node nextNode = edge.nextNode;
          Position nextSquare = startPos.getNeighbor(right);
          _extendRight(partialWord + tile.letter, nextNode, edge.isTerminal, nextSquare, right);
          _returnTileToHand(_tilesBeingConsidered.removeLast());
        }
      }
    } else {
      String letterOnSquare = board.getTileAtPosition(startPos)!.letter;
      Edge? edgeWithLetter = n.edgeWithLabel(letterOnSquare);
      if (edgeWithLetter != null) {
        Node nextNode = edgeWithLetter.nextNode;
        Position nextPos = startPos.getNeighbor(right);
        _extendRight(partialWord + letterOnSquare, nextNode, edgeWithLetter.isTerminal, nextPos, right);
      }
    }
  }

  void checkMove(Position endPos, Direction right) {
    Direction left = right == Direction.east ? Direction.west : Direction.north;
    List<Pair<Position, Tile>> currentMove = [];
    Position lastPos = endPos;
    for (Tile tile in _tilesBeingConsidered.reversed) {
      Position posForTile = lastPos.getNeighbor(left);
      currentMove.insert(0, Pair(posForTile, tile));
      board.addTileToPosition(tile, posForTile);
    }
    List<Pair<String, int>> wordsAndScores = board.getWordsAndScoresOffList(currentMove.map((pair) => pair.a).toList());
    board.removeAllTilesFromPos(currentMove.map((pair) => pair.a).toList());
    int totalScore = wordsAndScores.fold(0, (sum, pair) => sum + pair.b);
    if (totalScore > _bestScore) {
      _bestMove = currentMove;
      _bestScore = totalScore;
    }
  }

  bool _crossCheckLetter(String letter, Position pos, Direction dir) {
    if (dir == Direction.north || dir == Direction.south)
      return _acrossCrosschecks[pos.column][pos.row].contains(letter);
    return _downCrosschecks[pos.column][pos.row].contains(letter);
  }

  void _updateCrossChecks(List<Position> newTilePos) {
    List<Position> newWordPositions = board.getAllNewWordPositions(newTilePos);
    for (Position pos in newWordPositions) {
      _downCrosschecks[pos.column][pos.row] = {};
      _updateCrossCheckForPos(pos.getNeighbor(Direction.north), Direction.south, _downCrosschecks);
      _updateCrossCheckForPos(pos.getNeighbor(Direction.south), Direction.north, _downCrosschecks);
      _acrossCrosschecks[pos.column][pos.row] = {};
      _updateCrossCheckForPos(pos.getNeighbor(Direction.east), Direction.west, _acrossCrosschecks);
      _updateCrossCheckForPos(pos.getNeighbor(Direction.west), Direction.east, _acrossCrosschecks);
    }
  }

  void _updateCrossCheckForPos(Position pos, Direction dir, List<List<Set<String>>> crossCheckList) {
    if (board.isPositionOnBoard(pos)) {
      Set<String> newCrossSet = {};
      if (!board.isPositionOccupied(pos)) {
        String partialWord = board.getStringAfterPosInDir(pos, dir);
        for (String c in _alphabetList) {
          if (_checkWordInDirection(partialWord, c, dir))
            newCrossSet.add(c);
        }
      } else
        newCrossSet = {};
      crossCheckList[pos.column][pos.row] = newCrossSet;
    }
  }

  bool _checkWordInDirection(String partialWord, String newChar, Direction dir) {
    if (dir == Direction.east || dir == Direction.south)
      return _wordGraph.containsPrefix(newChar + partialWord);
    else
      return _wordGraph.containsPrefix(partialWord + newChar);
  }

  /// If dir == north or south, will find all the anchors for
  /// down plays otherwise it will find anchors for across plays
  List<Position> getAnchorPositions(Direction dir) {
    if (dir == Direction.north || dir == Direction.south)
      return _anchorPositions(Direction.west, Direction.east, Direction.north, Direction.south);
    else
      return _anchorPositions(Direction.north, Direction.south, Direction.west, Direction.east);
  }

  List<Position> _anchorPositions(Direction left, Direction right, Direction up, Direction down) {
    List<Position> anchors = [];
    for (int i=0; i<board.boardSize; i++) {
      Position startPos = left == Direction.north ? Position(i, 0) : Position(0, i);
      for (Position p=startPos; board.isPositionOnBoard(p); p=p.getNeighbor(right)) {
        Position upNeighbor = p.getNeighbor(up);
        Position downNeighbor = p.getNeighbor(down);
        if (!board.isPositionOccupied(p)) {
          if (board.positionOnBoardAndOccupied(upNeighbor) ||
              board.positionOnBoardAndOccupied(downNeighbor))
            anchors.add(p);
        }
      }
    }
    return anchors;
  }
}
