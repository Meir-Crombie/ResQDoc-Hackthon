import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

abstract class StaticTools {
  static int nextNum = 1; // Static variable to track the next file number
  static List<bool> allowSubmit = List.filled(25, false);
  static int nextAlowNum = 0; // Static variable to track the next file number
}

class DefaultTextField extends StatefulWidget {
  final String labelText;
  final String initialValue; // Initial value for the text field
  bool checkedNode; // Mutable to toggle on double-tap
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final bool? writeToJson;
  final List<String> jsonPath;
  final bool isEditable; // New property to enable/disable editing

  DefaultTextField({
    required this.labelText,
    required this.initialValue,
    required this.checkedNode,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
    this.writeToJson = true,
    required this.jsonPath,
    this.isEditable = true, // Default to true
    super.key,
  });

  @override
  _DefaultTextFieldState createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  late TextEditingController _controller;
  String? _errorText; // To hold the error message

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
      final directoryPath = (await (getApplicationDocumentsDirectory())).path;
      final filePath =
          '$directoryPath/file${StaticTools.nextNum}.json'; // Use the static variable for the file name
      final directory = Directory(directoryPath);

      // Ensure the directory exists
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final file = File(filePath);

      Map<String, dynamic> jsonData;

      // Check if the file already exists
      if (await file.exists()) {
        // Read the current JSON data from the file
        String content = await file.readAsString();
        if (content.isNotEmpty) {
          jsonData = jsonDecode(content) as Map<String, dynamic>;
        } else {
          jsonData = _initializeJsonStructure();
        }
      } else {
        // If the file does not exist, initialize the structure
        jsonData = _initializeJsonStructure();
      }

      // Traverse the path and update the value using the helper function

      Map<String, dynamic> currentMap = jsonData;
      for (int i = 0; i < path.length - 1; i++) {
        currentMap = getNestedMap(currentMap, path[i]);
      }
      currentMap[path.last] = text;
      // Write back the updated JSON data
      print(jsonEncode(jsonData));
      await file.writeAsString(jsonEncode(jsonData), mode: FileMode.write);

      print('Data written to file successfully');
    } catch (e) {
      print('Error writing to file: $e');
    }
  }

  Map<String, dynamic> _initializeJsonStructure() {
    return {
      "response": {
        "patientDetails": {
          "idOrPassport": "",
          "firstName": "",
          "lastName": "",
          "age": "",
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
            "statusWhenFound": "",
            "caseFound": ""
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
        },
        "eventDetails": {
          "timeOpened": "",
          "id": "",
          "city": "",
          "houseNumber": "",
          "street": "",
          "patientName": "",
          "missionEvent": "",
          "timeArrived": ""
        }
      }
    };
  }

  void _validateAndWriteToJson() {
    if (_controller.text.trim().isEmpty) {
      print("adding to file");
      setState(() {
        _errorText = 'השדה זה לא יכול להיות ריק'; // Error message
        widget.checkedNode = false;
      });
    } else {
      setState(() {
        _errorText = null; // Clear the error
        StaticTools.allowSubmit[StaticTools.nextAlowNum] = true;
        StaticTools.nextAlowNum++;
      });

      if (widget.writeToJson != null) {
        writeToJson(_controller.text, widget.jsonPath);
        print("adding to file");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () async {
        if (widget.isEditable) {
          setState(() {
            widget.checkedNode = !widget.checkedNode;
          });
          print(StaticTools.nextAlowNum);
          if (widget.checkedNode) {
            // Write the text from _controller to the JSON file if checkedNode is true
            _validateAndWriteToJson();
          }
        } else {
          writeToJson(_controller.text, widget.jsonPath);
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
              widget.checkedNode = true;

              StaticTools.allowSubmit;
            });
            print(StaticTools.nextAlowNum);
            _validateAndWriteToJson();

            if (widget.onSubmitted != null) {
              widget.onSubmitted!(value);
            }
          },
          enabled: widget.isEditable, // Enable/disable based on isEditable
          decoration: InputDecoration(
            labelText: widget.labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0), // פינות מעוגלות
              borderSide: BorderSide.none, // ללא מסגרת
            ),
            floatingLabelAlignment: FloatingLabelAlignment.start,
            filled: true,
            fillColor: widget.checkedNode
                ? const Color.fromARGB(255, 150, 240, 180)
                : const Color.fromARGB(255, 255, 201, 218),
            errorText: _errorText, // Display error message
          ),
        ),
      ),
    );
  }
}

abstract class SaveToJson {
  static void writeToJson(List<String> texts) async {
    try {
      final directoryPath = (await (getApplicationDocumentsDirectory())).path;
      final filePath =
          '$directoryPath/file${StaticTools.nextNum}.json'; // Use the static variable for the file name
      final directory = Directory(directoryPath);

      // Ensure the directory exists
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final file = File(filePath);

      Map<String, dynamic> jsonData = _initializeJsonStructure();

      // Check if the file already exists
      jsonData['response']['eventDetails']['id'] = texts[0];
      jsonData['response']['eventDetails']['timeOpened'] = texts[1];
      jsonData['response']['eventDetails']['city'] = texts[2];
      jsonData['response']['eventDetails']['houseNumber'] = texts[3];
      jsonData['response']['eventDetails']['street'] = texts[4];
      jsonData['response']['eventDetails']['timeArrived'] = texts[5];
      jsonData['response']['eventDetails']['patientName'] = texts[6];
      jsonData['response']['eventDetails']['missionEvent'] = texts[7];

      // Write back the updated JSON data
      print(jsonEncode(jsonData));
      await file.writeAsString(jsonEncode(jsonData), mode: FileMode.write);

      print('Data written to file successfully');
    } catch (e) {
      print('Error writing to file: $e');
    }
  }

  static Map<String, dynamic> _initializeJsonStructure() {
    return {
      "response": {
        "patientDetails": {
          "idOrPassport": "",
          "firstName": "",
          "lastName": "",
          "age": "",
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
            "statusWhenFound": "",
            "caseFound": ""
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
        },
        "eventDetails": {
          "timeOpened": "",
          "id": "",
          "city": "",
          "houseNumber": "",
          "street": "",
          "patientName": "",
          "missionEvent": "",
          "timeArrived": ""
        }
      }
    };
  }
}
