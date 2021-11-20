import 'package:flutter_test/flutter_test.dart';
import 'package:scrabble/networking/GameListAccess.dart';
import 'package:scrabble/networking/User.dart';
import 'package:scrabble/game/classes/Game.dart';
import 'package:scrabble/utility/Pair.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

main() {
  final FakeFirebaseFirestore instance = FakeFirebaseFirestore();
  test("Creating a game", () async {
    makeFakeUser(instance, "1a", "example1@example.com", "host");
    GameListAccess gameListAccess = GameListAccess(instance, "1");
    makeFakeUser(instance, "2b", "example2@example.com", "guest");
    DocumentReference gameRef = await gameListAccess.createGame(["1a", "2b"]);
    Pair<Game, Map<String, User>> gameAndUserData = await gameListAccess
        .getGameAndUserData(await gameRef.get());
    Game gameData = gameAndUserData.a;
    Map<String, User> playerData  = gameAndUserData.b;
    expect(playerData.keys.contains("2b"), true);
  });
}

void makeFakeUser(FakeFirebaseFirestore instance, String uid, String email, String username) async {
  User user = User(username, email);
  await instance.collection("users")
      .doc(uid)
      .set(user.toJson());
}
