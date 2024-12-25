import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logger/logger.dart';

class AboutPage extends StatelessWidget {
  final List<String> linkedinLinks = [
    'https://linkedin.com/in/mendel-wagner-239901239/',
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
            // Title
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'Meet the team',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _launchURL(context, linkedinLinks[0]),
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
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => _launchURL(context, linkedinLinks[index + 1]),
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
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'version 1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  final logger = Logger();
  void _launchURL(BuildContext context, String url) async {
    logger.d('Attempting to launch URL: $url');
    Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        logger.d('Launching URL: $url');
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        logger.w('Could not launch URL: $url');
        _showErrorMessage(context, 'Could not launch URL');
      }
    } catch (e) {
      logger.e('Error launching URL: $e');
      _showErrorMessage(context, 'Error launching URL');
    }
  }

  void _showErrorMessage(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}


class Tuple2<T1, T2> {
  final T1 item1;
  final T2 item2;

  Tuple2(this.item1, this.item2);
}
