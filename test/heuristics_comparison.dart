import 'package:flutter_test/flutter_test.dart';
import 'package:scrabble/ai/Dawg.dart';
import 'package:scrabble/ai/ComputerPlayer.dart';
import 'package:scrabble/game/classes/Board.dart';
import 'package:scrabble/game/classes/Tile.dart';
import 'package:scrabble/game/game_data/ValidWords.dart';
import 'package:scrabble/utility/Position.dart';
import 'package:scrabble/utility/Pair.dart';
import 'package:scrabble/game/classes/TileBag.dart';
import 'package:scrabble/ai/heuristics/HighestScore.dart';
import 'package:scrabble/ai/heuristics/AvoidGivingOpenings.dart';


main() {
  test("HighestScore vs. AvoidGivingOpenings", () {
    heuristicComparer(highestScore, avoidGivingOpenings, 1000);
    playAgainstEachOther(highestScore, avoidGivingOpenings, 1000);
  });
}

void heuristicComparer(
    int Function(List<Pair<String,int>>, List<Position>, List<Tile>, Board) heuristic1,
    int Function(List<Pair<String,int>>, List<Position>, List<Tile>, Board) heuristic2,
    int randomSeed
    ) {
  print("Heuristic 1 moves");
  int score1 = runThroughTenPlays(heuristic1, randomSeed);
  print("Heuristic 2 moves");
  int score2 = runThroughTenPlays(heuristic2, randomSeed);
  print("Heuristic 1 score: $score1");
  print("Heuristic 2 score: $score2");
}

int runThroughTenPlays(int Function(List<Pair<String,int>>, List<Position>, List<Tile>, Board) heuristic, int randomSeed) {
  Board b = generateBoard({
    Position(7, 7): Tile("s"),
    Position(7, 8): Tile('h'),
    Position(7, 9): Tile('o'),
    Position(7, 10): Tile('p')
  });
  TileBag tileBag = TileBag(seed: randomSeed);
  Dawg dawg = Dawg(validWords.toList());
  List<Tile> hand = [];
  for (int i=0; i<7; i++)
    hand.add(tileBag.drawTile()!);
  ComputerPlayer player = ComputerPlayer(dawg, hand, b, heuristic);
  player.updateCrossChecks([
    Position(7,7), Position(7, 8),
    Position(7, 9), Position(7, 10)
  ]);
  int totalScore = 0;
  for (int i=0; i<10; i++) {
    List<Pair<String,int>> wordsAndScores = player.makeMove();
    print(b);
    totalScore += wordsAndScores.fold(0, (sum, pair) => sum + pair.b);
    int tilesMissing = 7 - player.hand.length;
    for (int j=0; j<tilesMissing; j++) {
      player.hand.add(tileBag.drawTile()!);
    }
  }
  return totalScore;
}

void playAgainstEachOther(
    int Function(List<Pair<String,int>>, List<Position>, List<Tile>, Board) heuristic1,
    int Function(List<Pair<String,int>>, List<Position>, List<Tile>, Board) heuristic2,
    int randomSeed
) {
  Board b = generateBoard({
    Position(7, 7): Tile("s"),
    Position(7, 8): Tile('h'),
    Position(7, 9): Tile('o'),
    Position(7, 10): Tile('p')
  });
  TileBag tileBag = TileBag(seed: randomSeed);
  Dawg dawg = Dawg(validWords.toList());
  List<Tile> hand1 = [];
  List<Tile> hand2 = [];
  for (int i=0; i<7; i++) {
    hand1.add(tileBag.drawTile()!);
    hand2.add(tileBag.drawTile()!);
  }
  ComputerPlayer player1 = ComputerPlayer(dawg, hand1, b, heuristic1);
  int score1 = 0;
  player1.updateCrossChecks([
    Position(7,7), Position(7, 8),
    Position(7, 9), Position(7, 10)
  ]);
  ComputerPlayer player2 = ComputerPlayer(dawg, hand2, b, heuristic2);
  int score2 = 0;
  player2.updateCrossChecks([
    Position(7,7), Position(7, 8),
    Position(7, 9), Position(7, 10)
  ]);
  int turnCount = 0;
  while (!tileBag.isEmpty() && turnCount < 50) {
    List<Pair<String,int>> wordsAndScores1 = player1.makeMove();
    print(b);
    score1 += wordsAndScores1.fold(0, (sum, pair) => sum + pair.b);
    List<Position> positions1 = player1.bestMovePositions;
    player2.updateCrossChecks(positions1);
    List<Pair<String,int>> wordsAndScores2 = player2.makeMove();
    print(b);
    score2 += wordsAndScores2.fold(0, (sum, pair) => sum + pair.b);
    List<Position> positions2 = player2.bestMovePositions;
    player1.updateCrossChecks(positions2);
    for (int i=0; i<7; i++) {
      if (player1.hand.length < 7) {
        Tile? tile = tileBag.drawTile();
        if (tile != null)
          player1.hand.add(tile);
      }
      if (player2.hand.length < 7) {
        Tile? tile = tileBag.drawTile();
        if (tile != null)
          player2.hand.add(tile);
      }
    }
    turnCount++;
  }
  print("Heuristic 1 score: $score1");
  print("Heuristic 2 score: $score2");
}

Board generateBoard(Map<Position, Tile> tiles) {
  Board b = new Board();
  for (Position p in tiles.keys) {
    Tile t = tiles[p]!;
    t.lockTile();
    b.addTileToPosition(t, p);
  }
  return b;
}
