import 'package:scrabble/utility/Pair.dart';
import 'package:scrabble/game/classes/Tile.dart';


int highestScore(List<Pair<String, int>> wordsAndScores, List<Tile> rackLeave) {
  return wordsAndScores.fold(0, (sum, pair) => sum + pair.b);
}
