import 'package:scrabble/ai/Node.dart';
import 'package:scrabble/ai/Edge.dart';
import 'package:scrabble/game/classes/Tile.dart';

class LeftPart {
  late String partialWord;
  late Node lastNode;
  late List<Tile> tiles;
  late Set<String> nextLetters;

  LeftPart(this.partialWord, this.lastNode, this.tiles, this.nextLetters);

  LeftPart.from(LeftPart templateLeftPart, Edge newEdge, Tile newTile) {
    partialWord = templateLeftPart.partialWord + newEdge.label;
    lastNode = newEdge.nextNode;
    nextLetters = lastNode.edges.map((e) => e.label).toSet();
    tiles = List.from(templateLeftPart.tiles);
    tiles.add(newTile);
  }

  bool matchesCrossSet(Set<String> crossSet) {
    return crossSet.intersection(nextLetters).isNotEmpty;
  }
}
