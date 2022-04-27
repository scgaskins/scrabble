class PotentialTile {
  String letter;
  bool isBlank;

  PotentialTile(this.letter, this.isBlank);

  @override
  String toString() => "{letter: $letter, isBlank: $isBlank}";
}