import 'package:scrabble/game/game_data/TileScores.dart';

class Tile {
  late String _letter;
  late int _score;
  late bool _isLocked;
  late bool _letterIsLocked; // Blank tiles do not have a set letter until played

  Tile(letter) {
    _letter = letter.toUpperCase();
    _letterIsLocked = _letter != " ";
    _isLocked = false;
    _setScore();
  }

  Tile.from(Tile tile) {
    _letter = tile.letter;
    _score = tile._score;
    _letterIsLocked = tile._letterIsLocked;
    _isLocked = tile._isLocked;
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

  Tile.fromJson(Map<String, dynamic> json)
      : _letter = json["letter"],
        _score = json["score"],
        _letterIsLocked = json["letterIsLocked"],
        _isLocked = json["isLocked"];

  Map<String, dynamic> toJson() {
    return {
      "letter"        : _letter,
      "score"         : _score,
      "letterIsLocked": _letterIsLocked,
      "isLocked"      : _isLocked
    };
  }

  @override
  String toString() {
    if (score >= 10) {
      return "($_letter: $_score)";
    }
    return "($_letter: 0$_score)";
  }

  @override
  bool operator ==(Object other) => other is Tile
      && other.letter == _letter
      && other.score == _score
      && other.letterIsLocked == _letterIsLocked
      && other.isLocked == _isLocked;

  @override
  int get hashCode => toJson().toString().hashCode;
}
