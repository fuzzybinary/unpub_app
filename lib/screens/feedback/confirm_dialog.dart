import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ConfirmDialog extends StatelessWidget {
  final String text;

  const ConfirmDialog({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      content: Text(text),
      actions: <Widget>[
        FlatButton(
          child: Text('Yes'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        FlatButton(
          child: Text('No'),
          onPressed: () => Navigator.of(context).pop(false),
        )
      ],
    );
  }
}
