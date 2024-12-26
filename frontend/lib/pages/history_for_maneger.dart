import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/SummeryScreen.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class PastDocForConfirmation extends StatefulWidget {
  final String? fileNum;
  const PastDocForConfirmation({super.key, this.fileNum});

  @override
  State<PastDocForConfirmation> createState() => _PastDocForConfirmationState();
}

class _PastDocForConfirmationState extends State<PastDocForConfirmation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fileNum == null) {
      AppBar(
        title: Text('שגיאת ערך ריק'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 123, 0),
      );
      throw "Error cannot load null";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'אישור מנהל',
          style: TextStyle(
            fontFamily: 'AlmoniTzarAAA', // Updated font family
          ),
        ),
        actions: [],
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 123, 0),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Container(
            color: const Color.fromARGB(255, 255, 255, 255),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SummeryScreen(filepath: widget.fileNum)),
          );
        },
        child: Icon(Icons.info),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 50, // Adjust the height as needed
                  alignment: Alignment.center, // Center the text
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 255, 118, 44),
                    // Adding border for visibility
                  ),
                  child: Text(
                    'פרטי כונן',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'AlmoniTzarAAA', // Updated font family
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
                        jsonPath: ['response', 'eventDetails', 'id'],
                        jsonFile: 'file${widget.fileNum}',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'שם כונן',
                        jsonPath: ['response', 'patientDetails', 'firstName'],
                        jsonFile: 'file${widget.fileNum}',
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
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 255, 118, 44),
                  ),
                  child: Text(
                    'פרטי אירוע',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'AlmoniTzarAAA', // Updated font family
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
                        jsonPath: ['response', 'eventDetails', 'id'],
                        jsonFile: 'file${widget.fileNum}',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'זמן פתיחת האירוע',
                        jsonPath: ['response', 'eventDetails', 'timeOpened'],
                        jsonFile: 'file${widget.fileNum}',
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
                    jsonPath: ['response', 'eventDetails', 'city'],
                    jsonFile: 'file${widget.fileNum}',
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
                        jsonPath: ['response', 'eventDetails', 'houseNumber'],
                        jsonFile: 'file${widget.fileNum}',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'רחוב',
                        jsonPath: ['response', 'eventDetails', 'street'],
                        jsonFile: 'file${widget.fileNum}',
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
                    jsonPath: ['response', 'patientDetails', 'lastName'],
                    jsonFile: 'file${widget.fileNum}',
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
                        jsonPath: [
                          'response',
                          'eventDetails',
                          'missionevent',
                        ],
                        jsonFile: 'file${widget.fileNum}',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'זמן הגעת הכונן',
                        jsonPath: ['response', 'eventDetails', 'timeArrived'],
                        jsonFile: 'file${widget.fileNum}',
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
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 255, 118, 44),
                  ),
                  child: Text(
                    'פרטי מטופל',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'AlmoniTzarAAA', // Updated font family
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
                        jsonPath: [
                          'response',
                          'patientDetails',
                          'idOrPassport'
                        ],
                        jsonFile: 'file${widget.fileNum}',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'שם פרטי מטופל',
                        jsonPath: ['response', 'patientDetails', 'firstName'],
                        jsonFile: 'file${widget.fileNum}',
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
                        jsonPath: ['response', 'patientDetails', 'lastName'],
                        jsonFile: 'file${widget.fileNum}',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'גיל המטופל',
                        jsonPath: ['response', 'patientDetails', 'age'],
                        jsonFile: 'file${widget.fileNum}',
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
                    jsonPath: ['response', 'patientDetails', 'gender'],
                    jsonFile: 'file${widget.fileNum}',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DefaultTextField(
                    labelText: 'ישוב המטופל',
                    jsonPath: ['response', 'patientDetails', 'city'],
                    jsonFile: 'file${widget.fileNum}',
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
                        jsonPath: ['response', 'patientDetails', 'street'],
                        jsonFile: 'file${widget.fileNum}',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'מספר בית מטופל',
                        jsonPath: ['response', 'patientDetails', 'houseNumber'],
                        jsonFile: 'file${widget.fileNum}',
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
                    jsonPath: ['response', 'patientDetails', 'phone'],
                    jsonFile: 'file${widget.fileNum}',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DefaultTextField(
                    labelText: 'מייל המטופל',
                    jsonPath: ['response', 'patientDetails', 'email'],
                    jsonFile: 'file${widget.fileNum}',
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
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 255, 118, 44),
                  ),
                  child: Text(
                    'ממצאים רפואיים',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'AlmoniTzarAAA', // Updated font family
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
                        jsonPath: [
                          'response',
                          'smartData',
                          'findings',
                          'caseFound'
                        ],
                        jsonFile: 'file${widget.fileNum}',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'סטטוס המטופל',
                        jsonPath: [
                          'response',
                          'smartData',
                          'findings',
                          'patientStatus'
                        ],
                        jsonFile: 'file${widget.fileNum}',
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
                        jsonPath: [
                          'response',
                          'smartData',
                          'findings',
                          'mainComplaint'
                        ],
                        jsonFile: 'file${widget.fileNum}',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'אבחון המטופל',
                        jsonPath: [
                          'response',
                          'smartData',
                          'findings',
                          'diagnosis'
                        ],
                        jsonFile: 'file${widget.fileNum}',
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
                        jsonPath: [
                          'response',
                          'smartData',
                          'findings',
                          'statusWhenFound'
                        ],
                        jsonFile: 'file${widget.fileNum}',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'אנמנזה וסיפור המקרה',
                        jsonPath: [
                          'response',
                          'smartData',
                          'findings',
                          'anamnesis'
                        ],
                        jsonFile: 'file${widget.fileNum}',
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
                    jsonPath: [
                      'response',
                      'smartData',
                      'findings',
                      'medicalSensitivities'
                    ],
                    jsonFile: 'file${widget.fileNum}',
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
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 255, 118, 44),
                  ),
                  child: Text(
                    'מדדים רפואיים',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'AlmoniTzarAAA', // Updated font family
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
                        jsonPath: [
                          'response',
                          'smartData',
                          'medicalMetrics',
                          'consciousnessLevel'
                        ],
                        jsonFile: 'file${widget.fileNum}',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'האזנה',
                        jsonPath: [
                          'response',
                          'smartData',
                          'medicalMetrics',
                          'Lung Auscultation'
                        ],
                        jsonFile: 'file${widget.fileNum}',
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
                        jsonPath: [
                          'response',
                          'smartData',
                          'medicalMetrics',
                          'breathingCondition'
                        ],
                        jsonFile: 'file${widget.fileNum}',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'קצב נשימה',
                        jsonPath: [
                          'response',
                          'smartData',
                          'medicalMetrics',
                          'breathingRate'
                        ],
                        jsonFile: 'file${widget.fileNum}',
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
                        jsonPath: [
                          'response',
                          'smartData',
                          'medicalMetrics',
                          'bloodPressure'
                        ],
                        jsonFile: 'file${widget.fileNum}',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'רמת פחמן דו חמצני',
                        jsonPath: [
                          'response',
                          'smartData',
                          'medicalMetrics',
                          'CO2Level'
                        ],
                        jsonFile: 'file${widget.fileNum}',
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
                        jsonPath: [
                          'response',
                          'smartData',
                          'medicalMetrics',
                          'lungCondition'
                        ],
                        jsonFile: 'file${widget.fileNum}',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'מצב העור',
                        jsonPath: [
                          'response',
                          'smartData',
                          'medicalMetrics',
                          'skinCondition'
                        ],
                        jsonFile: 'file${widget.fileNum}',
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
  final bool readFromJson;
  final List<String> jsonPath;
  final String jsonFile;

  const DefaultTextField({
    required this.labelText,
    this.readFromJson = true,
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
    _controller = TextEditingController(text: ""); // Temporary placeholder
    _initializeController();
  }

  Future<void> _initializeController() async {
    try {
      String initialValue =
          await readFromJson(widget.jsonPath, widget.jsonFile);
      setState(() {
        _controller.text = initialValue;
      });
    } catch (e) {
      print('Error initializing controller: $e');
    }
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

  Future<String> readFromJson(List<String> path, String jsonFile) async {
    try {
      print("data: ${path.join(' -> ')}");

      // Get the directory path and file path
      final directoryPath = (await getApplicationDocumentsDirectory()).path;
      final filePath = '$directoryPath/$jsonFile.json';
      final file = File(filePath);

      // Check if the file exists
      if (!await file.exists()) {
        print('File does not exist: $filePath');
        return "Invalid value"; // Return a default value
      }

      // Read the content of the file
      String content = await file.readAsString();
      if (content.isEmpty) {
        print('File is empty: $filePath');
        return "Invalid value"; // Return a default value
      }

      // Parse the JSON content
      Map<String, dynamic> jsonData = jsonDecode(content);

      // Traverse the path to retrieve the value
      Map<String, dynamic> currentMap = jsonData;
      for (int i = 0; i < path.length - 1; i++) {
        if (!currentMap.containsKey(path[i])) {
          print('Path not found: ${path[i]}');
          return "Invalid value"; // Return a default value
        }
        currentMap = currentMap[path[i]];
      }

      // Return the final value or a default value if the key doesn't exist
      return currentMap[path.last]?.toString() ?? "Invalid value";
    } catch (e) {
      print('Error reading from file: $e');
      return "Invalid value"; // Return a default value in case of an error
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
            fillColor: const Color.fromARGB(255, 255, 233, 186),
          ),
        ),
      ),
    );
  }
}
