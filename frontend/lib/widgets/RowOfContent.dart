import 'package:flutter/material.dart';
import 'package:frontend/widgets/RightText.dart';
import 'package:frontend/widgets/LeftText.dart';

const double? space = 20;

class Rowofcontent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LeftText(
          mainTitle: "Main title left",
          subTitle: "Sub Title left",
        ),
        SizedBox(
          width: space,
        ),
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 40,
          child: Icon(Icons.inbox),
        ),
        SizedBox(
          width: space,
        ),
        RightText(),
      ],
    );
  }
}
