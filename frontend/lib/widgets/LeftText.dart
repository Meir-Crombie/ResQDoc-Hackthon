import 'package:flutter/material.dart';

class LeftText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Main Title",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          "Sub Title",
          style: TextStyle(
            color: Colors.black26,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
