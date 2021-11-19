import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:scrabble/networking/FriendAccess.dart';
import 'package:scrabble/gui/FriendTile.dart';

class FriendList extends StatefulWidget{
  FriendList({Key? key, required this.friendAccess, required this.generateChild}): super(key: key);

  final FriendAccess friendAccess;
  final Widget Function(DocumentSnapshot friendDoc) generateChild;

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
            children: _getChildren(snapshot.data!),
          );
        }
    );
  }

  List<Widget> _getChildren(QuerySnapshot doc) {
    if (doc.docs.isNotEmpty) {
      return doc.docs.map((DocumentSnapshot document) {
        return widget.generateChild(document);
      }).toList();
    } else {
      return [ListTile(
        title: Text("You don't seem to have any friends"),
      )];
    }
  }
}


