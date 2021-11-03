import 'Tile.dart';
import 'Board.dart';
import 'TileBag.dart';
import 'package:scrabble/game/game_data/ValidWords.dart';
import 'package:scrabble/utility/Position.dart';

class Game {
  late Board board;
  late TileBag _tileBag;
  late List<Tile?> userHand;

  Game() {
    board = Board();
    _tileBag = TileBag();
    userHand = List.filled(7, null);
  }

  void fillUserHand() {
    for (int i=0;i<userHand.length;i++) {
      if (userHand[i] == null)
        userHand[i] = _tileBag.drawTile();
    }
  }
}
