import 'package:flutter/material.dart';
import 'package:scrabble/networking/GameListAccess.dart';

class GamesPage extends StatefulWidget {
  GamesPage({Key? key, required this.gameListAccess}): super(key: key);

  final GameListAccess gameListAccess;

  @override
  State<StatefulWidget> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/game");
        },
        child: Text("Game"),
      ),
    );
  }
}
