import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scrabble/networking/GameListAccess.dart';

class GameList extends StatefulWidget{
  GameList({Key? key, required this.gameListAccess}): super(key: key);

  final GameListAccess gameListAccess;

  @override
  State<StatefulWidget> createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.gameListAccess.gamesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: SizedBox(
              width: 60,
              height: 80,
              child: CircularProgressIndicator(),
            ));
          }

          return ListView(
            children: [],
          );
        }
    );
  }
}

class _GameButton extends StatelessWidget {
  _GameButton({Key? key, required this.gameListAccess}): super(key: key);

  final GameListAccess gameListAccess;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
