import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scrabble/networking/GameListAccess.dart';
import 'package:scrabble/networking/FriendAccess.dart';
import 'package:scrabble/networking/User.dart';
import 'package:scrabble/gui/FriendList.dart';
import 'package:scrabble/gui/LoadingDialog.dart';
import 'package:scrabble/gui/GeneralUtilities.dart';

class CreateGamePageArguments {
  final String uid;
  final GameListAccess gameListAccess;
  final FriendAccess friendAccess;

  CreateGamePageArguments(this.uid, this.friendAccess, this.gameListAccess);
}

class CreateGamePage extends StatefulWidget {
  CreateGamePage({
    Key? key,
    required this.uid,
    required this.gameListAccess,
    required this.friendAccess
  }): super(key: key);

  final String uid;
  final FriendAccess friendAccess;
  final GameListAccess gameListAccess;

  @override
  State<StatefulWidget> createState() => _CreateGamePageState();
}

class _CreateGamePageState extends State<CreateGamePage> {
  final int maxPlayers = 3;
  List<String> selectedFriendUIDS = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a Game"),
      ),
      body: FriendList(
          friendAccess: widget.friendAccess,
          generateChild: generateFriendCheckBox
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Start game",
        child: Icon(Icons.add),
        onPressed: () {
          if (selectedFriendUIDS.isNotEmpty) {
            startGame();
          } else {
            showErrorDialogue(context, "Not Enough Players", "You need to add at least one player");
          }
        },
      ),
    );
  }

  bool isFriendSelected(DocumentSnapshot friendDoc) =>
      selectedFriendUIDS.contains(friendDoc.id);

  Widget generateFriendCheckBox(DocumentSnapshot friendDoc) {
    return FutureBuilder(
        future: widget.friendAccess.getFriendData(friendDoc.id),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListTile(title: Text("Loading"),);
          } else if (snapshot.hasData) {
            User friend = snapshot.data!;
            return friendSelectBox(friendDoc, friend);
          } else {
            return ListTile(title: Text("Could not load this friend"),);
          }
        }
    );
  }

  CheckboxListTile friendSelectBox(DocumentSnapshot friendDoc, User friend) {
    return CheckboxListTile(
        title: Text(friend.username),
        subtitle: Text(friend.email),
        value: isFriendSelected(friendDoc),
        onChanged: (_) {
          selectOrUnselectFriend(friendDoc);
        }
    );
  }

  void selectOrUnselectFriend(DocumentSnapshot friendDoc) {
    setState(() {
      if (!isFriendSelected(friendDoc) && selectedFriendUIDS.length < maxPlayers) {
        selectedFriendUIDS.add(friendDoc.id);
      } else if (isFriendSelected(friendDoc)) {
        selectedFriendUIDS.remove(friendDoc.id);
      }
    });
  }

  void startGame() async {
    selectedFriendUIDS.insert(0, widget.uid);
    Future gameFuture = widget.gameListAccess.createGame(selectedFriendUIDS);
    showLoadingDialog(gameFuture);
    setState(() {
      selectedFriendUIDS = [];
    });
  }

  void showLoadingDialog(Future gameFuture) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => LoadingDialog(
            future: gameFuture,
            errorWidget: simpleAlert(context, "Something went wrong", "Game could not be created"),
            successWidget: gameCreationAlert()
        )
    );
  }

  AlertDialog gameCreationAlert() {
    return AlertDialog(
      title: Text("Game Created Successfully"),
      content: Text("You can find it in the games page"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text("OK")
        ),
      ],
    );
  }
}
