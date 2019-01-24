import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

@immutable
class RaitingSlider extends StatelessWidget {
  final String text;
  final double value;
  final ValueChanged<double> onChanged;

  const RaitingSlider({
    Key key,
    @required this.text,
    @required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          onChanged: onChanged,
        )
      ],
    );
  }
}
