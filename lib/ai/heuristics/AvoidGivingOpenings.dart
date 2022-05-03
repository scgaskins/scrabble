import 'package:scrabble/game/classes/Board.dart';
import 'package:scrabble/utility/Direction.dart';
import 'package:scrabble/utility/Pair.dart';
import 'package:scrabble/utility/Position.dart';
import 'package:scrabble/game/classes/Tile.dart';
import 'package:scrabble/game/game_data/PremiumSquares.dart';


int avoidGivingOpenings(
    List<Pair<String, int>> wordsAndScores,
    List<Position> movePositions,
    List<Tile> rackLeave,
    Board board) {
  int totalScore = wordsAndScores.fold(0, (sum, pair) => sum + pair.b);
  int penalty = 0;
  for (Position pos in movePositions) {
    if (pos.row == 0 || pos.column == 0 || pos.row == board.boardSize - 1 || pos.column == board.boardSize - 1)
      penalty = 20;
    else if (_bordersPremium(pos, doubleWordSquares.union(tripleWordSquares), board) && penalty < 10)
      penalty = 10;
    else if (_bordersPremium(pos, doubleLetterSquares.union(tripleLetterSquares), board) && penalty < 5)
      penalty = 5;
  }
  return totalScore - penalty;
}

bool _bordersPremium(Position p, Set<Position> premiumType, Board board) {
  for (Direction dir in Direction.values) {
    Position neighbor = p.getNeighbor(dir);
    if (board.isPositionOnBoard(neighbor) && !board.isPositionOccupied(neighbor) && premiumType.contains(neighbor))
      return true;
  }
  return false;
}
