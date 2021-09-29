import 'Direction.dart';

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
    if (this._inAHorizontalLineWith(other)) {
      return this.column == other.column + 1 || this.column == other.column - 1;
    } else if (this._inAVerticalLineWith(other)) {
      return this.row == other.row + 1 || this.row == other.row - 1;
    }
    return false;
  }

  bool inALineThruDirectionWith(Position other, Direction dir) {
    if (dir == Direction.north || dir == Direction.south)
      return _inAVerticalLineWith(other);
    else
      return _inAHorizontalLineWith(other);
  }

  bool _inAVerticalLineWith(Position other) {
    return row != other.row && column == other.column;
  }

  bool _inAHorizontalLineWith(Position other) {
    return column != other.column && row == other.row;
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