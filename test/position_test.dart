import 'package:flutter_test/flutter_test.dart';
import 'package:scrabble/utility/Direction.dart';
import 'package:scrabble/utility/Position.dart';

main() {
  test("Positions with same column and row should be equal", () {
    Position p1 = Position(1, 2);
    Position p2 = Position(1, 2);
    assert(p1 == p2, true);
  });
  test("Neighbor generation test", () {
    Position p = Position(2, 2);
    Position northNeighbor = p.getNeighbor(Direction.north);
    assert(northNeighbor.column == p.column && northNeighbor.row == p.row - 1, true);
    Position southNeighbor = p.getNeighbor(Direction.south);
    assert(southNeighbor.column == p.column && southNeighbor.row == p.row + 1, true);
    Position westNeighbor = p.getNeighbor(Direction.west);
    assert(westNeighbor.column == p.column - 1 && westNeighbor.row == p.row, true);
    Position eastNeighbor = p.getNeighbor(Direction.east);
    assert(eastNeighbor.column == p.column + 1 && eastNeighbor.row == p.row, true);
  });
  test("Sorting test", () {
    List<Position> positions = [Position(2, 5), Position(3, 2), Position(2, 1)];
    positions.sort();
    List<Position> correctlySorted = [Position(2, 1), Position(2, 5), Position(3, 2)];
    for (int i=0; i<positions.length; i++) {
      print("${positions[i]} should be ${correctlySorted[i]}");
      assert(positions[i] == correctlySorted[i], true);
    }
  });
}
