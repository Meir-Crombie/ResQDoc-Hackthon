import 'package:flutter/material.dart';

class LeftText extends StatelessWidget {
  const LeftText({
    super.key,
    required this.mainTitle,
    required this.subTitle,
  });
  final String mainTitle;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mainTitle,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          subTitle,
          style: TextStyle(
            color: Colors.black26,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
