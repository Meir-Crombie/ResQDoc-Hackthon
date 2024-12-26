import 'package:flutter/material.dart';
import 'package:frontend/pages/admin.dart';
import 'package:frontend/pages/history_for_maneger.dart';
import 'package:frontend/pages/maneger_dash_board.dart';
import 'package:frontend/pages/settings_page.dart';
import 'pages/home.dart';
import 'pages/paramedic_doc.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'pages/about_page.dart';
import 'pages/list_past_docs.dart';
import "Screens/SummeryScreen.dart";
import 'pages/dup_parmedic.dart';

Future<Map<String, dynamic>> readJson() async {
  final String response = await rootBundle.loadString('data/dummydata.json');
  return jsonDecode(response);
}

void main() => runApp(MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => Home(),
        '/paramedic': (context) => ParamedicDoc(
              fileName: "",
            ),
        '/settings': (context) => Settings(),
        '/about': (context) => AboutPage(),
        '/past': (context) => MissionsPage(),
        '/summary': (context) => SummeryScreen(),
        '/history': (context) => MissionsPage(),
        '/admin': (context) => AdminsPage(),
        '/confirmation': (context) => PastDocForConfirmation(),
        '/maneger': (context) => ManegerDashBoard(),
        '/paramedic_dup': (context) => EmptyParamedicDoc(),
      },
    )); // Material app
