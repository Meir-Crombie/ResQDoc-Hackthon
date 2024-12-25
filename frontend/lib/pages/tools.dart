import 'package:flutter/material.dart';

class DefaultTextField extends StatefulWidget {
  final String labelText;
  final String initialValue; // פרמטר initialValue
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final Function(String) onSubmitted;
  final bool checkedNode; // הוספת checkedNode

  const DefaultTextField({
    super.key,
    required this.labelText,
    required this.initialValue, // ודא שהפרמטר מועבר כאן
    required this.focusNode,
    required this.textInputAction,
    required this.onSubmitted,
    required this.checkedNode, // ודא שהפרמטר מועבר כאן
  });

  @override
  _DefaultTextFieldState createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: widget.initialValue); // שימוש ב-initialValue
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: OutlineInputBorder(),
      ),
      textAlign: TextAlign.right, // יישור הטקסט לימין
    );
  }
}
