import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unpub/screens/game_list.dart';
import 'package:unpub/screens/game_search_bar.dart';
import 'package:unpub/unpub_service.dart';

class GameChoiceScreen extends StatefulWidget {
  final UnpubService service;
  const GameChoiceScreen({
    @required this.service,
  }) : super();

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
        service: widget.service,
        gameSelected: (game) => Navigator.of(context).pop(game),
      ),
    );
  }
}
