import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:scrabble/networking/FriendAccess.dart';
import 'package:scrabble/networking/User.dart';

class FriendList extends StatefulWidget{
  FriendList({Key? key, required this.friendAccess}): super(key: key);

  final FriendAccess friendAccess;

  @override
  State<StatefulWidget> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: widget.friendAccess.friendStream,
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
            children: _getTiles(snapshot.data!),
          );
        }
    );
  }

  List<Widget> _getTiles(QuerySnapshot doc) {
    if (doc.docs.isNotEmpty) {
      return doc.docs.map((DocumentSnapshot document) {
        return _FriendTile(
          friend: widget.friendAccess.getFriendData(document.id),
        );
      }).toList();
    } else {
      return [ListTile(
        title: Text("You don't seem to have any friends"),
      )];
    }
  }
}

class _FriendTile extends StatefulWidget{
  _FriendTile({Key? key, required this.friend}): super(key: key);

  final Future<User> friend;

  @override
  State<StatefulWidget> createState() => _FriendTileState();
}

class _FriendTileState extends State<_FriendTile> {
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
