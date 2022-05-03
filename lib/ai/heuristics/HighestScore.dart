import 'package:scrabble/game/classes/Board.dart';
import 'package:scrabble/utility/Pair.dart';
import 'package:scrabble/utility/Position.dart';
import 'package:scrabble/game/classes/Tile.dart';


int highestScore(
    List<Pair<String, int>> wordsAndScores,
    List<Position> movePositions,
    List<Tile> rackLeave,
    Board board) {
  return wordsAndScores.fold(0, (sum, pair) => sum + pair.b);
}
