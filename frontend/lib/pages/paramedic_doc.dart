import 'package:flutter/material.dart';
import 'package:frontend/pages/tools.dart';

class ParamedicDoc extends StatefulWidget {
  const ParamedicDoc({super.key});

  @override
  State<ParamedicDoc> createState() => _ParamedicDocState();
}

class _ParamedicDocState extends State<ParamedicDoc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('תיעוד כונן'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 187, 0),
      ),
      body: SafeArea(
        child: Column(children: [
          Row(
            children: [
              Center(
                child: DefaultTextField(),
              ),
              Center(
                child: DefaultTextField(),
              ),
            ],
          ),
          Text('paramedic doc screen'),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: DefaultTextField(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: DefaultTextField(),
            ),
          )
        ]),
      ),
    );
  }
}
