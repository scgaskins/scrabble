import 'dart:math';
import 'Tile.dart';

class TileBag {
  Map<String, int> _initialDistribution = {
    "A": 9, "B": 2, "C": 2, "D": 4, "E": 12, "F": 2, "G": 3, "H": 2, "I": 9,
    "J": 1, "K": 1, "L": 4, "M": 2, "N": 6,  "O": 8, "P": 2, "Q": 1, "R": 6,
    "S": 4, "T": 6, "U": 4, "V": 2, "W": 2,  "X": 1, "Y": 2, "Z": 1, " ": 2
  };
  late Map<String, int> _lettersRemaining; // The amount of each letter that is in the bag
  late int _tileCount;
  Random _rng = Random();

  TileBag() {
    _lettersRemaining = Map.from(_initialDistribution);
    _tileCount = _getTotalTileCount(); // Get initial count in case letter dist is different from default 100
  }

  bool isEmpty() => _tileCount <= 0;

  int get tileCount => _tileCount;

  int letterCount(String letter) => _lettersRemaining[letter]!;

  void _incrementLetterAmount(String letter, int change) {
    _lettersRemaining[letter] = _lettersRemaining[letter]! + change;
    _tileCount += change;
  }

  void addTileToBag(Tile tile) {
    if (_lettersRemaining.containsKey(tile.letter)) {
      if (_lettersRemaining[tile.letter]! < _initialDistribution[tile.letter]!) {
        _incrementLetterAmount(tile.letter, 1);
      }
      else throw Exception("There are already ${_initialDistribution[tile.letter]} copies of ${tile.letter}");
    }
    else throw Exception("${tile.letter} is not a valid letter");
  }

  Tile? drawTile() {
    if (!isEmpty()) {
      String randomLetter = _getRandomLetter();
      return _getTileWithLetter(randomLetter);
    }
  }

  Tile _getTileWithLetter(String letter) {
    letter = letter.toUpperCase();
    if (_lettersRemaining.containsKey(letter) && _lettersRemaining[letter]! > 0) {
      _incrementLetterAmount(letter, -1);
      return Tile(letter);
    }
    throw Exception("There aren't any $letter tiles in the bag");
  }

  String _getRandomLetter() {
    int randInt = _rng.nextInt(_tileCount);
    for (String letter in _lettersRemaining.keys) {
      randInt -= _lettersRemaining[letter]!;
      if (randInt < 0)
        return letter;
    }
    throw Exception("Random number is greater than total number of tiles");
  }

  int _getTotalTileCount() {
    int total = 0;
    for (int count in _lettersRemaining.values)
      total += count;
    return total;
  }
}
