import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unpub/models.dart';
import 'package:unpub/unpub_service.dart';
import 'package:unpub/widgets/game_list_item.dart';

class GameList extends StatefulWidget {
  final String filter;
  final ValueChanged gameSelected;
  final UnpubService service;

  const GameList({
    Key key,
    this.filter,
    this.gameSelected,
    @required this.service,
  }) : super(key: key);

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
    if (widget.service.cachedGames != null) {
      _games = widget.service.cachedGames;
      _filterGames();
    } else {
      _initialLoadFuture = _refreshGames(ignoreCache: false);
    }
  }

  Future<void> _refreshGames({bool ignoreCache = true}) async {
    _games = await widget.service.fetchGameSummaries(ignoreCache: ignoreCache);
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

  Widget _buildBody() {
    return ListView.separated(
      padding: EdgeInsets.only(top: 5),
      itemCount: _filteredGames.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        return GameListItem(
          game: _filteredGames[index],
          onTap: widget.gameSelected,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _filterGames();

    Widget child;
    if (_initialLoadFuture != null) {
      child = FutureBuilder(
        future: _initialLoadFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return _buildBody();
            default:
              return Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      );
    } else {
      child = _buildBody();
    }
    return RefreshIndicator(
      onRefresh: _refreshGames,
      child: child,
    );
  }
}
