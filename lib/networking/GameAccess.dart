import "package:cloud_firestore/cloud_firestore.dart";
import 'package:scrabble/game/classes/Board.dart';
import 'package:scrabble/game/classes/TileBag.dart';
import 'package:scrabble/game/classes/Tile.dart';
import 'package:scrabble/game/classes/Game.dart';
import 'package:scrabble/game/classes/Player.dart';

class GameAccess {
  FirebaseFirestore _database;
  String _gameId;
  String _uid;
  late DocumentReference _gameDoc;
  late CollectionReference _playerCollection;
  late DocumentReference _usersDocument;
  late CollectionReference _users;

  GameAccess(this._database, this._gameId, this._uid) {
    _gameDoc = _database
        .collection("games")
        .doc(_gameId);
    _playerCollection = _gameDoc
        .collection("players");
    _usersDocument = _playerCollection
        .doc(_uid);
    _users = _database
        .collection("users");
  }
}
