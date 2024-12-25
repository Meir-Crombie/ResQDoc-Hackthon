import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

class PastDoc extends StatefulWidget {
  final String? fileNum;
  const PastDoc({super.key, this.fileNum});

  @override
  State<PastDoc> createState() => _PastDocState();
}

class _PastDocState extends State<PastDoc> {
  @override
  void initState() {
    super.initState();
  }

  readFromJson(List<String> path, String jsonFile) {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // מציאת הערך "David Cohen" מתוך ה-JSON
    if (widget.fileNum == null) {
      AppBar(
        title: Text('שגיאת ערך ריק'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 187, 0),
      );
      throw "Error cannot load null";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('תיעוד רפואי מלא'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 187, 0),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // עטוף את התוכן ב-SingleChildScrollView
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 50, // Adjust the height as needed
                  alignment: Alignment.center, // Center the text
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 150, 179, 190),
                    border: Border.all(
                        color: Colors.black,
                        width: 1), // Adding border for visibility
                  ),
                  child: Text(
                    'פרטי הכונן',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'מזהה כונן',
                        readFromJson: readFromJson,
                        jsonPath: ['drivers', 'id'],
                        jsonFile: 'mission$widget.fileNum!',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'שם כונן',
                        readFromJson: readFromJson,
                        jsonPath: ['drivers', 'name'],
                        jsonFile: 'mission$widget.fileNum!',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 50, // Adjust the height as needed
                  alignment: Alignment.center, // Center the text
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 150, 179, 190),
                    border: Border.all(
                        color: Colors.black,
                        width: 1), // Adding border for visibility
                  ),
                  child: Text(
                    'פרטי האירוע',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'מספר משימה',
                        readFromJson: readFromJson,
                        jsonPath: ['eventDetails', 'id'],
                        jsonFile: 'mission$widget.fileNum!',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'זמן פתיחת האירוע',
                        readFromJson: readFromJson,
                        jsonPath: ['eventDetails', 'openTime'],
                        jsonFile: 'mission$widget.fileNum!',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DefaultTextField(
                    labelText: 'עיר',
                    readFromJson: readFromJson,
                    jsonPath: ['eventDetails', 'city'],
                    jsonFile: 'mission$widget.fileNum!',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'מספר בית',
                        readFromJson: readFromJson,
                        jsonPath: ['eventDetails', 'houseNumber'],
                        jsonFile: 'mission$widget.fileNum!',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'רחוב',
                        readFromJson: readFromJson,
                        jsonPath: ['eventDetails', 'street'],
                        jsonFile: 'mission$widget.fileNum!',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DefaultTextField(
                    labelText: 'שם',
                    readFromJson: readFromJson,
                    jsonPath: ['eventDetails', 'name'],
                    jsonFile: 'mission$widget.fileNum!',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'המקרה שהוזנק',
                        readFromJson: readFromJson,
                        jsonPath: ['eventDetails', 'missionEvent'],
                        jsonFile: 'mission$widget.fileNum!',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'זמן הגעת הכונן',
                        readFromJson: readFromJson,
                        jsonPath: ['eventDetails', 'arriveTime'],
                        jsonFile: 'mission$widget.fileNum!',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 50, // Adjust the height as needed
                  alignment: Alignment.center, // Center the text
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 150, 179, 190),
                    border: Border.all(
                        color: Colors.black,
                        width: 1), // Adding border for visibility
                  ),
                  child: Text(
                    'פרטי המטופל',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'ת.ז. או מספר דרכון',
                        jsonPath: ['patientDetails', 'idOrPassport'],
                        jsonFile: 'file$widget.fileNum!',
                        readFromJson: readFromJson,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'שם פרטי מטופל',
                        readFromJson: readFromJson,
                        jsonPath: ['patientDetails', 'firstName'],
                        jsonFile: 'file$widget.fileNum!',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'שם משפחה מטופל',
                        readFromJson: readFromJson,
                        jsonPath: ['patientDetails', 'lastName'],
                        jsonFile: 'file$widget.fileNum!',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'גיל המטופל',
                        readFromJson: readFromJson,
                        jsonPath: ['patientDetails', 'age'],
                        jsonFile: 'file$widget.fileNum!',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DefaultTextField(
                    labelText: 'מין המטופל',
                    readFromJson: readFromJson,
                    jsonPath: ['patientDetails', 'gender'],
                    jsonFile: 'file$widget.fileNum!',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DefaultTextField(
                    labelText: 'ישוב המטופל',
                    readFromJson: readFromJson,
                    jsonPath: ['patientDetails', 'city'],
                    jsonFile: 'file$widget.fileNum!',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'רחוב המטופל',
                        readFromJson: readFromJson,
                        jsonPath: ['patientDetails', 'street'],
                        jsonFile: 'file$widget.fileNum!',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'מספר בית מטופל',
                        readFromJson: readFromJson,
                        jsonPath: ['patientDetails', 'houseNumber'],
                        jsonFile: 'file$widget.fileNum!',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DefaultTextField(
                    labelText: 'טלפון המטופל',
                    readFromJson: readFromJson,
                    jsonPath: ['patientDetails', 'phone'],
                    jsonFile: 'file$widget.fileNum!',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DefaultTextField(
                    labelText: 'מייל המטופל',
                    readFromJson: readFromJson,
                    jsonPath: ['patientDetails', 'email'],
                    jsonFile: 'file$widget.fileNum!',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 50, // Adjust the height as needed
                  alignment: Alignment.center, // Center the text
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 150, 179, 190),
                    border: Border.all(
                        color: Colors.black,
                        width: 1), // Adding border for visibility
                  ),
                  child: Text(
                    'ממצאים רפואיים',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'המקרה שנמצא',
                        readFromJson: readFromJson,
                        jsonPath: ['smartData', 'finding'],
                        jsonFile: 'file$widget.fileNum!',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'סטטוס המטופל',
                        readFromJson: readFromJson,
                        jsonPath: ['smartData', 'patientStatus'],
                        jsonFile: 'file$widget.fileNum!',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'תלונה עיקרית',
                        readFromJson: readFromJson,
                        jsonPath: ['smartData', 'mainComplaint'],
                        jsonFile: 'file$widget.fileNum!',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'אבחון המטופל',
                        readFromJson: readFromJson,
                        jsonPath: ['smartData', 'diagnosis'],
                        jsonFile: 'file$widget.fileNum!',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'מצב המטופל כשנמצא',
                        readFromJson: readFromJson,
                        jsonPath: ['smartData', 'statusWhenFound'],
                        jsonFile: 'file$widget.fileNum!',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'אנמנזה וסיפור המקרה',
                        readFromJson: readFromJson,
                        jsonPath: ['smartData', 'anamnesis'],
                        jsonFile: 'file$widget.fileNum!',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DefaultTextField(
                    labelText: 'רגישויות',
                    readFromJson: readFromJson,
                    jsonPath: ['smartData', 'medicalSensitivities'],
                    jsonFile: 'file$widget.fileNum!',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 50, // Adjust the height as needed
                  alignment: Alignment.center, // Center the text
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 150, 179, 190),
                    border: Border.all(
                        color: Colors.black,
                        width: 1), // Adding border for visibility
                  ),
                  child: Text(
                    'מדדים רפואיים',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'רמת הכרה',
                        readFromJson: readFromJson,
                        jsonPath: ['medicalMetrics', 'consciousnessLevel'],
                        jsonFile: 'file$widget.fileNum!',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'האזנה',
                        readFromJson: readFromJson,
                        jsonPath: ['medicalMetrics', 'Lung Auscultation'],
                        jsonFile: 'file$widget.fileNum!',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'מצב נשימה',
                        readFromJson: readFromJson,
                        jsonPath: ['medicalMetrics', 'breathingCondition'],
                        jsonFile: 'file$widget.fileNum!',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'קצב נשימה',
                        readFromJson: readFromJson,
                        jsonPath: ['medicalMetrics', 'breathingRate'],
                        jsonFile: 'file$widget.fileNum!',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'לחץ דם',
                        readFromJson: readFromJson,
                        jsonPath: ['medicalMetrics', 'bloodPressure'],
                        jsonFile: 'file$widget.fileNum!',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'רמת פחמן דו חמצני',
                        readFromJson: readFromJson,
                        jsonPath: ['medicalMetrics', 'CO2Level'],
                        jsonFile: 'file$widget.fileNum!',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'מצב הריאות',
                        readFromJson: readFromJson,
                        jsonPath: ['medicalMetrics', 'lungCondition'],
                        jsonFile: 'file$widget.fileNum!',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'מצב העור',
                        readFromJson: readFromJson,
                        jsonPath: ['medicalMetrics', 'skinCondition'],
                        jsonFile: 'file$widget.fileNum!',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DefaultTextField extends StatefulWidget {
  final String labelText;
  final Function(List<String> jsonPath, String jsonFile) readFromJson;
  final List<String> jsonPath;
  final String jsonFile;

  const DefaultTextField({
    required this.labelText,
    required this.readFromJson,
    required this.jsonPath,
    required this.jsonFile,
    super.key,
  });

  @override
  _DefaultTextFieldState createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: readFromJson(widget.jsonPath, widget.jsonFile));
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

  String readFromJson(List<String> path, String jsonFile) {
    try {
      print("data: ${path.join(' -> ')}");
      final directoryPath = 'storage/emulated/0/Documents';
      final filePath = '$directoryPath/$jsonFile.json';
      final file = File(filePath);

      // Read the content of the file if it exists, otherwise create an empty JSON object
      String content = file.readAsString() as String;
      Map<String, dynamic> jsonData =
          jsonDecode(content) as Map<String, dynamic>;

      // Traverse the path and update the value using the helper function
      Map<String, dynamic> currentMap = jsonData;
      for (int i = 0; i < path.length - 1; i++) {
        currentMap = getNestedMap(currentMap, path[i]);
      }
      print('Data read from file successfully');

      // Return the updated JSON data cast to the generic type T
      return currentMap[path.last] as String;
    } catch (e) {
      print('Error writing to file: $e');
      rethrow; // Rethrow the exception so the caller can handle it
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: widget.labelText,
            border: OutlineInputBorder(),
            floatingLabelAlignment: FloatingLabelAlignment.start,
            filled: true,
            fillColor: Colors.green,
          ),
        ),
      ),
    );
  }
}
