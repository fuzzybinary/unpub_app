import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unpub/screens/feedback/choice_button_bar.dart';
import 'package:unpub/screens/feedback/feedback_screen_bloc.dart';
import 'package:unpub/screens/feedback/info_dialog.dart';
import 'package:unpub/screens/feedback/raiting_slider.dart';
import 'package:unpub/screens/feedback/simple_text_field.dart';
import 'package:unpub/screens/feedback/submit_feedback_dialog.dart';
import 'package:unpub/screens/game_choice_screen.dart';
import 'package:unpub/unpub_service.dart';

class FeedbackWidget extends StatefulWidget {
  final UnpubService service;
  final FeedbackScreenBloc bloc;

  const FeedbackWidget({
    Key key,
    @required this.bloc,
    @required this.service,
  }) : super(key: key);

  @override
  _FeedbackWidgetState createState() => _FeedbackWidgetState(bloc);
}

class _FeedbackWidgetState extends State<FeedbackWidget> {
  final FeedbackScreenBloc bloc;

  final FocusNode focusPlayers = FocusNode();
  final FocusNode focusGameLength = FocusNode();
  final FocusNode focusFirstPlayerScore = FocusNode();
  final FocusNode focusLastPlayerScore = FocusNode();

  final FocusNode focusPredictWhy = FocusNode();
  final FocusNode focusOneChange = FocusNode();
  final FocusNode focusFavoritePart = FocusNode();
  final FocusNode focusAdditionalComments = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _FeedbackWidgetState(this.bloc);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: _buildBody(theme),
    );
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
          builder: (context) => GameChoiceScreen(
                service: widget.service,
              ),
        ));
        if (newGame != null) {
          bloc.selectedGame = newGame;
        }
      },
    );
  }

  Widget _buildBody(ThemeData theme) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          autovalidate: false,
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
        ),
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
          validator: (value) => bloc.requiredNumberValidator('Players', value),
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
          validator: (value) =>
              bloc.requiredNumberValidator('Game Length', value),
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
          validator: (value) =>
              bloc.requiredNumberValidator('First Place Score', value),
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
          validator: (value) =>
              bloc.requiredNumberValidator('Last Place Score', value),
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

  Widget _buildSecondPage() {
    return Column(
      children: <Widget>[
        RaitingSlider(
            text: 'Game Length',
            value: bloc.gameLength,
            onChanged: (value) => setState(() => bloc.gameLength = value)),
        RaitingSlider(
          text: 'Ease of Learning',
          value: bloc.easeOfLearning,
          onChanged: (value) => setState(() => bloc.easeOfLearning = value),
        ),
        RaitingSlider(
          text: 'Player Down Time',
          value: bloc.playerDownTime,
          onChanged: (value) => setState(() => bloc.playerDownTime = value),
        ),
        RaitingSlider(
          text: 'Game Decisions',
          value: bloc.gameDecisions,
          onChanged: (value) => setState(() => bloc.gameDecisions = value),
        ),
        RaitingSlider(
          text: 'Interactivity',
          value: bloc.interactivity,
          onChanged: (value) => setState(() => bloc.interactivity = value),
        ),
        RaitingSlider(
          text: 'Originality',
          value: bloc.originality,
          onChanged: (value) => setState(() => bloc.originality = value),
        ),
        RaitingSlider(
          text: 'Fun / Enjoyable',
          value: bloc.fun,
          onChanged: (value) => setState(() => bloc.fun = value),
        ),
      ],
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
        SimpleTextField(
          label: 'If so, why?',
          value: bloc.predictableWhy,
          focus: focusPredictWhy,
          freeForm: true,
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
        SimpleTextField(
          label: 'What is one thing you would change?',
          value: bloc.oneChange,
          focus: focusOneChange,
          freeForm: true,
          validator: (value) =>
              bloc.requiredFieldValidator('This field', value),
          onChanged: (value) => bloc.oneChange = value,
        ),
        SimpleTextField(
          label: 'What was your favorite part of this game?',
          value: bloc.favoritePart,
          focus: focusFavoritePart,
          freeForm: true,
          validator: (value) =>
              bloc.requiredFieldValidator('This field', value),
          onChanged: (value) => bloc.favoritePart = value,
        ),
        SimpleTextField(
          label: 'Additional comments?',
          value: bloc.additionalComments,
          focus: focusAdditionalComments,
          freeForm: true,
          onChanged: (value) => bloc.additionalComments = value,
        )
      ],
    );
  }

  Future<void> _submitFeedback() async {
    if (bloc.selectedGame == null) {
      showDialog(
          context: context,
          builder: (context) =>
              InfoDialog(text: 'You must select a game to give feedback to.'));
      return;
    }
    final state = _formKey.currentState;
    if (!state.validate()) {
      showDialog(
        context: context,
        builder: (context) => InfoDialog(
              text: 'Please check that you\'ve filled out all required fields',
            ),
      );
      return;
    }

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
