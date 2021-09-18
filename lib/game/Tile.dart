import 'package:scrabble/game/TileScores.dart';

class Tile {
  String _letter;
  late int _score;
  late bool _isPlaced;
  late bool _letterIsLocked; // Blank tiles do not have a set letter until played

  Tile(this._letter) {
    _letter = _letter.toUpperCase();
    _letterIsLocked = _letter != " ";
    _isPlaced = false;
    _setScore();
  }

  String get letter => _letter;

  int get score => _score;

  bool get isPlaced => _isPlaced;

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

  void placeTile() {
    _isPlaced = true;
    _letterIsLocked = true;
  }

  // Tiles created from Json represent tiles played by other users
  // on other devices in a multiplayer game.
  Tile.fromJson(Map<String, dynamic> json)
      : _letter = json["letter"],
        _score = json["score"],
        _isPlaced = true,
        _letterIsLocked = true; // All blank tiles on the board have set letters

  Map<String, dynamic> toJson() {
    return {
      "letter" : _letter,
      "score"  : _score
    };
  }
}
