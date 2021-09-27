class Pair<E, F> {
  late E a;
  late F b;
  
  Pair(this.a, this.b);
  
  @override
  String toString() {
    return "($a, $b)";
  }
  
  @override
  bool operator ==(Object other) {
    return other is Pair<E, F> && a == other.a && b == other.b;
  }

  @override
  int get hashCode => toString().hashCode;
}