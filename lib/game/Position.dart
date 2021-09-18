import 'package:scrabble/game/Direction.dart';

class Position {
  int column;
  int row;

  Position( this.column, this.row);

  Position getNeighbor(Direction dir) {
    switch(dir) {
      case Direction.north:
        return Position(column, row - 1);
      case Direction.south:
        return Position(column, row + 1);
      case Direction.east:
        return Position(column + 1, row);
      case Direction.west:
        return Position(column - 1, row);
    }
  }

  @override
  bool operator ==(Object other) => other is Position
      && other.column == this.column && other.row == this.row;

  @override
  String toString() => "($column, $row)";

  @override
  // TODO: implement hashCode
  int get hashCode => this.toString().hashCode;
}