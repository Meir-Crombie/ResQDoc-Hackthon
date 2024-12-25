import 'package:flutter/material.dart';
import 'package:frontend/widgets/LeftText.dart';
import 'package:frontend/widgets/RightText.dart';

class RowofContent extends StatelessWidget {
  const RowofContent({
    super.key,
    required this.mainTitleLeft,
    required this.subTitleLeft,
    required this.clockValue,
    required this.icon,
    required this.onPressFunc,
  });
  final IconData icon;
  final String mainTitleLeft;
  final String subTitleLeft;
  final String clockValue;
  final VoidCallback? onPressFunc;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: LeftText(
              mainTitle: mainTitleLeft,
              subTitle: subTitleLeft,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 26,
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(
                  icon,
                  size: 24,
                ),
                onPressed: onPressFunc,
                color: const Color.fromARGB(255, 56, 55, 55),
              ),
            ),
          ),
          Expanded(
            child: RightText(
              clock: clockValue,
            ),
          ),
        ],
      ),
    );
  }
}
