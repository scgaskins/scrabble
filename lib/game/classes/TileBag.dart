import 'dart:math';
import 'Tile.dart';
import 'package:scrabble/game/game_data/TileDistribution.dart';
import 'package:json_annotation/json_annotation.dart';

part 'TileBag.g.dart';

@JsonSerializable(explicitToJson: true)
class TileBag {
  late Map<String, int> lettersRemaining; // The amount of each letter that is in the bag
  late int tileCount;
  Random _rng = Random();

  TileBag() {
    lettersRemaining = Map.from(initialTileDistribution);
    tileCount = _getTotalTileCount(); // Get initial count in case letter dist is different from default 100
  }

  bool isEmpty() => tileCount <= 0;

  int letterCount(String letter) => lettersRemaining[letter]!;

  void _incrementLetterAmount(String letter, int change) {
    lettersRemaining[letter] = lettersRemaining[letter]! + change;
    tileCount += change;
  }

  void addTileToBag(Tile tile) {
    if (lettersRemaining.containsKey(tile.letter)) {
      if (lettersRemaining[tile.letter]! < initialTileDistribution[tile.letter]!) {
        _incrementLetterAmount(tile.letter, 1);
      }
      else throw Exception("There are already ${initialTileDistribution[tile.letter]} copies of ${tile.letter}");
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
    if (lettersRemaining.containsKey(letter) && lettersRemaining[letter]! > 0) {
      _incrementLetterAmount(letter, -1);
      return Tile(letter);
    }
    throw Exception("There aren't any $letter tiles in the bag");
  }

  // Does not work when bag is empty
  String _getRandomLetter() {
    int randInt = _rng.nextInt(tileCount);
    for (String letter in lettersRemaining.keys) {
      randInt -= lettersRemaining[letter]!;
      if (randInt < 0)
        return letter;
    }
    throw Exception("Random number is greater than total number of tiles");
  }

  int _getTotalTileCount() {
    int total = 0;
    for (int count in lettersRemaining.values)
      total += count;
    return total;
  }

  factory TileBag.fromJson(Map<String, dynamic> json) => _$TileBagFromJson(json);

  Map<String, dynamic> toJson() => _$TileBagToJson(this);
}
