import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrabble/Authentication.dart';
import 'package:scrabble/FriendAccess.dart';
import 'FriendsPage.dart';
import 'ProfilePage.dart';
import 'GamesPage.dart';

class BottomNavPage extends StatefulWidget {
  @override
  State createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  late List<Widget> _tabs;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    _tabs = [
      Consumer<Authentication>(
          builder: (context, authState, _) => ProfilePage(signOut: authState.signOut, userName: authState.displayName,)
      ),
      Consumer<Authentication>(
          builder: (context, authState, _) => FriendsPage(friendAccess: FriendAccess(authState.userId!),)
      ),
      GamesPage()
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Scrabble"),
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          _navBarChoice(Icon(Icons.home), "Profile"),
          _navBarChoice(Icon(Icons.person), "Friends"),
          _navBarChoice(Icon(Icons.menu), "Games"),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  BottomNavigationBarItem _navBarChoice(Icon icon, String label) {
    return BottomNavigationBarItem(
        icon: icon,
      label: label,
    );
  }
}