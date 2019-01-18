import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unpub/screens/game_list.dart';
import 'package:unpub/screens/game_search_bar.dart';

class GameChoiceScreen extends StatefulWidget {
  const GameChoiceScreen() : super();

  @override
  _GameChoiceScreenState createState() => _GameChoiceScreenState();
}

class _GameChoiceScreenState extends State<GameChoiceScreen> {
  String _searchTerm = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Game'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: GameSearchBar(onTextChanged: (text) {
            setState(() {
              _searchTerm = text;
            });
          }),
        ),
      ),
      body: GameList(
        filter: _searchTerm,
        gameSelected: (game) => Navigator.of(context).pop(game),
      ),
    );
  }
}
