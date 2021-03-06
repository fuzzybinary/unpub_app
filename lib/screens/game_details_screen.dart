import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unpub/models.dart';
import 'package:unpub/screens/feedback/feedback_screen.dart';
import 'package:unpub/screens/feedback/feedback_screen_bloc.dart';
import 'package:unpub/unpub_service.dart';

class GameDetailsScreen extends StatelessWidget {
  final GameSummary game;
  final UnpubService service;

  const GameDetailsScreen({
    @required this.game,
    @required this.service,
  }) : super();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bodyTheme = theme.textTheme.body1.copyWith(fontSize: 20);
    return Scaffold(
      appBar: AppBar(
        title: Text(game.game),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                game.game,
                style: theme.textTheme.display2,
              ),
              Text(
                'By: ${game.designer}',
                style: theme.textTheme.subhead,
              ),
              Container(
                padding: EdgeInsets.only(top: 30),
                child: Text('Categories: ${game.categoryString}'),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
                child: Text(
                  game.description,
                  style: bodyTheme,
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: RaisedButton(
                  child: Text(
                    'Leave Feedback',
                    style: theme.textTheme.button.copyWith(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(30, 8, 30, 8),
                  color: theme.accentColor,
                  onPressed: () => _leaveFeedbackTapped(context),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _leaveFeedbackTapped(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return FeedbackScreen(
          bloc: FeedbackScreenBloc(
            selectedGame: game,
            service: service,
          ),
          service: service,
        );
      }),
    );
  }
}
