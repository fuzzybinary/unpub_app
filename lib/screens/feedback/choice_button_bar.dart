import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unpub/screens/feedback/feedback_screen_bloc.dart';

@immutable
class ChoiceButtonBar extends StatelessWidget {
  final DiscreetAnswer value;
  final String label;
  final ValueChanged<DiscreetAnswer> onChange;
  final bool includeMaybe;

  const ChoiceButtonBar({
    Key key,
    @required this.value,
    @required this.label,
    @required this.onChange,
    this.includeMaybe = true,
  }) : super(key: key);

  Color _selectedColor(ThemeData theme, bool isSelected) {
    if (isSelected != null && isSelected) {
      return theme.accentColor;
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttons = <Widget>[];
    buttons.add(RaisedButton(
      child: Text('Yes'),
      color: _selectedColor(theme, value == DiscreetAnswer.Yes),
      onPressed: () {
        onChange(DiscreetAnswer.Yes);
      },
    ));
    if (includeMaybe) {
      buttons.add(
        RaisedButton(
          child: Text('Maybe'),
          color: _selectedColor(theme, value == DiscreetAnswer.Maybe),
          onPressed: () {
            onChange(DiscreetAnswer.Maybe);
          },
        ),
      );
    }
    buttons.add(
      RaisedButton(
        child: Text('No'),
        color: _selectedColor(theme, value == DiscreetAnswer.No),
        onPressed: () {
          onChange(DiscreetAnswer.No);
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
}
