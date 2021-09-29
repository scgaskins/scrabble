import 'package:flutter_test/flutter_test.dart';
import 'package:scrabble/game/TileBag.dart';
import 'package:scrabble/game/Tile.dart';

main() {
  final Map<String, int> initialDistribution = {
    "A": 9, "B": 2, "C": 2, "D": 4, "E": 12, "F": 2, "G": 3, "H": 2, "I": 9,
    "J": 1, "K": 1, "L": 4, "M": 2, "N": 6,  "O": 8, "P": 2, "Q": 1, "R": 6,
    "S": 4, "T": 6, "U": 4, "V": 2, "W": 2,  "X": 1, "Y": 2, "Z": 1, " ": 2
  };
  test("Tile counts should go down when tiles removed", () {
    TileBag bag = new TileBag();
    int initialCount = bag.tileCount;
    print(initialCount);
    Tile drawnTile = bag.drawTile()!;
    String letter = drawnTile.letter;
    print(bag.tileCount);
    assert(bag.tileCount == initialCount - 1);
    print("$letter: ${bag.letterCount(letter)}");
    assert(initialDistribution[letter]! - 1 == bag.letterCount(letter));
  });
  test("Tile counts should increase when tiles added", () {
    TileBag bag = new TileBag();
    int initialCount = bag.tileCount;
    print(initialCount);
    Tile drawnTile = bag.drawTile()!;
    String letter = drawnTile.letter;
    print(bag.tileCount);
    bag.addTileToBag(drawnTile);
    print(bag.tileCount);
    assert(bag.tileCount == initialCount);
    assert(bag.letterCount(letter) == initialDistribution[letter]);
  });
  test("Empty bags should return null when drawing a tile", () {
    TileBag bag = new TileBag();
    int initialCount = bag.tileCount;
    for (int i=0; i<initialCount; i++)
      bag.drawTile();
    Tile? drawnTile = bag.drawTile();
    assert(drawnTile == null);
  });
  test("Bags shouldn't be able to add more than original number of tiles", () {
    TileBag bag = new TileBag();
    expect(() => bag.addTileToBag(Tile("A")), throwsException);
  });
}
