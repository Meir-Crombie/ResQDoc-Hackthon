import 'dart:core';
import 'package:flutter/material.dart';
import 'package:frontend/pages/settings_page.dart';
import 'pages/home.dart';
import 'pages/paramedic_doc.dart';
import 'pages/about_page.dart';
import 'pages/past_doc.dart';
import 'pages/list_past_docs.dart';

void main() => runApp(MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => Home(),
        '/paramedic': (context) => ParamedicDoc(
              fileName: "",
            ),
        '/pastDoc': (context) => PastDoc(fileNum: null),
        '/listPastDocs': (context) => MissionsPage(),
        '/settings': (context) => Settings(),
        '/about': (context) => AboutPage(),
      },
    )); // Material app
