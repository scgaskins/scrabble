import 'package:scrabble/game/TileScores.dart';

class Tile {
  String _letter;
  late int _score;
  late bool _isLocked;
  late bool _letterIsLocked; // Blank tiles do not have a set letter until played

  Tile(this._letter) {
    _letter = _letter.toUpperCase();
    _letterIsLocked = _letter != " ";
    _isLocked = false;
    _setScore();
  }

  String get letter => _letter;

  int get score => _score;

  bool get isLocked => _isLocked;

  bool get letterIsLocked => _letterIsLocked;

  void _setScore() {
    if (tileScores.containsKey(_letter)) {
      _score = tileScores[_letter]!;
    } else {
      _score = 0;
    }
  }

  void setBlankTile(String newLetter) {
    if (!_letterIsLocked) {
      _letter = newLetter.toUpperCase();
    }
  }

  void resetBlankTile() {
    if (!_letterIsLocked) {
      _letter = " ";
    }
  }

  void lockTile() {
    _isLocked = true;
    _letterIsLocked = true;
  }

  // Tiles created from Json represent tiles played by other users
  // on other devices in a multiplayer game.
  Tile.fromJson(Map<String, dynamic> json)
      : _letter = json["letter"],
        _score = json["score"],
        _isLocked = true,
        _letterIsLocked = true; // All blank tiles on the board have set letters

  Map<String, dynamic> toJson() {
    return {
      "letter" : _letter,
      "score"  : _score
    };
  }

  @override
  String toString() {
    if (score >= 10) {
      return "($_letter: $_score)";
    }
    return "($_letter: 0$_score)";
  }
}
