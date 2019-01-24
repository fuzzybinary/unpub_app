import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unpub/widgets/ensure_visible_widget.dart';

@immutable
class SimpleTextField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;
  final String value;
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final Icon icon;
  final FocusNode focus;
  final FocusNode nextFocus;
  final bool freeForm;

  const SimpleTextField({
    Key key,
    this.value,
    this.validator,
    this.onChanged,
    this.label,
    this.hintText,
    this.keyboardType,
    this.icon,
    this.focus,
    this.nextFocus,
    this.freeForm = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SimpleTextFieldState();
}

class _SimpleTextFieldState extends State<SimpleTextField> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _controller.addListener(_handleControllerChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_handleControllerChanged);
  }

  void _handleControllerChanged() {
    widget.onChanged(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border;
    var maxLines = 1;
    if (widget.freeForm) {
      border = OutlineInputBorder(borderSide: BorderSide(width: 1));
      maxLines = 5;
    }
    return Container(
      padding: widget.freeForm ? EdgeInsets.only(top: 5, bottom: 5) : null,
      child: EnsureVisibleWidget(
        focusNode: widget.focus,
        child: TextFormField(
          controller: _controller,
          validator: widget.validator,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hintText,
            icon: widget.icon,
            border: border,
          ),
          maxLines: maxLines,
          keyboardType: widget.keyboardType,
          textInputAction: widget.nextFocus != null
              ? TextInputAction.next
              : TextInputAction.done,
          focusNode: widget.focus,
          onFieldSubmitted: (value) {
            widget.focus.unfocus();
            FocusScope.of(context).requestFocus(widget.nextFocus);
          },
        ),
      ),
    );
  }
}
