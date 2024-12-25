import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

abstract class StaticTools {
  static int nextNum = 1; // Static variable to track the next file number
  static List<bool> allowSubmit = List.filled(25, false);
  static int nextAlowNum = 0; // Static variable to track the next file number
}

class DefaultTextField extends StatefulWidget {
  final String labelText;
  final String initialValue; // Initial value for the text field
  bool checkedNode; // Mutable to toggle on double-tap
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Function(String text, List<String> labelText)? writeToJson;
  final List<String> jsonPath;
  final bool isEditable; // New property to enable/disable editing

  DefaultTextField({
    required this.labelText,
    required this.initialValue,
    required this.checkedNode,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
    required this.writeToJson,
    required this.jsonPath,
    this.isEditable = true, // Default to true
    super.key,
  });

  @override
  _DefaultTextFieldState createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  late TextEditingController _controller;
  String? _errorText; // To hold the error message

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Map<String, dynamic> getNestedMap(Map<String, dynamic> map, String key) {
    if (!map.containsKey(key)) {
      map[key] = {};
    }
    return map[key] as Map<String, dynamic>;
  }

  Future<void> writeToJson(String text, List<String> path) async {
    // JSON writing logic remains the same...
  }

  void _validateAndWriteToJson() {
    if (_controller.text.trim().isEmpty) {
      setState(() {
        _errorText = 'השדה זה לא יכול להיות ריק'; // Error message
      });
    } else {
      setState(() {
        _errorText = null; // Clear the error
      });

      if (widget.writeToJson != null) {
        widget.writeToJson!(_controller.text, widget.jsonPath);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () async {
        if (widget.isEditable) {
          setState(() {
            widget.checkedNode = !widget.checkedNode;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: TextField(
          controller: _controller,
          focusNode: widget.focusNode,
          textInputAction: widget.textInputAction,
          onSubmitted: (value) {
            if (widget.isEditable) {
              _validateAndWriteToJson();
              if (widget.onSubmitted != null) {
                widget.onSubmitted!(value);
              }
            }
          },
          enabled: widget.isEditable, // Enable/disable based on isEditable
          decoration: InputDecoration(
            labelText: widget.labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0), // פינות מעוגלות
              borderSide: BorderSide.none, // ללא מסגרת
            ),
            floatingLabelAlignment: FloatingLabelAlignment.start,
            filled: true,
            fillColor: widget.isEditable
                ? const Color.fromARGB(255, 255, 255, 255)
                : const Color.fromARGB(
                    255, 200, 200, 200), // Greyed out when disabled
            errorText: _errorText, // Display error message
          ),
        ),
      ),
    );
  }
}
