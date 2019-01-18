import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unpub/screens/feedback/choice_button_bar.dart';
import 'package:unpub/screens/feedback/confirm_dialog.dart';

import 'package:unpub/screens/feedback/feedback_screen_bloc.dart';
import 'package:unpub/screens/feedback/feedback_widget.dart';
import 'package:unpub/screens/feedback/simple_text_field.dart';
import 'package:unpub/screens/feedback/submit_feedback_dialog.dart';
import 'package:unpub/screens/game_choice_screen.dart';
import 'package:unpub/widgets/ensure_visible_widget.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key key, this.bloc}) : super(key: key);

  final FeedbackScreenBloc bloc;

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState(bloc);
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final FeedbackScreenBloc bloc;

  _FeedbackScreenState(this.bloc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: () => _clearForm(context),
          )
        ],
      ),
      body: FeedbackWidget(bloc: bloc),
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
}
