import "package:cloud_firestore/cloud_firestore.dart";

class FriendAccess {
  FirebaseFirestore _database = FirebaseFirestore.instance;
  String _uid;
  late Stream<QuerySnapshot> friendStream;
  late CollectionReference _friends;
  late CollectionReference _users;

  FriendAccess(this._uid) {
    _users = _database.collection("users");
    _friends = _users
        .doc(_uid)
        .collection("friends");
    friendStream = _friends.snapshots();
  }

  Future<void> addFriend(String friendEmail) async {
    QuerySnapshot friendQuery = await _users
        .where("email", isEqualTo: friendEmail)
        .get();
    if (friendQuery.size > 0) {
      DocumentSnapshot newFriend = friendQuery.docs[0];
      String friendUid = newFriend.id;
      await _friends.doc(friendUid).set({});
      await getFriendDocument(friendUid)
          .collection("friends")
          .doc(_uid)
          .set({});
    } else
      throw Exception("Could not find friend with email $friendEmail");
  }

  DocumentReference getFriendDocument(String uid) {
    return _users.doc(uid);
  }

  Future<Map<String, dynamic>> getFriendData(String friendUid) async {
    DocumentSnapshot friendSnap = await _users.doc(friendUid).get();
    return friendSnap.data() as Map<String, dynamic>;
  }
}
