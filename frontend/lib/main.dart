import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/loading_screen.dart';
import 'pages/paramedic_doc.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

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
      },
    )); // Material app
