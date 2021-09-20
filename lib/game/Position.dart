import 'package:scrabble/game/Direction.dart';

class Position implements Comparable {
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

  bool isNeighbor(Position other) {
    if (this.inAHorizontalLineWith(other)) {
      return this.column == other.column + 1 || this.column == other.column - 1;
    } else if (this.inAVerticalLineWith(other)) {
      return this.row == other.row + 1 || this.row == other.row - 1;
    }
    return false;
  }

  bool inAVerticalLineWith(Position other) {
    return other != this && column == other.column;
  }

  bool inAHorizontalLineWith(Position other) {
    return other != this && row == other.row;
  }

  @override
  bool operator ==(Object other) => other is Position
      && other.column == this.column && other.row == this.row;

  @override
  String toString() => "($column, $row)";

  @override
  int get hashCode => this.toString().hashCode;

  // Sort by column then by row
  @override
  int compareTo(other) {
    if (other is Position) {
      if (this.column < other.column) {
        return -1;
      }
      if (this.column > other.column) {
        return 1;
      }
      if (this.column == other.column) {
        if (this.row < other.row) {
          return -1;
        }
        if (this.row > other.row) {
          return 1;
        }
        if (this.row == other.row) {
          return 0;
        }
      }
    }
    return 0;
  }
}