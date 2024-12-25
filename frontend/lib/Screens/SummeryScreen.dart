import 'package:flutter/material.dart';
import 'package:frontend/widgets/RowOfContent.dart';

const double? space = 100;

class SummeryScreeen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Rowofcontent(),
            SizedBox(
              height: space,
            ),
            Rowofcontent(),
            SizedBox(
              height: space,
            ),
            Rowofcontent(),
            SizedBox(
              height: space,
            ),
            Rowofcontent(),
          ],
        ),
      ),
    );
  }
}
