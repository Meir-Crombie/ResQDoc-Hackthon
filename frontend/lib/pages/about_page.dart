import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('אודות'),
        backgroundColor: const Color.fromARGB(255, 255, 123, 0),
        centerTitle: true, // מרכז את הכותרת
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 255, 207, 163),
              const Color.fromARGB(255, 255, 255, 255),
              const Color.fromARGB(255, 255, 255, 255)
            ], // צבעי השיפוע
            begin: Alignment.topLeft, // תחילת השיפוע
            end: Alignment.bottomRight, // סוף השיפוע
          ),
        ),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight, // יישור למעלה בצד ימין
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(),
              ),
            ),
            // תוכל להוסיף כאן תוכן נוסף
          ],
        ),
      ),
    );
  }
}
