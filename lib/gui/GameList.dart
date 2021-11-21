import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scrabble/networking/GameListAccess.dart';
import 'package:scrabble/networking/GameAccess.dart';
import 'package:scrabble/networking/User.dart';
import 'package:scrabble/game/classes/Game.dart';
import 'package:scrabble/utility/Pair.dart';
import 'package:scrabble/gui/Pages/GamePage.dart';

class GameList extends StatefulWidget{
  GameList({Key? key, required this.gameListAccess, required this.uid}): super(key: key);

  final GameListAccess gameListAccess;
  final String uid;

  @override
  State<StatefulWidget> createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.gameListAccess.gamesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: SizedBox(
              width: 60,
              height: 80,
              child: CircularProgressIndicator(),
            ));
          }

          if (snapshot.hasData) {
            return ListView(
              children: _getCards(snapshot.data!),
            );
          }

          else {
            return Text('Something went wrong');
          }
        }
    );
  }

  List<Widget> _getCards(QuerySnapshot snapshot) {
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map((DocumentSnapshot snap) {
        return _loadGameCard(snap.id, widget.gameListAccess.getGameAndUserData(snap));
      }).toList();
    }
    return [
      ListTile(title: Text("You're not in any games now"),)
    ];
  }

  Widget _loadGameCard(String gameId, Future<Pair<Game, Map<String, User>>> gameAndOtherPlayers) {
    return FutureBuilder(
      future: gameAndOtherPlayers,
      builder: (BuildContext context, AsyncSnapshot<Pair<Game, Map<String, User>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListTile(
              title: Text("Loading")
          );
        } else if (snapshot.hasData) {

          return _GameCard(
            uid: widget.uid,
            gameListAccess: widget.gameListAccess,
            gameId: gameId,
            game: snapshot.data!.a,
            uidsToPlayers: snapshot.data!.b,
          );
        }
        return ListTile(
          title: Text("Could not load this game"),
        );
      },
    );
  }
}

class _GameCard extends StatelessWidget {
  _GameCard({
    Key? key,
    required this.uid,
    required this.gameListAccess,
    required this.gameId,
    required this.game,
    required this.uidsToPlayers
  }):super(key: key);

  final String uid;
  final GameListAccess gameListAccess;
  final String gameId;
  final Game game;
  final Map<String, User> uidsToPlayers;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('Game with: ${_playerUsernamesString()}'),
            subtitle: Text("${_currentPlayer()} Turn"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text("To Game"),
                onPressed:() {
                  Navigator.pushNamed(context, "/game",
                      arguments: GamePageArguments(
                          GameAccess(gameListAccess.database, gameId, uid)
                      )
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }

  String _playerUsernamesString() {
    String usernamesString = "";
    for (User player in uidsToPlayers.values) {
      usernamesString += "${player.username}, ";
    }
    usernamesString.trimRight();
    return usernamesString;
  }

  String _currentPlayer() {
    if (uidsToPlayers.containsKey(game.currentPlayer))
      return "${uidsToPlayers[game.currentPlayer]!.username}'s";
    return "Your";
  }
}
