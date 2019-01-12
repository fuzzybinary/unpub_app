import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unpub/widgets/ensure_visible_widget.dart';

@immutable
class SimpleTextField extends StatelessWidget {
  final TextEditingController _controller;

  final ValueChanged<String> onChanged;
  final String label;
  final String hintText;
  final Icon icon;
  final FocusNode focus;
  final FocusNode nextFocus;

  SimpleTextField(
      {Key key,
      String value,
      this.onChanged,
      this.label,
      this.hintText,
      this.icon,
      this.focus,
      this.nextFocus})
      : _controller = TextEditingController(
          text: value,
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return EnsureVisibleWidget(
      focusNode: focus,
      child: TextField(
        decoration:
            InputDecoration(labelText: label, hintText: hintText, icon: icon),
        onChanged: onChanged,
        controller: _controller,
        textInputAction:
            nextFocus != null ? TextInputAction.next : TextInputAction.done,
        focusNode: focus,
        onSubmitted: (_) {
          focus.unfocus();
          FocusScope.of(context).requestFocus(nextFocus);
        },
      ),
    );
  }
}
