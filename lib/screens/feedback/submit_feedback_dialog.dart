import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unpub/screens/feedback/feedback_screen_bloc.dart';

class SubmitFeedbackDialog extends StatefulWidget {
  final FeedbackScreenBloc bloc;

  const SubmitFeedbackDialog({
    Key key,
    this.bloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SubmitFeedbackDialogState();
}

enum _SubmitionState {
  Confirming,
  Submitting,
  Submitted,
}

class _SubmitFeedbackDialogState extends State<SubmitFeedbackDialog> {
  _SubmitionState state = _SubmitionState.Confirming;
  bool success;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case _SubmitionState.Confirming:
        return _buildConfirmDialog();
      case _SubmitionState.Submitting:
        return _buildSubmittingDialog();
      case _SubmitionState.Submitted:
        return _buildSuccessDialog();
    }
    return Container();
  }

  Future<void> _submitFeedback() async {
    success = await widget.bloc.submitFeedback();
    setState(() {
      state = _SubmitionState.Submitted;
    });
  }

  Widget _buildConfirmDialog() {
    return AlertDialog(
      content: RichText(
        text: TextSpan(
          text: 'Are you sure you want to submit this feedback for ',
          style: Theme.of(context).textTheme.subhead,
          children: [
            TextSpan(
              text: widget.bloc.selectedGame.game,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Yes'),
          onPressed: () {
            setState(() {
              state = _SubmitionState.Submitting;
              _submitFeedback();
            });
          },
        ),
        FlatButton(
          child: Text('No'),
          onPressed: () => Navigator.of(context).pop(false),
        )
      ],
    );
  }

  Widget _buildSubmittingDialog() {
    return AlertDialog(
      title: Text('Submitting Feedback'),
      content: IntrinsicHeight(
        child: Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildSuccessDialog() {
    final contentString = success
        ? 'Success!'
        : 'Sorry, something went wrong. Please try again later.';
    return AlertDialog(
      content: Text(
        contentString,
        style: Theme.of(context).textTheme.headline,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () => Navigator.of(context).pop(success),
        )
      ],
    );
  }
}
