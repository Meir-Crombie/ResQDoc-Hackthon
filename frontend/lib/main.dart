import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/loading_screen.dart';
import 'pages/paramedic_doc.dart';

void main() => runApp(MaterialApp(
      initialRoute: '/home',
      routes: {
        '/': (context) => Loading(),
        '/home': (context) => Home(),
        '/paramedic': (context) => ParamedicDoc(),
      },
    )); // Material app
