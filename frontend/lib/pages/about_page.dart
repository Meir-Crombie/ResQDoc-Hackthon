import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 255, 207, 163),
              const Color.fromARGB(255, 255, 255, 255),
              const Color.fromARGB(255, 255, 255, 255)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(),
              ),
            ),
            // Main developer at the top center
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        AssetImage('assets/Developer_photos/developer1.jpg'),
                  ),
                  SizedBox(height: 8),
                  Text('Main Developer', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            // Grid of other developers
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(6, (index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(
                            'assets/Developer_photos/developer${index + 2}.jpg'),
                      ),
                      SizedBox(height: 8),
                      Text('Developer ${index + 2}',
                          style: TextStyle(fontSize: 14)),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
