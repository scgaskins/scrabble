import 'package:scrabble/game/classes/Board.dart';
import 'package:scrabble/utility/Pair.dart';
import 'package:scrabble/utility/Position.dart';
import 'package:scrabble/game/classes/Tile.dart';

int vowelConsonantBalance(
    List<Pair<String, int>> wordsAndScores,
    List<Position> movePositions,
    List<Tile> rackLeave,
    Board board) {
  int totalScore = wordsAndScores.fold(0, (sum, pair) => sum + pair.b);
  int numVowels = 0;
  int numConsonants = 0;
  int numBlanks = 0;
  for (Tile tile in rackLeave) {
    if (!tile.letterIsLocked)
      numBlanks++;
    else if (_vowels.contains(tile.letter))
      numVowels++;
    else
      numConsonants++;
  }
  // Count blank tiles as the most lacking type
  for (int i=0; i<numBlanks; i++) {
    if (numVowels < numConsonants)
      numVowels++;
    else if (numVowels > numConsonants)
      numConsonants++;
  }
  int penalty = 0;
  if (numConsonants != numVowels)
    penalty = (numVowels - numConsonants).abs() * 4;
  return totalScore - penalty;
}

Set<String> _vowels = {"A", "E", "I", "O", "U"};
