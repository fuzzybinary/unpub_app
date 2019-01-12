import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unpub/models.dart';
import 'package:unpub/screens/game_details_screen.dart';
import 'package:unpub/unpub_service.dart';
import 'package:unpub/widgets/game_list_item.dart';

class GameList extends StatefulWidget {
  final bool forSelection;
  final String filter;

  const GameList({this.forSelection = false, this.filter});

  @override
  State<StatefulWidget> createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  Future _initialLoadFuture;
  List<GameSummary> _games;
  List<GameSummary> _filteredGames;

  @override
  void initState() {
    super.initState();
    _initialLoadFuture = _refreshGames();
  }

  Future<void> _refreshGames() async {
    _games = await UnpubService().fetchGameSummaries();
    _filterGames();
  }

  void _filterGames() {
    if (widget.filter != null && _games != null) {
      final lowerFilter = widget.filter.toLowerCase();
      _filteredGames = _games.where((summary) {
        return summary.game.toLowerCase().contains(lowerFilter);
      }).toList();
    } else {
      _filteredGames = _games;
    }
  }

  void _navigateToGame(GameSummary game) {
    if (widget.forSelection) {
      Navigator.of(context).pop(game);
    } else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => GameDetailsScreen(game: game),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    _filterGames();

    return RefreshIndicator(
      onRefresh: _refreshGames,
      child: FutureBuilder(
        future: _initialLoadFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return ListView.separated(
                padding: EdgeInsets.only(top: 5),
                itemCount: _filteredGames.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  return GameListItem(
                    game: _filteredGames[index],
                    onTap: (game) => _navigateToGame(game),
                  );
                },
              );
            default:
              return Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
