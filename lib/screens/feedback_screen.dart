import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unpub/screens/feedback_screen_bloc.dart';
import 'package:unpub/screens/game_list_screen.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  FeedbackScreenBloc bloc = FeedbackScreenBloc();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: <Widget>[
        IntrinsicHeight(
          child: AppBar(
            title: Text('Feedback'),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('Game', style: theme.textTheme.headline),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(top: BorderSide(width: 1))),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(20),
                    child: _buildGameTitle(),
                  ),
                  Text('Game Session Overview',
                      style: theme.textTheme.headline),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(top: BorderSide(width: 1))),
                    padding: EdgeInsets.all(20),
                    child: _buildFirstPage(context),
                  ),
                  Text('Game Ratings', style: theme.textTheme.headline),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(top: BorderSide(width: 1))),
                    padding: EdgeInsets.all(20),
                    child: _buildSecondPage(context),
                  ),
                  Text('Game Comments', style: theme.textTheme.headline),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(top: BorderSide(width: 1))),
                    padding: EdgeInsets.all(20),
                    child: _buildThirdPage(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _selectedColor(ThemeData theme, bool isSelected) {
    if (isSelected != null && isSelected) {
      return theme.accentColor;
    }
    return Colors.transparent;
  }

  void _onDidWin(DiscreetAnswer didWin) {
    setState(() {
      bloc.didWin = didWin == DiscreetAnswer.Yes;
    });
  }

  Widget _buildGameTitle() {
    final title = bloc.selectedGame?.game ?? 'Select Game';
    final theme = Theme.of(context);
    return FlatButton(
      child: Text(
        title,
        style: theme.textTheme.display1,
      ),
      onPressed: () async {
        final newGame = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GameListScreen(forSelection: true),
        ));
        if (newGame != null) {
          bloc.selectedGame = newGame;
        }
      },
    );
  }

  Widget _buildFirstPage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Players',
            icon: Icon(Icons.person),
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
              labelText: 'Game Time',
              hintText: 'in minutes',
              icon: Icon(Icons.timer)),
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'First place score',
            icon: Icon(Icons.timeline),
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Last place score',
            icon: Icon(Icons.timeline),
          ),
        ),
        _buildChoiceButtonBar(
          context: context,
          label: 'Did you win?',
          value: bloc.didWin ? DiscreetAnswer.Yes : DiscreetAnswer.No,
          onChange: _onDidWin,
          includeMaybe: false,
        )
      ],
    );
  }

  Widget _buildRaitingSlider(
      {@required String text,
      @required double value,
      @required ValueChanged<double> onChanged}) {
    final theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomLeft,
          child: Text(text),
        ),
        Slider(
          label: value.toStringAsFixed(0),
          min: 1,
          max: 5,
          divisions: 4,
          activeColor: theme.accentColor,
          value: value,
          onChanged: (value) {
            setState(() {
              onChanged(value);
            });
          },
        )
      ],
    );
  }

  Widget _buildChoiceButtonBar(
      {@required BuildContext context,
      @required DiscreetAnswer value,
      @required String label,
      @required ValueChanged<DiscreetAnswer> onChange,
      bool includeMaybe = true}) {
    final theme = Theme.of(context);
    final buttons = <Widget>[];
    buttons.add(RaisedButton(
      child: Text('Yes'),
      color: _selectedColor(theme, value == DiscreetAnswer.Yes),
      onPressed: () {
        setState(() {
          onChange(DiscreetAnswer.Yes);
        });
      },
    ));
    if (includeMaybe) {
      buttons.add(
        RaisedButton(
          child: Text('Maybe'),
          color: _selectedColor(theme, value == DiscreetAnswer.Maybe),
          onPressed: () {
            setState(() {
              onChange(DiscreetAnswer.Maybe);
            });
          },
        ),
      );
    }
    buttons.add(
      RaisedButton(
        child: Text('No'),
        color: _selectedColor(theme, value == DiscreetAnswer.No),
        onPressed: () {
          setState(() {
            onChange(DiscreetAnswer.No);
          });
        },
      ),
    );
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: buttons,
          ),
        ],
      ),
    );
  }

  Widget _buildSecondPage(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildRaitingSlider(
          text: 'Game Length',
          value: bloc.gameLength,
          onChanged: (value) => bloc.gameLength = value,
        ),
        _buildRaitingSlider(
          text: 'Ease of Learning',
          value: bloc.easeOfLearning,
          onChanged: (value) => bloc.easeOfLearning = value,
        ),
        _buildRaitingSlider(
          text: 'Player Down Time',
          value: bloc.playerDownTime,
          onChanged: (value) => bloc.playerDownTime = value,
        ),
        _buildRaitingSlider(
          text: 'Game Decisions',
          value: bloc.gameDecisions,
          onChanged: (value) => bloc.gameDecisions = value,
        ),
        _buildRaitingSlider(
          text: 'Interactivity',
          value: bloc.interactivity,
          onChanged: (value) => bloc.interactivity = value,
        ),
        _buildRaitingSlider(
          text: 'Originality',
          value: bloc.originality,
          onChanged: (value) => bloc.originality = value,
        ),
        _buildRaitingSlider(
          text: 'Fun / Enjoyable',
          value: bloc.fun,
          onChanged: (value) => bloc.fun = value,
        ),
      ],
    );
  }

  Widget _buildFreeForm({String labelText}) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
        ),
        maxLines: 5,
      ),
    );
  }

  Widget _buildThirdPage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildChoiceButtonBar(
          context: context,
          label: 'Was the end of the game predictable?',
          value: bloc.endPredictable,
          onChange: (value) {
            setState(() {
              bloc.endPredictable = value;
            });
          },
        ),
        _buildFreeForm(
          labelText: 'If so, why?',
        ),
        _buildChoiceButtonBar(
          context: context,
          label: 'Would you play again?',
          value: bloc.playAgain,
          onChange: (value) {
            setState(() {
              bloc.playAgain = value;
            });
          },
        ),
        _buildChoiceButtonBar(
          context: context,
          label: 'Would you buy this?',
          value: bloc.buy,
          onChange: (value) {
            setState(() {
              bloc.buy = value;
            });
          },
        ),
        _buildFreeForm(
          labelText: 'What is one thing you would change?',
        ),
        _buildFreeForm(
          labelText: 'What was your favorite part of this game?',
        ),
        _buildFreeForm(
          labelText: 'Additional comments?',
        )
      ],
    );
  }
}
