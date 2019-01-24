import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InfoDialog extends StatelessWidget {
  final String text;

  const InfoDialog({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(text),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
