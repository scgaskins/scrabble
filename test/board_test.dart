import 'package:flutter_test/flutter_test.dart';
import 'package:scrabble/game/Board.dart';
import 'package:scrabble/game/Position.dart';
import 'package:scrabble/game/Tile.dart';

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
    assert(b.removeTileFromPosition(tilePos) == null);
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
  test("Full word test across column", () {
    List<Position> oldPositions = [Position(4, 0), Position(4, 1), Position(4, 2)];
    List<Tile> oldTiles = [Tile('b'), Tile('e'), Tile('t')];
    Board b = generateBoard(Map.fromIterables(oldPositions, oldTiles));
    print(b);
    List<Position> newPositions = [Position(4, 3), Position(4, 4), Position(4, 5)];
    List<Tile> newTiles = [Tile('t'), Tile('e'), Tile('r')];
    b = addTilesToBoard(b, Map.fromIterables(newPositions, newTiles));
    print(b);
    List<Position> fullPositions = b.getFullWord(newPositions);
    for (Position p in fullPositions) {
      print(p);
      assert((oldPositions + newPositions).contains(p));
    }
  });
  test("Full word test across row", () {
    List<Position> oldPositions = [Position(0, 4), Position(1, 4), Position(2, 4)];
    List<Tile> oldTiles = [Tile('b'), Tile('e'), Tile('t')];
    Board b = generateBoard(Map.fromIterables(oldPositions, oldTiles));
    print(b);
    List<Position> newPositions = [Position(3, 4), Position(4, 4), Position(5, 4)];
    List<Tile> newTiles = [Tile('t'), Tile('e'), Tile('r')];
    b = addTilesToBoard(b, Map.fromIterables(newPositions, newTiles));
    print(b);
    List<Position> fullPositions = b.getFullWord(newPositions);
    for (Position p in fullPositions) {
      print(p);
      assert((oldPositions + newPositions).contains(p));
    }
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

Board addTilesToBoard(Board b, Map<Position, Tile> tiles) {
  for (Position p in tiles.keys) {
    b.addTileToPosition(tiles[p]!, p);
  }
  return b;
}
