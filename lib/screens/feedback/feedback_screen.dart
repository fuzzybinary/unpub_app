import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unpub/screens/feedback/choice_button_bar.dart';
import 'package:unpub/screens/feedback/confirm_dialog.dart';

import 'package:unpub/screens/feedback/feedback_screen_bloc.dart';
import 'package:unpub/screens/feedback/simple_text_field.dart';
import 'package:unpub/screens/feedback/submit_feedback_dialog.dart';
import 'package:unpub/screens/game_list_screen.dart';
import 'package:unpub/widgets/ensure_visible_widget.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key key, this.bloc}) : super(key: key);

  final FeedbackScreenBloc bloc;

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState(bloc);
}

class _FeedbackScreenState extends State<FeedbackScreen>
    with WidgetsBindingObserver {
  final FeedbackScreenBloc bloc;

  final FocusNode focusPlayers = FocusNode();
  final FocusNode focusGameLength = FocusNode();
  final FocusNode focusFirstPlayerScore = FocusNode();
  final FocusNode focusLastPlayerScore = FocusNode();

  final FocusNode focusOneChange = FocusNode();
  final FocusNode focusFavoritePart = FocusNode();
  final FocusNode focusAdditionalComments = FocusNode();

  _FeedbackScreenState(FeedbackScreenBloc givenBloc)
      : bloc = givenBloc ?? FeedbackScreenBloc();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      child: Column(
        children: <Widget>[
          IntrinsicHeight(
            child: AppBar(
              title: Text('Feedback'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => _clearForm(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: _buildBody(theme),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _clearForm(BuildContext context) async {
    final shouldClear = await showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
            text: 'Are you sure you want to clear this feedback form?',
          ),
    );
    if (shouldClear != null && shouldClear) {
      setState(() {
        bloc.reset();
      });
    }
  }

  Widget _buildGameTitle(ThemeData theme) {
    final title = bloc.selectedGame?.game ?? 'Select Game';
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

  Widget _buildBody(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Game', style: theme.textTheme.headline),
          Container(
            decoration:
                BoxDecoration(border: Border(top: BorderSide(width: 1))),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(20),
            child: _buildGameTitle(theme),
          ),
          Text('Game Session Overview', style: theme.textTheme.headline),
          Container(
            decoration:
                BoxDecoration(border: Border(top: BorderSide(width: 1))),
            padding: EdgeInsets.all(20),
            child: _buildFirstPage(),
          ),
          Text('Game Ratings', style: theme.textTheme.headline),
          Container(
            decoration:
                BoxDecoration(border: Border(top: BorderSide(width: 1))),
            padding: EdgeInsets.all(20),
            child: _buildSecondPage(),
          ),
          Text('Game Comments', style: theme.textTheme.headline),
          Container(
            decoration:
                BoxDecoration(border: Border(top: BorderSide(width: 1))),
            padding: EdgeInsets.all(20),
            child: _buildThirdPage(),
          ),
          Container(
            alignment: Alignment.center,
            child: RaisedButton(
              child: Text(
                'Submit Feedback',
                style: theme.textTheme.button.copyWith(
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
              padding: EdgeInsets.fromLTRB(30, 8, 30, 8),
              color: theme.accentColor,
              onPressed: () => _submitFeedback(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFirstPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SimpleTextField(
          value: bloc.players,
          label: 'Players',
          icon: Icon(Icons.people),
          keyboardType: TextInputType.number,
          focus: focusPlayers,
          nextFocus: focusGameLength,
          onChanged: (value) {
            bloc.players = value;
          },
        ),
        SimpleTextField(
          value: bloc.gameTime,
          label: 'Game Length',
          icon: Icon(Icons.timer),
          keyboardType: TextInputType.number,
          focus: focusGameLength,
          nextFocus: focusFirstPlayerScore,
          onChanged: (value) {
            bloc.gameTime = value;
          },
        ),
        SimpleTextField(
          value: bloc.firstPlaceScore,
          label: 'First Place Store',
          icon: Icon(Icons.timeline),
          focus: focusFirstPlayerScore,
          keyboardType: TextInputType.number,
          nextFocus: focusLastPlayerScore,
          onChanged: (value) {
            bloc.firstPlaceScore = value;
          },
        ),
        SimpleTextField(
          value: bloc.lastPlaceStore,
          label: 'Last Place Store',
          icon: Icon(Icons.timeline),
          keyboardType: TextInputType.number,
          focus: focusLastPlayerScore,
          onChanged: (value) {
            bloc.lastPlaceStore = value;
          },
        ),
        ChoiceButtonBar(
          label: 'Did you win?',
          value: bloc.didWin ? DiscreetAnswer.Yes : DiscreetAnswer.No,
          onChange: (answer) {
            setState(() {
              bloc.didWin = answer == DiscreetAnswer.Yes;
            });
          },
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

  Widget _buildSecondPage() {
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

  Widget _buildFreeForm({
    String labelText,
    String value,
    ValueChanged<String> onChanged,
    FocusNode focusNode,
  }) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: EnsureVisibleWidget(
        focusNode: focusNode,
        child: TextField(
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
          ),
          focusNode: focusNode,
          maxLines: 5,
          controller: TextEditingController(text: value),
          onChanged: (value) {
            onChanged(value);
          },
        ),
      ),
    );
  }

  Widget _buildThirdPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ChoiceButtonBar(
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
          value: bloc.predictableWhy,
          focusNode: FocusNode(),
          onChanged: (value) => bloc.predictableWhy = value,
        ),
        ChoiceButtonBar(
          label: 'Would you play again?',
          value: bloc.playAgain,
          onChange: (value) {
            setState(() {
              bloc.playAgain = value;
            });
          },
        ),
        ChoiceButtonBar(
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
          value: bloc.oneChange,
          focusNode: focusOneChange,
          onChanged: (value) => bloc.oneChange = value,
        ),
        _buildFreeForm(
          labelText: 'What was your favorite part of this game?',
          value: bloc.favoritePart,
          focusNode: focusFavoritePart,
          onChanged: (value) => bloc.favoritePart = value,
        ),
        _buildFreeForm(
          labelText: 'Additional comments?',
          value: bloc.additionalComments,
          focusNode: focusAdditionalComments,
          onChanged: (value) => bloc.additionalComments = value,
        )
      ],
    );
  }

  Future<void> _submitFeedback() async {
    final success = await showDialog(
      context: context,
      builder: (context) => SubmitFeedbackDialog(bloc: bloc),
      barrierDismissible: false,
    );

    if (success != null && success) {
      setState(() {
        bloc.reset();
      });
    }
  }
}
