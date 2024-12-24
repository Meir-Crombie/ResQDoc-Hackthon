import 'package:flutter/material.dart';
import 'package:frontend/pages/settings_page.dart';
import 'pages/home.dart';
import 'pages/loading_screen.dart';
import 'pages/paramedic_doc.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'pages/about_page.dart';

Future<Map<String, dynamic>> readJson() async {
  final String response = await rootBundle.loadString('data/dummydata.json');
  return jsonDecode(response);
}

void main() => runApp(MaterialApp(
      initialRoute: '/home',
      routes: {
        '/': (context) => Loading(),
        '/home': (context) => Home(),
        '/paramedic': (context) => ParamedicDoc(),
        '/settings': (context) => Settings(),
        '/about': (context) => About(),
      },
    )); // Material app
