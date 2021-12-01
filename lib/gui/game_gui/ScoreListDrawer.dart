import 'package:flutter/material.dart';
import 'package:scrabble/game/classes/Game.dart';
import 'package:scrabble/networking/GameAccess.dart';
import 'package:scrabble/networking/User.dart';

class ScoreListDrawer extends StatelessWidget {
  ScoreListDrawer({Key? key, required this.game, required this.gameAccess}): super(key: key);

  final Game game;
  final GameAccess gameAccess;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: gameAccess.getOtherUsers(game),
      builder: (BuildContext context, AsyncSnapshot<Map<String, User>> snapshot) {
        return Drawer(
          child: ListView(
            children: scoreList(snapshot),
          ),
        );
        },
    );
  }

  List<Widget> scoreList(AsyncSnapshot<Map<String,User>> usersSnapshot) {
    List<Widget> scoreList = [
      drawerHeader(),
      userScoreTile()
    ];
    scoreList.addAll(otherScoreTiles(usersSnapshot));
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

  List<ListTile> otherScoreTiles(AsyncSnapshot<Map<String,User>> usersSnapshot) {
    if (usersSnapshot.hasData) {
      return generateOtherScoreTiles(usersSnapshot.data!);
    } else if (usersSnapshot.connectionState == ConnectionState.waiting) {
      return [ListTile(title: Text("Loading Other Users"),)];
    } else {
      return [ListTile(title: Text("Could Not Load Other Users"))];
    }
  }

  List<ListTile> generateOtherScoreTiles(Map<String, User> otherUsers) {
    List<ListTile> otherScoreTiles = [];
    for (String uid in otherUsers.keys) {
      otherScoreTiles.add(otherScoreTile(uid, otherUsers[uid]!));
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
