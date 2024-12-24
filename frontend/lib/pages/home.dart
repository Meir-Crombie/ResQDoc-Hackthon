import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text('איחוד הצלה - תיעוד כונן'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 255, 187, 0),
        ),
        body: SafeArea(
            child: Column(children: <Widget>[
          Center(
            child: TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/location');
              },
              icon: Icon(Icons.record_voice_over),
              label: Text(
                'התחל הקלטה',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Center(
            child: TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/paramedic');
              },
              icon: Icon(Icons.info),
              label: Text(
                'תיעוד כונן',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ])));
  }
}
