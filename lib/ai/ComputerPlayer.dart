import 'package:scrabble/game/classes/Tile.dart';
import 'package:scrabble/game/classes/Board.dart';
import 'package:scrabble/utility/Position.dart';
import 'package:scrabble/utility/Direction.dart';
import 'package:scrabble/utility/Pair.dart';
import 'package:scrabble/ai/Dawg.dart';
import 'package:scrabble/ai/Node.dart';
import 'package:scrabble/ai/Edge.dart';
import 'package:scrabble/ai/PotentialTile.dart';

class ComputerPlayer {
  Dawg wordGraph;
  late List<List<Set<String>>> _downCrosschecks;
  late List<List<Set<String>>> _acrossCrosschecks;
  List<String> _alphabetList = [
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
    "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
  ];
  Board board;
  List<Tile> hand;
  List<Tile> tilesBeingConsidered = [];
  List<Pair<Position, PotentialTile>> _bestMove = [];
  List<Pair<String, int>> _bestMoveResult = [];
  int Function(List<Pair<String,int>>, List<Position>, List<Tile>, Board) _evaluationFunction;
  int _bestRating = -10000;

  ComputerPlayer(this.wordGraph, this.hand, this.board, this._evaluationFunction) {
    Set<String> alphabetSet = Set.from(_alphabetList);
    _downCrosschecks = List.generate(board.boardSize, (index) {
      return List.generate(board.boardSize, (i) => alphabetSet);
    });
    _acrossCrosschecks = List.generate(board.boardSize, (index) {
      return List.generate(board.boardSize, (i) => alphabetSet);
    });
  }

  List<Pair<String,int>> get bestMoveResult => _bestMoveResult;
  List<Position> get bestMovePositions => _bestMove.map((e) => e.a).toList();

  Set<String> crossCheckSet(Position pos, Direction dir) {
    if (dir == Direction.north || dir == Direction.south)
      return _acrossCrosschecks[pos.column][pos.row];
    return _downCrosschecks[pos.column][pos.row];
  }

  Tile? drawTileWithLetter(String letter) {
    for (int i=0; i<hand.length; i++) {
      if (!hand[i].letterIsLocked) { // If the tile is blank
        hand[i].setBlankTile(letter);
        return hand.removeAt(i);
      } else if (hand[i].letter == letter)
        return hand.removeAt(i);
    }
  }

  bool haveTileWithLetter(String letter) {
    for (Tile t in hand) {
      if (t.letter == letter || !t.letterIsLocked)
        return true;
    }
    return false;
  }

  void returnTileToHand(Tile tile) {
    tile.resetBlankTile();
    hand.add(tile);
  }

  void clearData() {
    _bestMove.clear();
    _bestMoveResult.clear();
    _bestRating = -10000;
  }

  List<Pair<String, int>> makeMove() {
    clearData();
    _evaluateAllMoves();
    endMove();
    return _bestMoveResult;
  }

  void _evaluateAllMoves() {
    // Generates all down moves
    List<Position> downAnchors = getAnchorPositions(Direction.south);
    _genAndEvaluateAllMovesInDir(downAnchors, Direction.south);
    // Generates all across moves
    List<Position> acrossAnchors = getAnchorPositions(Direction.east);
    _genAndEvaluateAllMovesInDir(acrossAnchors, Direction.east);
  }

  void endMove() {
    _placeAllPotentialTiles();
    List<Position> movePositions = _bestMove.map((pair) => pair.a).toList();
    board.lockTiles(movePositions);
    updateCrossChecks(movePositions);
  }

  void _placeAllPotentialTiles() {
    for (Pair<Position,PotentialTile> pair in _bestMove) {
      Position pos = pair.a;
      Tile tile = _drawPotentialTileFromHand(pair.b)!;
      board.addTileToPosition(tile, pos);
    }
  }

  Tile? _drawPotentialTileFromHand(PotentialTile potentialTile) {
    for (int i=0; i<hand.length; i++) {
      Tile tile = hand[i];
      if (potentialTile.isBlank && !tile.letterIsLocked) {
        tile.setBlankTile(potentialTile.letter);
        return hand.removeAt(i);
      } else if (tile.letter == potentialTile.letter)
        return hand.removeAt(i);
    }
    print(hand);
    print(_bestMove);
    print(tilesBeingConsidered);
    throw Exception("Could not find tile that matched $potentialTile");
  }

  /// If right == south it will generate all down moves. If right == east it
  /// will generate all across moves
  void _genAndEvaluateAllMovesInDir(List<Position> anchors, Direction right) {
    Direction left = right == Direction.east ? Direction.west : Direction.north;
    for (Position anchor in anchors) {
      int limit = emptySquaresLeftOfSquare(anchor, left);
      _leftPart("", wordGraph.rootNode, false, limit, anchor, right);
    }
  }

  /// This counts all the squares left of start that have no occupied neighbors
  int emptySquaresLeftOfSquare(Position start, Direction left) {
    int c = 0;
    for (Position p=start.getNeighbor(left); board.isPositionOnBoard(p) && !board.isPositionOccupied(p); p=p.getNeighbor(left)) {
      for (Direction dir in Direction.values) {
        if (board.positionOnBoardAndOccupied(p.getNeighbor(dir)))
          return c;
      }
      c++;
    }
    return c;
  }

  /// This recursively builds the left parts of all possible words
  /// built off of the anchor square that can be made with the tiles
  /// on hand
  void _leftPart(String partialWord, Node n, bool terminalNode, int limit, Position anchorSquare, Direction right) {
    extendRight(partialWord, n, terminalNode, anchorSquare, anchorSquare, right);
    if (limit > 0) {
      for (Edge edge in n.edges) {
        Tile? tileForEdge = drawTileWithLetter(edge.label);
        if (tileForEdge != null) {
          tilesBeingConsidered.add(tileForEdge);
          Node nextNode = edge.nextNode;
          _leftPart(partialWord + tileForEdge.letter, nextNode, edge.isTerminal, limit - 1, anchorSquare, right);
          returnTileToHand(tilesBeingConsidered.removeLast());
        }
      }
    }
  }

  /// This is called by _leftPart. It recursively builds all possible words
  /// that can be made off of the left part and checks each one to see if it is a
  /// valid move
  void extendRight(String partialWord, Node n, bool terminalNode, Position startPos, Position anchor, Direction right) {
    if (!board.isPositionOccupied(startPos)) {
      if (terminalNode && startPos != anchor)
        _evaluateMove(partialWord, startPos, right);
      for (Edge edge in n.edges) {
        if (haveTileWithLetter(edge.label) && _crossCheckLetter(edge.label, startPos, right)) {
          Tile tile = drawTileWithLetter(edge.label)!;
          tilesBeingConsidered.add(tile);
          Node nextNode = edge.nextNode;
          Position nextSquare = startPos.getNeighbor(right);
          if (board.isPositionOnBoard(nextSquare))
            extendRight(partialWord + tile.letter, nextNode, edge.isTerminal, nextSquare, anchor, right);
          returnTileToHand(tilesBeingConsidered.removeLast());
        }
      }
    } else {
      String letterOnSquare = board.getTileAtPosition(startPos)!.letter;
      Edge? edgeWithLetter = n.edgeWithLabel(letterOnSquare);
      if (edgeWithLetter != null) {
        Node nextNode = edgeWithLetter.nextNode;
        Position nextPos = startPos.getNeighbor(right);
        if (board.isPositionOnBoard(nextPos))
          extendRight(partialWord + letterOnSquare, nextNode, edgeWithLetter.isTerminal, nextPos, anchor, right);
      }
    }
  }

  void _evaluateMove(String partialWord, Position endPos, Direction right) {
    if (wordGraph.contains(partialWord)) {
      List<Pair<Position, PotentialTile>> currentMove = _placeTilesOnBoard(endPos, right);
      List<Position> movePositions = currentMove.map((pair) => pair.a).toList();
      List<Pair<String, int>> wordsAndScores = board.getWordsAndScoresOffList(movePositions);
      board.removeAllTilesFromPos(movePositions);
      bool allValid = wordsAndScores.fold(true, (valid, pair) => valid && wordGraph.contains(pair.a));
      int heuristicRating = _evaluationFunction(wordsAndScores, movePositions, hand, board);
      if (allValid && heuristicRating > _bestRating) {
        _bestMove = currentMove;
        _bestRating = heuristicRating;
        _bestMoveResult = wordsAndScores;
      }
    }
  }

  List<Pair<Position, PotentialTile>> _placeTilesOnBoard(Position endPos, Direction right) {
    Direction left = right == Direction.east ? Direction.west : Direction.north;
    List<Pair<Position, PotentialTile>> currentMove = [];
    Position lastPos = endPos;
    for (Tile tile in tilesBeingConsidered.reversed) {
      Position posForTile = lastPos.getNeighbor(left);
      while (board.isPositionOccupied(posForTile))
        posForTile = posForTile.getNeighbor(left);
      currentMove.insert(0, Pair(posForTile, PotentialTile(tile.letter, !tile.letterIsLocked)));
      board.addTileToPosition(tile, posForTile);
      lastPos = posForTile;
    }
    return currentMove;
  }

  bool _crossCheckLetter(String letter, Position pos, Direction dir) {
    if (dir == Direction.north || dir == Direction.south)
      return _acrossCrosschecks[pos.column][pos.row].contains(letter);
    return _downCrosschecks[pos.column][pos.row].contains(letter);
  }

  void updateCrossChecks(List<Position> newTilePos) {
    if (newTilePos.length > 0) {
      List<Position> newWordPositions = board.getAllNewWordPositions(
          newTilePos);
      for (Position pos in newWordPositions) {
        _downCrosschecks[pos.column][pos.row] = {};
        _updateCrossCheckForPos(pos.getNeighbor(Direction.north), Direction.south, _downCrosschecks);
        _updateCrossCheckForPos(pos.getNeighbor(Direction.south), Direction.north, _downCrosschecks);
        _acrossCrosschecks[pos.column][pos.row] = {};
        _updateCrossCheckForPos(pos.getNeighbor(Direction.east), Direction.west, _acrossCrosschecks);
        _updateCrossCheckForPos(pos.getNeighbor(Direction.west), Direction.east, _acrossCrosschecks);
      }
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
      return wordGraph.containsPrefix(newChar + partialWord);
    else
      return wordGraph.containsPrefix(partialWord + newChar);
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
        Position downNeighbor = p.getNeighbor(down);
        if (!board.isPositionOccupied(p)) {
          if (board.positionOnBoardAndOccupied(downNeighbor))
            anchors.add(p);
        }
      }
    }
    return anchors;
  }
}
