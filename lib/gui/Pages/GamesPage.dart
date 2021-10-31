import 'package:flutter/material.dart';

class GamesPage extends StatefulWidget {
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
