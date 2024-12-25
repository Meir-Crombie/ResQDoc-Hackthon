import 'package:flutter/material.dart';
import 'package:frontend/Screens/SummeryScreen.dart';
import 'package:frontend/pages/settings_page.dart';
import 'pages/home.dart';
import 'pages/paramedic_doc.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'pages/about_page.dart';
import 'pages/list_past_docs.dart';
import 'pages/study_mode.dart';

Future<Map<String, dynamic>> readJson() async {
  final String response = await rootBundle.loadString('data/dummydata.json');
  return jsonDecode(response);
}

// void main() => runApp(MaterialApp(
//       initialRoute: '/home',
//       routes: {
//         '/home': (context) => Home(),
//         '/paramedic': (context) => ParamedicDoc(
//               fileName: "",
//             ),
//         '/settings': (context) => Settings(),
//         '/about': (context) => AboutPage(),
//         '/past': (context) => MissionsPage(),
//         '/studymode': (context) => StudyModePage(),
//       },
//     )); // Material app

void main() {
  runApp(MaterialApp(
    home: SummeryScreeen(),
  ));
}
