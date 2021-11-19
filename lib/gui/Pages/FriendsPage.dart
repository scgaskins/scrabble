import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrabble/networking/FriendAccess.dart';
import 'package:scrabble/networking/User.dart';
import 'package:scrabble/gui/FriendList.dart';
import 'package:scrabble/gui/FriendTile.dart';
import 'package:scrabble/gui/GeneralUtilities.dart';

class FriendsPage extends StatefulWidget {
  FriendsPage({Key? key, required this.friendAccess}): super(key: key);

  final FriendAccess friendAccess;

  @override
  State<StatefulWidget> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  TextEditingController _addFriendInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FriendList(
          friendAccess: widget.friendAccess,
          generateChild: generateFriendTile,
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddFriendDialog,
        tooltip: "Add a friend",
        child: const Icon(Icons.add),
      ),
    );
  }

  FriendTile generateFriendTile(DocumentSnapshot friendDoc) {
    return FriendTile(
        friend: widget.friendAccess.getFriendData(friendDoc.id)
    );
  }

  void showAddFriendDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("Add a friend"),
            children: [
              submissionForm("Friend's email", _addFriendInput),
              SimpleDialogOption(
                child: Text("Add Friend"),
                onPressed: () async {
                  Future<bool> successfulAdd = widget.friendAccess.addFriend(_addFriendInput.text);
                  Navigator.of(context).pop();
                  showAddingFriendDialog(successfulAdd);
                },
              )
            ],
          );
        }
    );
  }

  void showAddingFriendDialog(Future<bool> addSuccessful) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return FutureBuilder(
            future: addSuccessful,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: SizedBox(
                  width: 60,
                  height: 80,
                  child: CircularProgressIndicator(),
                ));
              } else if (snapshot.hasError) {
                return simpleAlert(context, "Something Went Wrong", snapshot.error!.toString());
              } else if (snapshot.data! == true) {
                return simpleAlert(context, 'Friend Added', "Friend add successful");
              } else {
                return simpleAlert(context, 'Could Not Find Friend', "There is no account with that email");
              }
            },
          );
        }
    );
  }
}
