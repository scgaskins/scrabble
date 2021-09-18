import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:scrabble/game/Tile.dart';
import 'package:scrabble/game/TileScores.dart';

void main() {
  test("Lowercase letters should be converted to upper case", () {
    List<String> letters = [
      "a", 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i',
      'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r',
      's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
    ];
    for (String letter in letters) {
      Tile t = new Tile(letter);
      expect(t.letter, letter.toUpperCase());
      expect(t.score, tileScores[letter.toUpperCase()]);
    }
  });
  test("Changing blank tiles", () {
    Tile t = new Tile(" ");
    t.setBlankTile("a");
    expect(t.letter, "A");
    t.resetBlankTile();
    expect(t.letter, " ");
    t.setBlankTile("A");
    t.placeTile();
    t.resetBlankTile();
    expect(t.letter, "A");
  });
  test("Converting tile to JSON and back", () {
    JsonCodec encoder = new JsonCodec();
    Tile originalTile = new Tile("A");
    String jsonString = encoder.encode(originalTile);
    print(jsonString);
    Map<String, dynamic> tileMap = encoder.decode(jsonString);
    Tile decodedTile = Tile.fromJson(tileMap);
    expect(decodedTile.letter, originalTile.letter);
    expect(decodedTile.score, originalTile.score);
  });
}