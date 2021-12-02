import 'package:flutter/material.dart';
import 'package:scrabble/game/classes/Game.dart';
import 'package:scrabble/networking/User.dart';

class ScoreListDrawer extends StatelessWidget {
  ScoreListDrawer({Key? key, required this.game, required this.uidsToPlayers}): super(key: key);

  final Game game;
  final Map<String, User> uidsToPlayers;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: scoreList(),
      ),
    );
  }

  List<Widget> scoreList() {
    List<Widget> scoreList = [
      drawerHeader(),
      userScoreTile()
    ];
    scoreList.addAll(otherScoreTiles());
    return scoreList;
  }

  DrawerHeader drawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: Text(
        'Scores',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );
  }

  ListTile userScoreTile() {
    return ListTile(
      title: Text("Your score: ${game.usersScore}"),
    );
  }

  List<ListTile> otherScoreTiles() {
    List<ListTile> otherScoreTiles = [];
    for (String uid in uidsToPlayers.keys) {
      otherScoreTiles.add(otherScoreTile(uid, uidsToPlayers[uid]!));
    }
    return otherScoreTiles;
  }

  ListTile otherScoreTile(String uid, User userData) {
    return ListTile(
      title: Text("${userData.username}'s score: ${game.scoreForPlayer(uid)}"),
      subtitle: Text(userData.email),
    );
  }
}
