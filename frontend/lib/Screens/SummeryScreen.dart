import 'package:flutter/material.dart';
import 'package:frontend/widgets/RowOfContent.dart';
import 'package:frontend/widgets/RowOfContent.dart';

const double spaceBetweenNodes = 100;
const double widthOfLine = 1.1;
const int startColor = 0xffffFF5900;
const int endColor = 0xffffFEFEFE;

class SummeryScreeen extends StatelessWidget {
  const SummeryScreeen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //Gradient coloring
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [0.025, 1.0], // Start at 20% from bottom
            colors: [
              Color(startColor),
              Color(endColor),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RowofContent(
                mainTitleLeft: "Call Been Received",
                subTitleLeft: "Area: Jerusalem",
                clockValue: "15:00",
                icon: Icons.inbox,
              ),
              Container(
                width: widthOfLine, // Line thickness
                height: spaceBetweenNodes, // Line height
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                margin: EdgeInsets.symmetric(horizontal: 10),
              ),
              RowofContent(
                mainTitleLeft: "Wearing has arrived",
                subTitleLeft: "Agent: Sumsum",
                clockValue: "15:05",
                icon: Icons.account_balance,
              ),
              Container(
                width: widthOfLine, // Line thickness
                height: spaceBetweenNodes, // Line height
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                margin: EdgeInsets.symmetric(horizontal: 10),
              ),
              RowofContent(
                mainTitleLeft: "Main Couse",
                subTitleLeft: "Case Found: Animal bite",
                clockValue: "15:05",
                icon: Icons.info,
              ),
              Container(
                width: widthOfLine, // Line thickness
                height: spaceBetweenNodes, // Line height
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                margin: EdgeInsets.symmetric(horizontal: 10),
              ),
              RowofContent(
                mainTitleLeft: "Treatments given",
                subTitleLeft: "Action: CPR, epipen",
                clockValue: "15:13",
                icon: Icons.account_tree_outlined,
              ),
              Container(
                width: widthOfLine, // Line thickness
                height: spaceBetweenNodes, // Line height
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                margin: EdgeInsets.symmetric(horizontal: 10),
              ),
              RowofContent(
                mainTitleLeft: "Call Closed",
                subTitleLeft: "Status: Patient R.I.P ☠️",
                clockValue: "15:40",
                icon: Icons.check,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
