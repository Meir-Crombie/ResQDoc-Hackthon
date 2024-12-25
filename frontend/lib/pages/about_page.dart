import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  final List<String> linkedinLinks = [
    'https://www.linkedin.com/in/mendel-wagner-239901239/',
    'https://www.linkedin.com/in/meir-crombie-310816289/',
    'https://www.linkedin.com/in/daniel-pilant-5a8a052b5/',
    'https://www.linkedin.com/in/moshe-hanau-29a56131a/',
    'https://he.wikipedia.org/wiki/%D7%97%D7%A0%D7%95%D7%9A',
    'https://www.linkedin.com/in/yedidia-bakuradze-195621271/',
    'https://www.linkedin.com/in/yitshac-brody/',
  ];

  final List<Tuple2<String, String>> developerInfo = [
    Tuple2('Mendel Wagner', 'third year BM'), // Main developer
    Tuple2('Meir Crombie', 'second year CS'),
    Tuple2('Daniel Pilant', 'second year SE'),
    Tuple2('Moshe Hanau', 'first year CS'),
    Tuple2('Oria Hanuka', 'second year CS'),
    Tuple2('Yedidia Bakurdza', 'second year CS'),
    Tuple2('Yitshac Brody', 'second year CS'),
  ];

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
<<<<<<< HEAD
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        AssetImage('assets/Developer_photos/developer1.jpg'),
                  ),
=======
>>>>>>> 02d1fedc933a8b7ce06e59972cf527b73876afc5
                  GestureDetector(
                    onTap: () => _launchURL(linkedinLinks[0]),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          AssetImage('assets/Developer_photos/developer1.jpg'),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(developerInfo[0].item1,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(developerInfo[0].item2, style: TextStyle(fontSize: 14)),
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
<<<<<<< HEAD
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(
                            'assets/Developer_photos/developer${index + 2}.jpg'),
                      ),
=======
>>>>>>> 02d1fedc933a8b7ce06e59972cf527b73876afc5
                      GestureDetector(
                        onTap: () => _launchURL(linkedinLinks[index + 1]),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(
                              'assets/Developer_photos/developer${index + 2}.jpg'),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(developerInfo[index + 1].item1,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      Text(developerInfo[index + 1].item2,
                          style: TextStyle(fontSize: 12)),
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

  void _launchURL(String url) async {
    print('Attempting to launch URL: $url');
    try {
      bool canLaunchUrl = await canLaunch(url);
      print('Can launch URL: $canLaunchUrl');
      if (canLaunchUrl) {
        print('Launching URL: $url');
        await launch(url, forceSafariVC: false, forceWebView: false);
      } else {
        print('Could not launch URL: $url');
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
}

class Tuple2<T1, T2> {
  final T1 item1;
  final T2 item2;

  Tuple2(this.item1, this.item2);
}
