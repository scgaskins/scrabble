import 'package:scrabble/game/TileScores.dart';

class Tile {
  String _letter;
  int _score;
  bool _letterIsLocked; // Blank tiles do not have a set letter until played

  Tile(this._letter) {
    _letter = _letter.toUpperCase();
    _letterIsLocked = _letter != " ";
    _setScore();
  }

  Tile.fromJson(Map<String, dynamic> json)
    : _letter = json["letter"],
      _score = json["score"],
      _letterIsLocked = true; // All blank tiles on the board have set letters

  Map<String, dynamic> toJson() {
    return {
      "letter" : _letter,
      "score"  : _score
    };
  }

  void _setScore() {
    if (tileScores.containsKey(_letter)) {
      _score = tileScores[_letter];
    } else {
      _score = 0;
    }
  }

  String get letter => _letter;

  int get score => _score;

  void setBlankTile(String newLetter) {
    if (!_letterIsLocked) {
      _letter = newLetter.toUpperCase();
    }
  }

  void resetTile() {
    if (!_letterIsLocked) {
      _letter = " ";
    }
  }

  void lockInLetter() {
    _letterIsLocked = true;
  }
}
