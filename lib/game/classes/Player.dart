import 'package:scrabble/game/classes/Tile.dart';

class Player {
  int score;
  List<Tile?> hand;

  Player(this.score, this.hand);

  Map<String, dynamic> toJson() {
    return {
      "score": score,
      "hand": hand.map((Tile? t) {
        if (t != null)
          return t.letter; // All tiles with the same letter in a player's hand have the same traits
        return null;
      }).toList()
    };
  }

  Player.fromJson(Map<String, dynamic> json)
      : score = json["score"],
        hand = (json["hand"] as List<dynamic>).map((item) {
          if (item != null)
            return Tile(item);
          return null;
        }).toList();
}
