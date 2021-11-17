import "package:cloud_firestore/cloud_firestore.dart";
import 'package:scrabble/networking/User.dart';

class FriendAccess {
  FirebaseFirestore _database;
  String _uid;
  late Stream<QuerySnapshot> friendStream;
  late CollectionReference _friends;
  late CollectionReference _users;

  FriendAccess(this._database, this._uid) {
    _users = _database.collection("users");
    _friends = _users
        .doc(_uid)
        .collection("friends");
    friendStream = _friends.snapshots();
  }

  Future<bool> addFriend(String friendEmail) async {
    QuerySnapshot friendsWithEmail = await _queryFriendWithEmail(friendEmail);
    if (friendsWithEmail.size > 0) {
      DocumentSnapshot newFriend = friendsWithEmail.docs[0];
      String friendUid = newFriend.id;
      if (friendUid != _uid) {
        await _updateFriendLists(friendUid);
        return true;
      } else
        throw Exception("You cannot add yourself as a friend");
    } else
      return false;
  }

  Future<QuerySnapshot> _queryFriendWithEmail(String friendEmail) {
    return _users
        .where("email", isEqualTo: friendEmail)
        .get();
  }

  Future<void> _updateFriendLists(String friendUID) {
    WriteBatch batch = _database.batch();
    DocumentReference friendEntry = _friends.doc(friendUID);
    batch.set(friendEntry, {"added": true});
    DocumentReference entryInFriendListOfFriend = getFriendListOfUser(friendUID).doc(_uid);
    batch.set(entryInFriendListOfFriend, {"added": true});
    return batch.commit();
  }

  DocumentReference getFriendDocument(String uid) {
    return _users.doc(uid);
  }

  CollectionReference getFriendListOfUser(String uid) {
    return _users.doc(uid).collection("friends");
  }

  Future<User> getFriendData(String friendUid) async {
    DocumentSnapshot friendSnap = await _users.doc(friendUid).get();
    Map<String, dynamic> friendData = friendSnap.data() as Map<String, dynamic>;
    return User.fromJson(friendData);
  }
}
