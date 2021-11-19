import 'package:flutter/material.dart';
import 'package:scrabble/networking/User.dart';

class FriendTile extends StatefulWidget{
  FriendTile({Key? key, required this.friend}): super(key: key);

  final Future<User> friend;

  @override
  State<StatefulWidget> createState() => _FriendTileState();
}

class _FriendTileState extends State<FriendTile> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.friend,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListTile(
                title: Text("Loading")
            );
          } else if (snapshot.hasError) {
            return ListTile(
                title: Text("Could not load this friend")
            );
          }
          return ListTile(
            title: Text(snapshot.data!.username),
            subtitle: Text(snapshot.data!.email),
          );
        }
    );
  }
}
