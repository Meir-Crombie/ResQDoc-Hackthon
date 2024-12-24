import 'package:flutter/material.dart';

class DefaultTextField extends StatefulWidget {
  final String labelText;
  DefaultTextField({required this.labelText});
  @override
  _DefaultTextFieldState createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  // Initialize the TextEditingController with a default value
  final TextEditingController _controller =
      TextEditingController(text: "Default Value from AI");

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(),
        border: OutlineInputBorder(),
      ),
    );
  }
}
