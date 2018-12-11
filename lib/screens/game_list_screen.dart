import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unpub/screens/game_list.dart';

class GameListScreen extends StatefulWidget {
  final bool forSelection;

  const GameListScreen({this.forSelection = false}) : super();

  @override
  _GameListScreenState createState() => _GameListScreenState();
}

class _GameListScreenState extends State<GameListScreen> {
  String _searchTerm = '';
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchTerm = _searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(children: <Widget>[
        IntrinsicHeight(
          child: AppBar(
            title: Text('Select Game'),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(48),
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: TextField(
                  maxLines: 1,
                  focusNode: _searchFocusNode,
                  controller: _searchController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.all(10),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.search,
                    ),
                    suffixIcon: _searchFocusNode.hasFocus
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.text = '';
                                _searchFocusNode.unfocus();
                              });
                            },
                          )
                        : null,
                    hintText: 'Search',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 4),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child:
              GameList(forSelection: widget.forSelection, filter: _searchTerm),
        )
      ]),
    );
  }
}
