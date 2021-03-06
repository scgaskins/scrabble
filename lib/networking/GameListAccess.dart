import "package:cloud_firestore/cloud_firestore.dart";
import 'package:scrabble/game/classes/Game.dart';
import 'package:scrabble/game/classes/Player.dart';
import 'package:scrabble/networking/User.dart';
import 'package:scrabble/utility/Pair.dart';

class GameListAccess {
  FirebaseFirestore database;
  String _uid;
  late CollectionReference _games;
  late CollectionReference _users;
  late Stream<QuerySnapshot> gamesStream;
  
  GameListAccess(this.database, this._uid) {
    _users = database.collection("users");
    _games = database.collection("games");
    gamesStream = _games
        .where("playerUids", arrayContains: _uid)
        .orderBy("lastPlay", descending: true)
        .snapshots();
  }

  Future<Map<String, User>> getOtherUsers(Game game) async {
    Map<String, User> otherUsers = {};
    for (String uid in game.playerUids) {
      if (uid != _uid)
        otherUsers[uid] = await getUserData(uid);
    }
    return otherUsers;
  }

  Future<User> getUserData(uid) async {
    DocumentSnapshot userSnapshot = await _users.doc(uid).get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    return User.fromJson(userData);
  }

  Game getGameDataFromSnapshot(DocumentSnapshot gameSnapshot) {
    Map<String, dynamic> gameData = gameSnapshot.data() as Map<String, dynamic>;
    return Game.fromJson(gameData);
  }

  Future<Pair<Game, Map<String, User>>> getGameAndUserData(DocumentSnapshot gameSnapshot) async {
    Game gameData = getGameDataFromSnapshot(gameSnapshot);
    Map<String, User> uidsToPlayers = await getOtherUsers(gameData);
    return Pair(gameData, uidsToPlayers);
  }

  Future<DocumentReference> createGame(List<String> playerUIDs) async {
    DocumentReference gameDoc = await _games.add({"playerUids": playerUIDs});
    Game gameState = Game(playerUIDs);
    WriteBatch batch = _createPlayers(gameDoc, gameState);
    gameState.lastPlay = Timestamp.now();
    Map<String, dynamic> gameData = gameState.toJson();
    batch.set(gameDoc, gameData);
    await batch.commit();
    return gameDoc;
  }

  WriteBatch _createPlayers(DocumentReference gameDoc, Game gameState) {
    WriteBatch batch = database.batch();
    CollectionReference playerCollection = gameDoc.collection("players");
    for (String uid in gameState.playerUids) {
      Player playerState = Player(uid, List.filled(7, null));
      gameState.fillPlayerHand(playerState);
      batch.set(playerCollection.doc(uid), playerState.toJson());
    }
    return batch;
  }
}
