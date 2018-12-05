import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  bool _didWin;
  set didWin(bool value) {
    setState(() {
      _didWin = value;
    });
  }

  double _gameLength = 3;
  set gameLength(double value) {
    setState(() {
      _gameLength = value;
    });
  }

  double _easeOfLearning = 3;
  set easeOfLearning(double value) {
    setState(() {
      _easeOfLearning = value;
    });
  }

  double _playerDownTime = 3;
  set playerDownTime(double value) {
    setState(() {
      _playerDownTime = value;
    });
  }

  double _gameDecisions = 3;
  set gameDecisions(double value) {
    setState(() {
      _gameDecisions = value;
    });
  }

  double _interactivity = 3;
  set interactivity(double value) {
    setState(() {
      _interactivity = value;
    });
  }

  double _originality = 3;
  set originality(double value) {
    setState(() {
      _originality = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            _buildFirstPage(context),
            _buildSecondPage(context)
          ],
        ),
      ),
    );
  }

  Color _selectedColor(ThemeData theme, bool isSelected) {
    if (isSelected != null && isSelected) {
      return theme.primaryColor;
    }
    return Colors.transparent;
  }

  Widget _buildFirstPage(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
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
        Row(
          children: <Widget>[
            Text(
              'Did you win?',
              style: theme.textTheme.headline,
            ),
            ButtonBar(
              children: <Widget>[
                RaisedButton(
                  child: Text('Yes'),
                  color: _selectedColor(theme, _didWin),
                  onPressed: () => didWin = true,
                ),
                RaisedButton(
                  child: Text('No'),
                  color: _selectedColor(theme, _didWin == null ? null : !_didWin),
                  onPressed: () => didWin = false,
                )
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget _buildRaitingSlider(
      {@required String text,
      @required double value,
      @required ValueChanged<double> onChanged}) {
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
          value: value,
          onChanged: onChanged,
        )
      ],
    );
  }

  Widget _buildSecondPage(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      
      children: <Widget>[
        _buildRaitingSlider(
          text: 'Game Length',
          value: _gameLength,
          onChanged: (value) => gameLength = value,
        ),
        _buildRaitingSlider(
          text: 'Ease of Learning',
          value: _easeOfLearning,
          onChanged: (value) => easeOfLearning = value,
        ),
        _buildRaitingSlider(
          text: 'Player Down Time',
          value: _playerDownTime,
          onChanged: (value) => playerDownTime = value,
        ),
        _buildRaitingSlider(
          text: 'Game Decisions',
          value: _gameDecisions,
          onChanged: (value) => gameDecisions = value,
        ),
        _buildRaitingSlider(
          text: 'Interactivity',
          value: _interactivity,
          onChanged: (value) => interactivity = value,
        ),
        _buildRaitingSlider(
          text: 'Originality',
          value: _originality,
          onChanged: (value) => originality = value,
        ),
      ],
    );
  }
}
