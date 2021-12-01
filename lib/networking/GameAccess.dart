import "package:cloud_firestore/cloud_firestore.dart";
import 'package:scrabble/game/classes/Game.dart';
import 'package:scrabble/game/classes/Player.dart';
import 'package:scrabble/networking/User.dart';
import 'package:scrabble/utility/Pair.dart';
import 'dart:async';
import 'package:stream_transform/stream_transform.dart';

class GameAccess {
  FirebaseFirestore _database;
  String _gameId;
  String _uid;
  late DocumentReference _gameDoc;
  late Stream<DocumentSnapshot> _gameStream;
  late CollectionReference _playerCollection;
  late DocumentReference _userDocument;
  late Stream<DocumentSnapshot> _userStream;
  late CollectionReference _users;
  late Stream<Pair<DocumentSnapshot, DocumentSnapshot>> gameAndUserStream;

  GameAccess(this._database, this._gameId, this._uid) {
    _gameDoc = _database
        .collection("games")
        .doc(_gameId);
    _gameStream = _gameDoc.snapshots();
    _playerCollection = _gameDoc
        .collection("players");
    _userDocument = _playerCollection
        .doc(_uid);
    _userStream = _userDocument.snapshots();
    _users = _database
        .collection("users");
    gameAndUserStream =  _gameStream.combineLatest(_userStream,
            (DocumentSnapshot gameData, DocumentSnapshot userData) => Pair(gameData, userData)
    );
  }

  Game getGameStateFromSnapshot(DocumentSnapshot gameSnap) {
    Map<String, dynamic> gameData = gameSnap.data()! as Map<String, dynamic>;
    Game game = Game.fromJson(gameData);
    return game;
  }

  Future<Game> getGameStateAsync() async {
    DocumentSnapshot gameSnap = await _gameDoc.get();
    return getGameStateFromSnapshot(gameSnap);
  }

  Player getPlayerStateFromSnapshot(DocumentSnapshot playerSnap) {
    Map<String, dynamic> userData = playerSnap.data()! as Map<String, dynamic>;
    return Player.fromJson(_uid, userData);
  }

  Future<Player> getPlayerStateAsync() async {
    DocumentSnapshot userSnap = await _userDocument.get();
    return getPlayerStateFromSnapshot(userSnap);
  }

  Future<void> updateState(Game gameState) async {
    gameState.lastPlay = Timestamp.now();
    WriteBatch batch = _database.batch();
    batch.set(_gameDoc, gameState.toJson());
    batch.set(_userDocument, gameState.user.toJson());
    return batch.commit();
  }

  Future<User> getUserInfo(String uid) async {
    DocumentSnapshot userInfo = await _users.doc(uid).get();
    Map<String, dynamic> userData = userInfo.data()! as Map<String, dynamic>;
    return User.fromJson(userData);
  }

  Future<Map<String, User>> getOtherUsers(Game game) async {
    Map<String, User> otherUsers = {};
    for (String uid in game.playerUids) {
      if (uid != _uid)
        otherUsers[uid] = await getUserInfo(uid);
    }
    return otherUsers;
  }
}
