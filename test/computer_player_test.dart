import 'package:flutter_test/flutter_test.dart';
import 'package:scrabble/ai/Dawg.dart';
import 'package:scrabble/ai/ComputerPlayer.dart';
import 'package:scrabble/game/classes/Board.dart';
import 'package:scrabble/game/classes/Tile.dart';
import 'package:scrabble/utility/Position.dart';
import 'package:scrabble/utility/Direction.dart';

main() {
  test("Anchor positions test", () {
    Board b = generateBoard({
      Position(7, 7): Tile("s"),
      Position(7, 8): Tile('h'),
      Position(7, 9): Tile('o'),
      Position(7, 10): Tile('p')
    });
    print(b);
    ComputerPlayer player = ComputerPlayer(Dawg([]), [], b);
    List<Position> downAnchors = player.getAnchorPositions(Direction.south);
    print(downAnchors);
    testLists(downAnchors, [Position(7, 6), Position(7, 11)]);
    List<Position> acrossAnchors = player.getAnchorPositions(Direction.east);
    print(acrossAnchors);
    testLists(acrossAnchors, [
      Position(6, 7), Position(8, 7), Position(6, 8), Position(8, 8),
      Position(6, 9), Position(8, 9), Position(6, 10), Position(8, 10)
    ]);
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

void testLists(List listA, List listB) {
  assert(listA.length == listB.length);
  for (int i=0; i<listB.length; i++) {
    assert(listA.contains(listB[i]));
  }
}
