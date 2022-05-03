import 'package:scrabble/ai/ComputerPlayer.dart';
import 'package:scrabble/ai/Dawg.dart';
import 'package:scrabble/ai/Node.dart';
import 'package:scrabble/ai/Edge.dart';
import 'package:scrabble/game/classes/Board.dart';
import 'package:scrabble/game/classes/Tile.dart';
import 'package:scrabble/ai/LeftPart.dart';
import 'package:scrabble/utility/Pair.dart';
import 'package:scrabble/utility/Position.dart';
import 'package:scrabble/utility/Direction.dart';

class ComputerPlayerEnhanced extends ComputerPlayer {
  List<List<LeftPart>> _leftParts = [];  // Index is length of left part
  late List<Position> _acrossAnchors;
  late List<Position> _downAnchors;
  late Map<Position,int> _downAnchorLimits;
  late Map<Position, int> _acrossAnchorLimits;

  ComputerPlayerEnhanced(
      Dawg wordGraph,
      List<Tile> hand,
      Board board,
      int Function(List<Pair<String,int>>, List<Position>, List<Tile>, Board) evaluationFunction)
      : super(wordGraph, hand, board, evaluationFunction);

  @override
  List<Pair<String, int>> makeMove() {
    clearData();
    _generateLeftParts();
    _setUpAnchors();
    _evaluateMoves();
    endMove();
    return bestMoveResult;
  }

  void _setUpAnchors() {
    _acrossAnchors = getAnchorPositions(Direction.east);
    _downAnchors = getAnchorPositions(Direction.south);
    _downAnchorLimits = {};
    _acrossAnchorLimits = {};
    for (Position anchor in _acrossAnchors)
      _acrossAnchorLimits[anchor] = emptySquaresLeftOfSquare(anchor, Direction.west);
    for (Position anchor in _downAnchors)
      _downAnchorLimits[anchor] = emptySquaresLeftOfSquare(anchor, Direction.north);
  }

  void _evaluateMoves() {
    for (int n=0; n<hand.length; n++) {
      List<LeftPart> leftPartsLengthN = _leftParts[n];
      for (LeftPart leftPart in leftPartsLengthN) {
        for (Position anchor in _downAnchors)
          _evaluateMovesForAnchor(anchor, _downAnchorLimits[anchor]!, leftPart, Direction.south);
        for (Position anchor in _acrossAnchors)
          _evaluateMovesForAnchor(anchor, _acrossAnchorLimits[anchor]!, leftPart, Direction.east);
      }
    }
  }

  void _evaluateMovesForAnchor(Position anchor, int lengthLimit, LeftPart leftPart, Direction right) {
    if (leftPart.length <= lengthLimit && leftPart.matchesCrossSet(crossCheckSet(anchor, right))) {
      _removeAllFromHand(leftPart.tiles);
      tilesBeingConsidered = leftPart.tiles;
      extendRight(leftPart.partialWord, leftPart.lastNode, false, anchor, anchor, right);
      tilesBeingConsidered = [];
      for (Tile tile in leftPart.tiles)
        returnTileToHand(tile);
    }
  }

  void _removeAllFromHand(Iterable<Tile> tiles) {
    for (Tile tile in tiles) {
      if (!tile.letterIsLocked) {
        hand.remove(Tile(" "));
      } else
        hand.remove(tile);
    }
  }

  void _generateLeftParts() {
    if (hand.isNotEmpty) {
      _leftParts.clear();
      for (int i = 0; i < hand.length; i++)
        _leftParts.add([]);
      Node rootNode = super.wordGraph.rootNode;
      LeftPart initialLeftPart = LeftPart("", rootNode, [], {
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
        "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
      });
      _leftParts[0].add(initialLeftPart);
      _buildLeftPart(rootNode, initialLeftPart);
    }
  }

  void _buildLeftPart(Node currentNode, LeftPart oldLeftPart) {
    for (Edge edge in currentNode.edges) {
        if (edge.nextNode.hasChildren() && haveTileWithLetter(edge.label)) {
          Tile tile = drawTileWithLetter(edge.label)!;
          LeftPart newLeftPart = LeftPart.from(oldLeftPart, edge, Tile.from(tile));
          _leftParts[newLeftPart.tiles.length].add(newLeftPart);
          if (hand.length > 1)
            _buildLeftPart(edge.nextNode, newLeftPart);
          returnTileToHand(tile);
        }
    }
  }
}
