import 'package:flutter_test/flutter_test.dart';
import 'package:scrabble/game/classes/Board.dart';
import 'package:scrabble/utility/Position.dart';
import 'package:scrabble/game/classes/Tile.dart';
import 'package:scrabble/utility/Pair.dart';
import 'dart:convert';

main() {
  test("Printing test", () {
    Board b = new Board();
    b.addTileToPosition(new Tile('a'), new Position(7, 2));
    Tile blank = new Tile(" ");
    blank.setBlankTile("a");
    b.addTileToPosition(blank, new Position(7, 3));
    print(b);
  });
  test("Adding tile test", () {
    Board b = new Board();
    Tile firstTile = new Tile('A');
    Position initialPos = new Position(0, 0);
    b.addTileToPosition(firstTile, initialPos);
    Tile secondTile = new Tile('C');
    b.addTileToPosition(secondTile, initialPos);
    print(b);
    assert(b.getTileAtPosition(initialPos) == firstTile);
  });
  test("Removing tile test", () {
    Board b = new Board();
    Tile tile = new Tile("A");
    Position tilePos = new Position(0, 0);
    b.addTileToPosition(tile, tilePos);
    assert(b.getTileAtPosition(tilePos) == tile);
    Tile? removedTile = b.removeTileFromPosition(tilePos);
    assert(removedTile == tile, true);
    assert(b.getTileAtPosition(tilePos) == null);
  });
  test("Locked tiles shouldn't be removable", () {
    Board b = new Board();
    Tile tile = new Tile('a');
    Position tilePos = new Position(0, 0);
    b.addTileToPosition(tile, tilePos);
    b.lockTiles([tilePos]);
    expect(() => b.removeTileFromPosition(tilePos), throwsException);
    assert(b.getTileAtPosition(tilePos) == tile);
  });
  test("Positions in line test", (){
    Board b = new Board();
    assert(b.positionsAreInALine([Position(0, 0), Position(0, 2), Position(0, 7)]));
    assert(b.positionsAreInALine([Position(0, 0), Position(0, 1)]));
    assert(!b.positionsAreInALine([Position(0, 0), Position(0, 2), Position(1, 0)]));
  });
  test("Test if tiles connected to board", () {
    Board b = generateBoard({
      Position(5, 7): Tile('c'),
      Position(6, 7): Tile('a'),
      Position(7, 7): Tile('t')
    });
    List<Tile> newTiles = [Tile('v'), Tile('s'), Tile('e')];
    List<Position> newPositions = [Position(6, 6), Position(6, 8), Position(6, 9)];
    b = addTilesToBoard(b, Map.fromIterables(newPositions, newTiles));
    print(b);
    assert(b.positionsConnectedToBoard(newPositions));
  });
  test("Test if tiles not connected to board", () {
    Board b = generateBoard({
      Position(5, 7): Tile('c'),
      Position(6, 7): Tile('a'),
      Position(7, 7): Tile('t')
    });
    List<Tile> newTiles = [Tile('v'), Tile('s'), Tile('e')];
    List<Position> newPositions = [Position(6, 9), Position(6, 10), Position(6, 11)];
    b = addTilesToBoard(b, Map.fromIterables(newPositions, newTiles));
    print(b);
    assert(!b.positionsConnectedToBoard(newPositions));
  });
  test("Test of tiles connected to each other on blank board", () {
    Board b = Board();
    List<Tile> newTiles = [Tile("c"), Tile("a"), Tile("t")];
    List<Position> newPositions = [Position(5, 7), Position(6, 7), Position(7, 7)];
    b = addTilesToBoard(b, Map.fromIterables(newPositions, newTiles));
    print(b);
    assert(b.positionsConnectedToEachOther(newPositions));
  });
  test("Test of tiles connected to each other passing through other word", () {
    Board b = generateBoard({
      Position(7, 6): Tile("r"),
      Position(7, 7): Tile("a"),
      Position(7, 8): Tile('t')
    });
    List<Tile> newTiles = [Tile("c"), Tile("t")];
    List<Position> newPositions = [Position(6, 7), Position(8, 7)];
    b = addTilesToBoard(b, Map.fromIterables(newPositions, newTiles));
    print(b);
    assert(b.positionsConnectedToEachOther(newPositions));
  });
  test("Test of tiles connected to each other built off other word", () {
    Board b = generateBoard({
      Position(7, 6): Tile("r"),
      Position(7, 7): Tile("a"),
      Position(7, 8): Tile('t')
    });
    List<Tile> newTiles = [Tile("a"), Tile("r"), Tile('p')];
    List<Position> newPositions = [Position(8, 8), Position(9, 8), Position(10, 8)];
    b = addTilesToBoard(b, Map.fromIterables(newPositions, newTiles));
    print(b);
    assert(b.positionsConnectedToEachOther(newPositions));
  });
  test("Test of tiles touching but not in line", () {
    Board b = Board();
    List<Tile> newTiles = [Tile("c"), Tile("a"), Tile("t")];
    List<Position> newPositions = [Position(5, 7), Position(6, 7), Position(6, 8)];
    b = addTilesToBoard(b, Map.fromIterables(newPositions, newTiles));
    print(b);
    assert(!b.positionsConnectedToEachOther(newPositions));
  });
  test("Test of tiles in line but not all touching", () {
    Board b = Board();
    List<Tile> newTiles = [Tile("c"), Tile("a"), Tile("t")];
    List<Position> newPositions = [Position(5, 7), Position(7, 7), Position(8, 7)];
    b = addTilesToBoard(b, Map.fromIterables(newPositions, newTiles));
    print(b);
    assert(!b.positionsConnectedToEachOther(newPositions));
  });
  test("Test of word with no premium tiles", () {
    List<Tile> newTiles = [Tile('o'), Tile('u'), Tile('p')];
    List<Position> newPositions = [Position(8, 7), Position(9, 7), Position(10, 7)];
    List<Pair<String, int>> expectedWordsAndScores = [Pair("soup", 6)];
    wordsAndScoresTest(newTiles, newPositions, expectedWordsAndScores);
  });
  test("Test of word with blank tile", () {
    List<Tile> newTiles = [Tile('o'), Tile('u'), blankTileWithLetter('p')];
    List<Position> newPositions = [Position(8, 7), Position(9, 7), Position(10, 7)];
    List<Pair<String, int>> expectedWordsAndScores = [Pair("soup", 3)];
    wordsAndScoresTest(newTiles, newPositions, expectedWordsAndScores);
  });
  test("Test of word with new s on double letter", () {
    List<Tile> newTiles = [Tile('o'), Tile('u'), Tile('p'), Tile('s')];
    List<Position> newPositions = [Position(8, 7), Position(9, 7), Position(10, 7), Position(11, 7)];
    List<Pair<String, int>> expectedWordsAndScores = [Pair("soups", 8)];
    wordsAndScoresTest(newTiles, newPositions, expectedWordsAndScores);
  });
  test("Test of word with w on triple letter", () {
    List<Tile> newTiles = [Tile('w'), Tile('r'), Tile('p')];
    List<Position> newPositions = [Position(5, 9), Position(6, 9), Position(8, 9)];
    List<Pair<String, int>> expectedWordsAndScores = [Pair("wrap", 17)];
    wordsAndScoresTest(newTiles, newPositions, expectedWordsAndScores);
  });
  test("Test of three new words, k on double letter", () {
    List<Tile> newTiles = [Tile('b'), Tile('a'), Tile('c'), Tile('k')];
    List<Position> newPositions = [Position(8, 9), Position(8, 10), Position(8, 11), Position(8, 12)];
    List<Pair<String, int>> expectedWordsAndScores = [
      Pair("back", 17),
      Pair("pa", 4),
      Pair("ab", 4)
    ];
    wordsAndScoresTest(newTiles, newPositions, expectedWordsAndScores);
  });
  test("Test of double word", () {
    List<Tile> newTiles = [Tile('a'), Tile('s'), Tile('s')];
    List<Position> newPositions = [Position(8, 10), Position(9, 10), Position(10, 10)];
    List<Pair<String, int>> expectedWordsAndScores = [Pair("pass", 12)];
    wordsAndScoresTest(newTiles, newPositions, expectedWordsAndScores);
  });
  test("Test of triple word with double letter on d", () {
    List<Tile> newTiles = [Tile('d'), Tile('a'), Tile('s'), Tile('h')];
    List<Position> newPositions = [Position(7, 11), Position(7, 12), Position(7, 13), Position(7, 14)];
    List<Pair<String, int>> expectedWordsAndScores = [Pair("slapdash", 48)];
    wordsAndScoresTest(newTiles, newPositions, expectedWordsAndScores);
  });
  test("Converting to JSON", () {
    Board b = generateBoard({
      Position(7, 7): Tile("s"),
      Position(7, 8): Tile('h'),
      Position(7, 9): Tile('o'),
      Position(7, 10): Tile('p')
    });
    b = addTilesToBoard(b, {
      Position(7, 11): Tile('p'),
      Position(7, 12): Tile("e"),
      Position(7, 13): Tile("r"),
      Position(7, 14): blankTileWithLetter("s")
    });
    print(b);
    JsonCodec encoder = new JsonCodec();
    String jsonString = encoder.encode(b);
    print(jsonString);
    Map<String, dynamic> boardMap = encoder.decode(jsonString);
    Board decodedBoard = Board.fromJson(boardMap);
    print(decodedBoard);
    expect(b, decodedBoard);
  });
}

Board generateBoard(Map<Position, Tile> tiles) {
  Board b = new Board();
  for (Position p in tiles.keys) {
    Tile t = tiles[p]!;
    t.lockTile();
    b.addTileToPosition(t, p);
  }
  return b;
}

Tile blankTileWithLetter(String letter) {
  Tile t = Tile(" ");
  t.setBlankTile(letter);
  return t;
}

Board addTilesToBoard(Board b, Map<Position, Tile> tiles) {
  for (Position p in tiles.keys) {
    b.addTileToPosition(tiles[p]!, p);
  }
  return b;
}

void wordsAndScoresTest(List<Tile> newTiles, List<Position> newPositions, List<Pair<String, int>> expectedWordsAndScores) {
  Board b = generateBoard({
    Position(7, 7): Tile("s"),
    Position(7, 8): Tile('l'),
    Position(7, 9): Tile('a'),
    Position(7, 10): Tile('p')
  });
  b = addTilesToBoard(b, Map.fromIterables(newPositions, newTiles));
  print(b);
  List<Pair<String, int>> wordsAndScores = b.getWordsAndScoresOffList(newPositions);
  for (Pair pair in wordsAndScores) {
    print(pair);
    assert(expectedWordsAndScores.contains(pair));
  }
}
