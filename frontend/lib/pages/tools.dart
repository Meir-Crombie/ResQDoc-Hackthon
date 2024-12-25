import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DefaultTextField extends StatefulWidget {
  final String labelText;
  final String initialValue; // Initial value for the text field
  bool checkedNode; // Mutable to toggle on double-tap
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Function(String text, List<String> labelText)? writeToJson;
  final List<String> jsonPath;

  DefaultTextField({
    required this.labelText,
    required this.initialValue,
    required this.checkedNode,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
    required this.writeToJson,
    required this.jsonPath,
    Key? key,
  }) : super(key: key);

  @override
  _DefaultTextFieldState createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Map<String, dynamic> getNestedMap(Map<String, dynamic> map, String key) {
    if (!map.containsKey(key)) {
      map[key] = {};
    }
    return map[key] as Map<String, dynamic>;
  }

  Future<void> writeToJson(String text, List<String> path) async {
    try {
      print("data: $text ${path.join(' -> ')}");
      final directoryPath = (await getApplicationDocumentsDirectory()).path;
      final filePath = '$directoryPath/file.json';
      final directory = Directory(directoryPath);

      // Ensure the directory exists
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final file = File(filePath);
      print("$file");
      Map<String, dynamic> jsonData;

      // Check if the file already exists
      if (await file.exists()) {
        // Read the current JSON data from the file
        String content = await file.readAsString();
        if (content.isNotEmpty) {
          jsonData = Map<String, dynamic>.from(jsonDecode(content));
        } else {
          jsonData = _initializeDefaultData();
        }
      } else {
        // If the file does not exist, create the full structure
        jsonData = _initializeDefaultData();
      }

      // Traverse the path and update the value
      Map<String, dynamic> currentMap = jsonData;
      for (int i = 0; i < path.length - 1; i++) {
        currentMap = currentMap.putIfAbsent(path[i], () => <String, dynamic>{})
            as Map<String, dynamic>;
      }
      currentMap[path.last] = text;

      // Write back the updated JSON data
      await file.writeAsString('${jsonEncode(jsonData)}\n',
          mode: FileMode.write);

      print('Data written to file successfully');
    } catch (e) {
      print('Error writing to file: $e');
    }
  }

  Map<String, dynamic> _initializeDefaultData() {
    return {
      "patientDetails": {
        "idOrPassport": "",
        "firstName": "",
        "lastName": "",
        "age": "",
        "gender": "",
        "city": "",
        "street": "",
        "houseNumber": "",
        "phone": "",
        "email": ""
      },
      "smartData": {
        "findings": {
          "diagnosis": "",
          "patientStatus": "",
          "mainComplaint": "",
          "anamnesis": "",
          "medicalSensitivities": "",
          "statusWhenFound": ""
        },
        "medicalMetrics": {
          "bloodPressure": {"value": "", "time": ""},
          "Heart Rate": "",
          "Lung Auscultation": "",
          "consciousnessLevel": "",
          "breathingRate": "",
          "breathingCondition": "",
          "skinCondition": "",
          "lungCondition": "",
          "CO2Level": ""
        }
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () async {
        setState(() {
          widget.checkedNode = !widget.checkedNode;
        });

        if (widget.checkedNode) {
          // Write the text from _controller to the JSON file if checkedNode is true
          if (widget.writeToJson != null) {
            writeToJson(_controller.text, widget.jsonPath);
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: TextField(
          controller: _controller,
          focusNode: widget.focusNode,
          textInputAction: widget.textInputAction,
          onSubmitted: (value) {
            setState(() {
              widget.checkedNode = true; // Update checkedNode state
            });
            if (widget.writeToJson != null) {
              widget.writeToJson!(_controller.text,
                  widget.jsonPath); // Write to JSON _saveTextFieldData();
            }
            if (widget.onSubmitted != null) {
              widget.onSubmitted!(value);
            }
          },
          decoration: InputDecoration(
            labelText: widget.labelText,
            border: OutlineInputBorder(),
            floatingLabelAlignment: FloatingLabelAlignment.start,
            filled: true,
            fillColor: widget.checkedNode ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}
