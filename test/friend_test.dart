import 'package:flutter_test/flutter_test.dart';
import 'package:scrabble/networking/FriendAccess.dart';
import 'package:scrabble/networking/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

main() {
  final FakeFirebaseFirestore instance = FakeFirebaseFirestore();
  test("Adding a friend",() async {
    makeFakeUser(instance, "1", "example1@example.com", "test1");
    makeFakeUser(instance, "2", "example2@example.com", "test2");
    FriendAccess friendAccess = FriendAccess(instance, "1");
    bool successfulAdd = await friendAccess.addFriend("example2@example.com");
    expect(successfulAdd, true);
    bool friend2Added = await userHasFriend(instance, "1", "2");
    bool friend1Added = await userHasFriend(instance, "2", "1");
    expect(friend1Added, true);
    expect(friend2Added, true);
  });
}

void makeFakeUser(FakeFirebaseFirestore instance, String uid, String email, String username) async {
  User user = User(username, email);
  await instance.collection("users")
      .doc(uid)
      .set(user.toJson());
}

Future<bool> userHasFriend(FakeFirebaseFirestore instance, String uid, String friendID) async {
  DocumentSnapshot friendDoc = await instance.collection("users")
      .doc(uid)
      .collection("friends")
      .doc(friendID)
      .get();
  return friendDoc.exists;
}
