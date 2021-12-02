import 'package:scrabble/game/classes/Tile.dart';

class Player {
  String uid;
  List<Tile?> hand;

  Player(this.uid, this.hand);

  bool get handIsEmpty {
    for (Tile? tile in hand) {
      if (tile != null)
        return false;
    }
    return true;
  }

  Map<String, dynamic> toJson() {
    return {
      "hand": hand.map((Tile? t) {
        if (t != null)
          return t.letter; // All tiles with the same letter in a player's hand have the same traits
        return null;
      }).toList()
    };
  }

  Player.fromJson(this.uid, Map<String, dynamic> json)
      : hand = (json["hand"] as List<dynamic>).map((item) {
          if (item != null)
            return Tile(item);
          return null;
        }).toList();
}
