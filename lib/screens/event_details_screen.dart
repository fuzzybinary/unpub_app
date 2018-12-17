import 'package:flutter/material.dart';
import 'package:unpub/models.dart';
import 'package:unpub/screens/game_details_screen.dart';
import 'package:unpub/unpub_service.dart';
import 'package:unpub/widgets/game_list_item.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({Key key, @required this.event}) : super(key: key);

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  Future _eventLoadFuture;
  List<GameSummary> _games;

  @override
  void initState() {
    super.initState();
    _eventLoadFuture = _loadEvent();
  }

  Future _loadEvent() async {
    _games = await UnpubService().fetchGamesAtEvent(widget.event);
  }

  Widget _buildGameList() {
    return ListView.separated(
      padding: EdgeInsets.only(top: 5),
      itemCount: _games.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        return GameListItem(
          game: _games[index],
          onTap: (game) => _navigateToGame(game),
        );
      },
    );
  }

  void _navigateToGame(GameSummary game) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => GameDetailsScreen(game: game),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.name),
      ),
      body: FutureBuilder(
        future: _eventLoadFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return _buildGameList();
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
