import 'Tile.dart';
import 'Board.dart';
import 'TileBag.dart';
import 'package:scrabble/game/game_data/ValidWords.dart';
import 'package:scrabble/utility/Position.dart';
import 'package:scrabble/utility/Pair.dart';

class Game {
  late Board board;
  late TileBag _tileBag;
  late List<Tile?> userHand;

  Game() {
    board = Board();
    _tileBag = TileBag();
    userHand = List.filled(7, null);
    fillUserHand();
  }

  void fillUserHand() {
    for (int i=0;i<userHand.length;i++) {
      if (userHand[i] == null)
        userHand[i] = _tileBag.drawTile();
    }
  }

  bool positionsConnectedToBoard(List<Position> positionList) =>
      board.positionsConnectedToBoard(positionList);

  bool positionsConnectedToEachOther(List<Position> positionList) =>
      board.positionsConnectedToEachOther(positionList);

  List<Pair<String, int>> getWordsAndScoresOffList(List<Position> positionList) =>
      board.getWordsAndScoresOffList(positionList);

  List<String> findInvalidWords(List<String> words) {
    List<String> invalidWords = [];
    for (String word in words)
      if (!validWords.contains(word))
        invalidWords.add(word);
    return invalidWords;
  }

  void submitPlay(List<Pair<String, int>> wordsAndScores, List<Position> tilePositions) {
    board.lockTiles(tilePositions);
    fillUserHand();
  }
}
