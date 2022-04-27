import 'package:flutter_test/flutter_test.dart';
import 'package:scrabble/ai/Dawg.dart';
import 'package:scrabble/ai/ComputerPlayer.dart';
import 'package:scrabble/game/classes/Board.dart';
import 'package:scrabble/game/classes/Tile.dart';
import 'package:scrabble/game/game_data/ValidWords.dart';
import 'package:scrabble/utility/Position.dart';
import 'package:scrabble/utility/Direction.dart';
import 'package:scrabble/utility/Pair.dart';
import 'package:scrabble/game/classes/TileBag.dart';

main() {
  test("Anchor positions test", () {
    Board b = generateBoard({
      Position(7, 7): Tile("s"),
      Position(7, 8): Tile('h'),
      Position(7, 9): Tile('o'),
      Position(7, 10): Tile('p')
    });
    print(b);
    ComputerPlayer player = ComputerPlayer(Dawg(["ajklaf", "bjlkaj", "cjlaewl"]), [], b);
    List<Position> downAnchors = player.getAnchorPositions(Direction.south);
    print(downAnchors);
    testLists(downAnchors, [Position(7, 6)]);
    List<Position> acrossAnchors = player.getAnchorPositions(Direction.east);
    print(acrossAnchors);
    testLists(acrossAnchors, [
      Position(6, 7), Position(6, 8),
      Position(6, 9), Position(6, 10),
    ]);
  });
  test("Move generation test", () {
    Board b = generateBoard({
      Position(7, 7): Tile("s"),
      Position(7, 8): Tile('h'),
      Position(7, 9): Tile('o'),
      Position(7, 10): Tile('p')
    });
    print(b);
    Dawg dawg = Dawg(validWords.toList());
    print("Dawg constructed");
    List<Tile> hand = [
      Tile("C"), Tile("B"), Tile("O"), Tile("I"), Tile("G"), Tile("A"), Tile("A")
    ];
    ComputerPlayer player = ComputerPlayer(dawg, hand, b);
    print(player.getAnchorPositions(Direction.east));
    List<Pair<String, int>> wordsAndScores = player.makeMove();
    print(wordsAndScores);
    print(b);
    for (Pair<String, int> pair in wordsAndScores) {
      print(dawg.contains(pair.a));
      assert(validWords.contains(pair.a));
    }
  });
  test("Multiple plays", () {
    Board b = generateBoard({
      Position(7, 7): Tile("s"),
      Position(7, 8): Tile('h'),
      Position(7, 9): Tile('o'),
      Position(7, 10): Tile('p')
    });
    print(b);
    Dawg dawg = Dawg(validWords.toList());
    TileBag bag = TileBag();
    for (int i=0;i<80;i++)
      bag.drawTile();
    List<Tile> hand = [];
    ComputerPlayer player = ComputerPlayer(dawg, hand, b);
    player.updateCrossChecks([
      Position(7,7), Position(7, 8),
      Position(7, 9), Position(7, 10)
    ]);
    while (!bag.isEmpty()) {
      while (player.hand.length < 7) {
        Tile? tile = bag.drawTile();
        if (tile != null)
          player.hand.add(tile);
      }
      print(player.hand);
      List<Pair<String, int>> wordsAndScores = player.makeMove();
      print(wordsAndScores);
      print(b);
      for (Pair<String, int> pair in wordsAndScores)
        assert(validWords.contains(pair.a));
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

void testLists(List listA, List listB) {
  assert(listA.length == listB.length);
  for (int i=0; i<listB.length; i++) {
    assert(listA.contains(listB[i]));
  }
}
