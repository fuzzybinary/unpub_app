import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unpub/widgets/ensure_visible_widget.dart';

@immutable
class SimpleTextField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String value;
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final Icon icon;
  final FocusNode focus;
  final FocusNode nextFocus;

  const SimpleTextField({
    Key key,
    this.value,
    this.onChanged,
    this.label,
    this.hintText,
    this.keyboardType,
    this.icon,
    this.focus,
    this.nextFocus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EnsureVisibleWidget(
      focusNode: focus,
      child: TextField(
        controller: TextEditingController(text: value),
        decoration:
            InputDecoration(labelText: label, hintText: hintText, icon: icon),
        keyboardType: keyboardType,
        onChanged: onChanged,
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
