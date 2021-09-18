import 'package:scrabble/game/Position.dart';
import 'package:scrabble/game/Tile.dart';

class Board {
  late List<List<Tile?>> _board;

  Board() {
    _board = List.filled(15, List.filled(15, null));
  }

  Tile? getTileAtPosition(Position pos) {
    if (pos.row >= 0 && pos.row < _board.length && pos.column >= 0 && pos.column < _board.length) {
      return _board[pos.column][pos.row];
    }
    return null;
  }
}
