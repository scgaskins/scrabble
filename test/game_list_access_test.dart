import 'package:flutter_test/flutter_test.dart';
import 'package:scrabble/networking/GameListAccess.dart';
import 'package:scrabble/networking/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

main() {
  final FakeFirebaseFirestore instance = FakeFirebaseFirestore();
  test("Creating a game", () {
    makeFakeUser(instance, "1", "example1@example.com", "host");
    GameListAccess gameListAccess = GameListAccess(instance, "1");
    makeFakeUser(instance, "2", "example2@example.com", "guest");
    gameListAccess.createGame(["1", "2"]);
  });
}

void makeFakeUser(FakeFirebaseFirestore instance, String uid, String email, String username) async {
  User user = User(username, email);
  await instance.collection("users")
      .doc(uid)
      .set(user.toJson());
}
