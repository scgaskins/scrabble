import 'package:flutter/material.dart';
import 'package:scrabble/FriendAccess.dart';
import 'package:scrabble/gui/FriendList.dart';

class FriendsPage extends StatefulWidget {
  FriendsPage({Key? key, required this.friendAccess}): super(key: key);

  final FriendAccess friendAccess;

  @override
  State<StatefulWidget> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return FriendList(friendAccess: widget.friendAccess);
  }
}
