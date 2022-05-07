import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scrabble/ai/ComputerPlayer.dart';
import 'package:scrabble/game/classes/Board.dart';
import 'package:scrabble/game/classes/Game.dart';
import 'package:scrabble/game/classes/Player.dart';
import 'package:scrabble/game/classes/Tile.dart';
import 'package:scrabble/game/classes/TileBag.dart';
import 'package:scrabble/utility/Pair.dart';
import 'package:scrabble/utility/Position.dart';
import 'package:scrabble/ai/Dawg.dart';

class SinglePlayerGame implements Game {
  @override
  late Board board;

  @override
  late int currentTurn;

  @override
  late bool gameOver;

  @override
  Timestamp? lastPlay;

  @override
  late List<String> playerUids;

  @override
  late Player user;
  int _usersScore = 0;
  int _computerScore = 0;

  late ComputerPlayer computerPlayer;
  late TileBag _tileBag;
  Dawg _dawg;
  int Function(List<Pair<String,int>>, List<Position>, List<Tile>, Board) _evaluationFunction;

  SinglePlayerGame(String userUid, String computerUid, this._dawg, this._evaluationFunction) {
    playerUids = [userUid, computerUid];
    board = Board();
    _tileBag = TileBag();
    gameOver = false;
    currentTurn = 0;
    List<Tile?> playerHand = [];
    List<Tile> computerHand = [];
    for (int i=0; i<7; i++) {
      playerHand.add(_tileBag.drawTile());
      computerHand.add(_tileBag.drawTile()!);
    }
    user = Player(playerUids[0], playerHand);
    computerPlayer = ComputerPlayer(_dawg, computerHand, board, _evaluationFunction);
  }

  @override
  void checkIfGameOver() {
    if (_tileBag.isEmpty() && (user.handIsEmpty || computerPlayer.hand.isEmpty))
      gameOver = true;
  }

  @override
  String get currentPlayer => playerUids[currentTurn];

  @override
  void endTurn() {
    checkIfGameOver();
    currentTurn = (currentTurn + 1) % playerUids.length;
  }

  @override
  void fillPlayerHand(Player player) {
    for (int i=0;i<player.hand.length;i++) {
      if (player.hand[i] == null)
        player.hand[i] = _tileBag.drawTile();
    }
  }

  @override
  void fillUserHand() {
    fillPlayerHand(user);
  }

  void fillComputerHand() {
    int tilesNeeded = user.hand.length - computerPlayer.hand.length;
    for (int i=0;i<tilesNeeded;i++) {
      Tile? tile = _tileBag.drawTile();
      if (tile != null)
        computerPlayer.hand.add(tile);
    }
  }

  @override
  List<String> findInvalidWords(List<String> words) {
    List<String> invalidWords = [];
    for (String word in words)
      if (!_dawg.contains(word))
        invalidWords.add(word);
    return invalidWords;
  }

  @override
  List<Pair<String, int>> getWordsAndScoresOffList(List<Position> positionList) =>
      board.getWordsAndScoresOffList(positionList);

  @override
  String highestScoringPlayerUid() {
    if (usersScore >= _computerScore)
      return playerUids[0];
    return playerUids[1];
  }

  @override
  bool get isUsersTurn => currentTurn == 0;

  @override
  bool positionsConnectedToBoard(List<Position> positionList) => board.positionsConnectedToBoard(positionList);

  @override
  bool positionsConnectedToEachOther(List<Position> positionList) =>
    board.positionsConnectedToEachOther(positionList);

  @override
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

  @override
  int scoreForPlayer(String playerUid) {
    if (playerUid == playerUids[0])
      return usersScore;
    return _computerScore;
  }

  @override
  void submitPlay(List<Pair<String, int>> wordsAndScores, List<Position> tilePositions) {
    board.lockTiles(tilePositions);
    updateScores(List
        .from(wordsAndScores
        .map((Pair wordAndScore) => wordAndScore.b))
    );
    fillUserHand();
    computerPlayer.updateCrossChecks(tilePositions);
  }

  @override
  void swapTiles(List<Tile?> tilesToSwap) {
    for (Tile? tile in tilesToSwap) {
      if (tile != null)
        _tileBag.addTileToBag(tile);
    }
    fillUserHand();
    print(_tileBag.tileCount);
  }

  @override
  Map<String, dynamic> toJson() {
   return {};
  }

  @override
  void updateScores(List<int> scores) {
    if (scores.isNotEmpty) {
      int totalIncrease = scores.reduce((total, score) => total + score);
      if (currentTurn == 0)
        _usersScore += totalIncrease;
      else
        _computerScore += totalIncrease;
    }
  }

  @override
  int get usersScore => _usersScore;

}