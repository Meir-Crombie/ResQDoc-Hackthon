import 'package:flutter/material.dart';

class RightText extends StatelessWidget {
  const RightText({
    super.key,
    required this.clock,
  });
  final String clock;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          clock,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
