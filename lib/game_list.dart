import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unpub/models.dart';
import 'package:unpub/unpub_service.dart';

class GameList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  Future _initialLoadFuture;
  List<GameSummary> _games;

  @override
  void initState() {
    super.initState();
    _initialLoadFuture = _refreshGames();
  }

  Future<void> _refreshGames() async {
    _games = await UnpubService().fetchGameSummaries();
  }

  Widget _buildListItem(BuildContext context, GameSummary game) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => print(game.game),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: theme.accentColor, width: 0.5)
            ),
          ),
          child: Text(
            game.game,
            style: theme.textTheme.title,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshGames,
      child: FutureBuilder(
        future: _initialLoadFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return ListView.builder(
                itemCount: _games.length,
                
                //itemExtent: 40.0,
                itemBuilder: (context, index) {
                  return _buildListItem(context, _games[index]);
                },
              );
            default:
              return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
