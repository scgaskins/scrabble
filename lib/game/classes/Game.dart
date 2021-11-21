import 'package:cloud_firestore/cloud_firestore.dart';
import 'Tile.dart';
import 'Board.dart';
import 'TileBag.dart';
import 'Player.dart';
import 'package:scrabble/game/game_data/ValidWords.dart';
import 'package:scrabble/utility/Position.dart';
import 'package:scrabble/utility/Pair.dart';
import 'dart:convert';

class Game {
  late Board board;
  late TileBag _tileBag;
  late int currentTurn;
  late List<String> playerUids;
  late Map<String, int> playerScores;
  late Player user;
  late bool gameOver;
  late Timestamp? lastPlay; // The time when the game was last uploaded to Firebase

  Game(this.playerUids) {
    board = Board();
    _tileBag = TileBag();
    currentTurn = 0;
    gameOver = false;
    playerScores = Map
        .fromIterables(
        playerUids,
        List.filled(playerUids.length, 0)
    );
  }

  String get currentPlayer => playerUids[currentTurn];
  bool get isUsersTurn => currentPlayer == user.uid;

  void fillPlayerHand(Player player) {
    for (int i=0;i<player.hand.length;i++) {
      if (player.hand[i] == null)
        player.hand[i] = _tileBag.drawTile();
    }
  }

  void fillUserHand() {
    fillPlayerHand(user);
  }

  bool positionsConnectedToBoard(List<Position> positionList) =>
      board.positionsConnectedToBoard(positionList);

  bool positionsConnectedToEachOther(List<Position> positionList) =>
      board.positionsConnectedToEachOther(positionList);

  List<Pair<String, int>> getWordsAndScoresOffList(List<Position> positionList) =>
      board.getWordsAndScoresOffList(positionList);

  List<String> findInvalidWords(List<String> words) {
    List<String> invalidWords = [];
    for (String word in words)
      if (!validWords.contains(word))
        invalidWords.add(word);
    return invalidWords;
  }

  void endTurn() {
    currentTurn = (currentTurn + 1) % playerUids.length;
  }

  void submitPlay(List<Pair<String, int>> wordsAndScores, List<Position> tilePositions) {
    board.lockTiles(tilePositions);
    updateScores(List
        .from(wordsAndScores
        .map((Pair wordAndScore) => wordAndScore.b))
    );
    fillUserHand();
  }

  void updateScores(List<int> scores) {
    for (int score in scores) {
      playerScores[currentPlayer] = playerScores[currentPlayer]! + score;
    }
  }

  void returnTiles(List<Position> tilePositions) {
    for (Position p in tilePositions) {
      Tile? tile = board.removeTileFromPosition(p);
      for (int i=0;i<user.hand.length;i++) {
        if (user.hand[i] == null) {
          user.hand[i] = tile;
          break;
        }
      }
    }
  }

  void swapTiles(List<Tile?> tilesToSwap) {
    for (Tile? tile in tilesToSwap) {
      if (tile != null)
        _tileBag.addTileToBag(tile);
    }
    fillUserHand();
    print(_tileBag.tileCount);
  }

  Map<String, dynamic> toJson() {
    return {
      "board"       : JsonCodec().encode(board),
      "tileBag"     : _tileBag.toJson(),
      "currentTurn" : currentTurn,
      "playerUids"  : playerUids,
      "playerScores": playerScores,
      "gameOver"    : gameOver,
      "lastPlay"    : lastPlay
    };
  }

  Game.fromJson(Map<String, dynamic> json)
      : board        = Board.fromJson(JsonCodec().decode(json["board"])),
        _tileBag     = TileBag.fromJson(json["tileBag"]),
        currentTurn  = json["currentTurn"],
        playerUids   = (json["playerUids"] as List<dynamic>)
            .map((e) => e as String)
            .toList(),
        playerScores = Map<String, int>.from(json['playerScores'] as Map),
        gameOver = json["gameOver"],
        lastPlay     = json["lastPlay"];
}
