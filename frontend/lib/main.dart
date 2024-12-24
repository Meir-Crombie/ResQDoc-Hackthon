import 'package:flutter/material.dart';
import 'package:frontend/pages/StartRecord.dart';
import 'package:frontend/pages/home.dart';
import 'package:frontend/pages/loading_screen.dart';
import 'package:frontend/pages/paramedic_doc.dart';

void main() => runApp(MaterialApp(
      initialRoute: '/home',
      routes: {
        '/': (context) => Loading(),
        '/home': (context) => Home(),
        '/location': (context) => ChooseLocation(),
        '/paramedic': (context) => ParamedicDoc(),
      },
    ));
