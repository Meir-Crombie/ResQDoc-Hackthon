import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'tools.dart';

Future<Map<String, dynamic>> readJson() async {
  final String response = await rootBundle.loadString('data/dummydata.json');
  return jsonDecode(response);
}

class ParamedicDoc extends StatefulWidget {
  //The path to the recording
  final String fileName;
  const ParamedicDoc({super.key, required this.fileName});
  @override
  State<ParamedicDoc> createState() => _ParamedicDocState();
}

class _ParamedicDocState extends State<ParamedicDoc> {
  final List<FocusNode> focusNodes = [];
  Map<String, dynamic>? jsonData;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    // Create a FocusNode for each DefaultTextField
    for (int i = 0; i < 38; i++) {
      // Adjust based on your total number of fields
      focusNodes.add(FocusNode());
    }
    loadJsonData();
  }

  Future<dynamic> readJsonFromServer(String fileName) async {
    try {
      final response =
          await http.get(Uri.parse('http://20.84.43.139:5000/analyze'));
      if (response.statusCode == 200) {
        jsonData = jsonDecode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to load JSON data');
      }
    } catch (e) {
      print('ERROR WHEN FETCHING FROM SERVER: $e');
      return await readJson();
    }
  }

  Future<void> loadJsonData() async {
    try {
      // jsonData = await readJson();
      jsonData = await readJsonFromServer(widget.fileName);
      print('JSON Loaded Successfully: $jsonData'); // הודעת דיבוג
      setState(() {});
    } catch (e) {
      print('Error loading JSON: $e'); // הודעת דיבוג במקרה של שגיאה
      errorMessage = 'Error loading JSON data';
      setState(() {});
    }
  }

  Future<void> writeToJson(String text, List<String> path) async {
    try {
      print("data: $text ${path.join(' -> ')}");
      final directoryPath = 'storage/emulated/0/Documents';
      final filePath = '$directoryPath/file.json';
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
          jsonData = jsonDecode(content);
        } else {
          jsonData = {
            "patientDetails": {},
            "smartData": {
              "findings": {},
              "medicalMetrics": {"bloodPressure": {}}
            }
          };
        }
      } else {
        // If the file does not exist, create the full structure
        jsonData = {
          "patientDetails": {},
          "smartData": {
            "findings": {},
            "medicalMetrics": {"bloodPressure": {}}
          }
        };
      }

      // Traverse the path and update the value
      Map<String, dynamic> currentMap = jsonData;
      for (int i = 0; i < path.length - 1; i++) {
        if (!currentMap.containsKey(path[i])) {
          currentMap[path[i]] = {};
        }
        currentMap = currentMap[path[i]];
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

  @override
  void dispose() {
    // Dispose of all FocusNodes
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (jsonData == null) {
      if (errorMessage != null) {
        return Center(child: Text(errorMessage!)); // הצגת הודעת שגיאה
      }
      return Center(child: CircularProgressIndicator()); // הצגת מחוון טעינה
    }
    // מציאת הערך "David Cohen" מתוך ה-JSON
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 254, 247),
      appBar: AppBar(
        title: Text('תיעוד רפואי מלא'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 123, 0),
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
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 255, 118, 44),
                    // Adding border for visibility
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
                        initialValue: jsonData!['drivers'][0]['id'].toString(),
                        checkedNode: false, // וודא שהפרמטר מועבר כאן
                        focusNode: focusNodes[0],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[1]);
                        },
                        writeToJson: null,
                        jsonPath: ['null', 'null'],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'שם כונן',
                        checkedNode: false,
                        focusNode: focusNodes[1],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[2]);
                        },
                        initialValue:
                            jsonData!['drivers'][0]['name'].toString(),
                        writeToJson: null,
                        jsonPath: ['null', 'null'],
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
                    border: Border.all(
                        color: const Color.fromARGB(255, 150, 179, 190),
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
                        checkedNode: false,
                        focusNode: focusNodes[2],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[3]);
                        },
                        initialValue: jsonData!['patients'][0]['id'].toString(),
                        writeToJson: null,
                        jsonPath: ['null', 'null'],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'זמן פתיחת האירוע',
                        checkedNode: false,
                        focusNode: focusNodes[3],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[4]);
                        },
                        initialValue: jsonData!['patients'][0]['id'].toString(),
                        writeToJson: null,
                        jsonPath: ['null', 'null'],
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
                    checkedNode: false,
                    focusNode: focusNodes[4],
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) {
                      return FocusScope.of(context).requestFocus(focusNodes[5]);
                    },
                    initialValue: jsonData!['patients'][0]['city'].toString(),
                    writeToJson: null,
                    jsonPath: ['null', 'null'],
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
                        checkedNode: false,
                        focusNode: focusNodes[5],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[6]);
                        },
                        initialValue:
                            jsonData!['patients'][0]['houseNumber'].toString(),
                        writeToJson: null,
                        jsonPath: ['null', 'null'],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'רחוב',
                        checkedNode: false,
                        focusNode: focusNodes[6],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[7]);
                        },
                        initialValue:
                            jsonData!['patients'][0]['street'].toString(),
                        writeToJson: null,
                        jsonPath: ['null', 'null'],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DefaultTextField(
                    labelText: 'שם המטופל',
                    checkedNode: false,
                    focusNode: focusNodes[7],
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) {
                      return FocusScope.of(context).requestFocus(focusNodes[8]);
                    },
                    initialValue: jsonData!['patients'][0]['name'].toString(),
                    writeToJson: null,
                    jsonPath: ['null', 'null'],
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
                        checkedNode: false,
                        focusNode: focusNodes[8],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[9]);
                        },
                        initialValue:
                            jsonData!['patients'][0]['name'].toString(),
                        writeToJson: null,
                        jsonPath: ['null', 'null'],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'זמן הגעת הכונן',
                        checkedNode: false,
                        focusNode: focusNodes[9],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[10]);
                        },
                        initialValue:
                            jsonData!['patients'][0]['name'].toString(),
                        writeToJson: null,
                        jsonPath: ['null', 'null'],
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
                    border: Border.all(
                        color: const Color.fromARGB(255, 150, 179, 190),
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
                        checkedNode: false,
                        focusNode: focusNodes[10],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[11]);
                        },
                        initialValue:
                            jsonData!['patients'][0]['name'].toString(),
                        writeToJson: writeToJson,
                        jsonPath: ['patientDetails', 'idOrPassport'],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'שם פרטי מטופל',
                        checkedNode: false,
                        focusNode: focusNodes[11],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[12]);
                        },
                        initialValue:
                            jsonData!['patients'][0]['name'].toString(),
                        writeToJson: writeToJson,
                        jsonPath: ['patientDetails', 'firstName'],
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
                        checkedNode: false,
                        focusNode: focusNodes[12],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[13]);
                        },
                        initialValue: 'sd',
                        writeToJson: writeToJson,
                        jsonPath: ['patientDetails', 'lastName'],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'גיל המטופל',
                        checkedNode: false,
                        focusNode: focusNodes[13],
                        textInputAction: TextInputAction.next,
                        initialValue: 'sd',
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[14]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: ['patientDetails', 'age'],
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
                    checkedNode: false,
                    focusNode: focusNodes[14],
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) {
                      return FocusScope.of(context)
                          .requestFocus(focusNodes[15]);
                    },
                    initialValue: 'sd',
                    writeToJson: writeToJson,
                    jsonPath: ['patientDetails', 'gender'],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DefaultTextField(
                    labelText: 'ישוב המטופל',
                    checkedNode: false,
                    focusNode: focusNodes[15],
                    textInputAction: TextInputAction.next,
                    initialValue: 'sd',
                    onSubmitted: (_) {
                      return FocusScope.of(context)
                          .requestFocus(focusNodes[16]);
                    },
                    writeToJson: writeToJson,
                    jsonPath: ['patientDetails', 'city'],
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
                        checkedNode: false,
                        focusNode: focusNodes[16],
                        textInputAction: TextInputAction.next,
                        initialValue: 'sd',
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[17]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: ['patientDetails', 'street'],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'מספר בית מטופל',
                        checkedNode: false,
                        focusNode: focusNodes[17],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[18]);
                        },
                        initialValue: 'sd',
                        writeToJson: writeToJson,
                        jsonPath: ['patientDetails', 'houseNumber'],
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
                    checkedNode: false,
                    focusNode: focusNodes[18],
                    textInputAction: TextInputAction.next,
                    initialValue: 'sd',
                    onSubmitted: (_) {
                      return FocusScope.of(context)
                          .requestFocus(focusNodes[19]);
                    },
                    writeToJson: writeToJson,
                    jsonPath: ['patientDetails', 'phone'],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DefaultTextField(
                    labelText: 'מייל המטופל',
                    checkedNode: false,
                    focusNode: focusNodes[19],
                    textInputAction: TextInputAction.next,
                    initialValue: 'sd',
                    onSubmitted: (_) {
                      return FocusScope.of(context)
                          .requestFocus(focusNodes[20]);
                    },
                    writeToJson: writeToJson,
                    jsonPath: ['patientDetails', 'email'],
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
                    border: Border.all(
                        color: const Color.fromARGB(255, 150, 179, 190),
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
                        checkedNode: false,
                        focusNode: focusNodes[20],
                        textInputAction: TextInputAction.next,
                        initialValue: 'sd',
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[21]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: ['smartData', 'finding'],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'סטטוס המטופל',
                        checkedNode: false,
                        focusNode: focusNodes[21],
                        textInputAction: TextInputAction.next,
                        initialValue: 'sd',
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[22]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: ['smartData', 'patientStatus'],
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
                        checkedNode: false,
                        focusNode: focusNodes[23],
                        textInputAction: TextInputAction.next,
                        initialValue: 'sd',
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[24]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: ['smartData', 'mainComplaint'],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'אבחון המטופל',
                        checkedNode: false,
                        focusNode: focusNodes[24],
                        textInputAction: TextInputAction.next,
                        initialValue: 'sd',
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[25]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: ['smartData', 'diagnosis'],
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
                        checkedNode: false,
                        focusNode: focusNodes[25],
                        textInputAction: TextInputAction.next,
                        initialValue: 'sd',
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[26]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: ['smartData', 'statusWhenFound'],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'אנמנזה וסיפור המקרה',
                        checkedNode: false,
                        focusNode: focusNodes[26],
                        textInputAction: TextInputAction.next,
                        initialValue: 'sd',
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[27]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: ['smartData', 'anamnesis'],
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
                    checkedNode: false,
                    focusNode: focusNodes[27],
                    textInputAction: TextInputAction.next,
                    initialValue: 'sd',
                    onSubmitted: (_) {
                      return FocusScope.of(context)
                          .requestFocus(focusNodes[28]);
                    },
                    writeToJson: writeToJson,
                    jsonPath: ['smartData', 'medicalSensitivities'],
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
                    border: Border.all(
                        color: const Color.fromARGB(255, 150, 179, 190),
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
                        checkedNode: false,
                        focusNode: focusNodes[28],
                        textInputAction: TextInputAction.next,
                        initialValue: 'sd',
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[29]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: ['medicalMetrics', 'consciousnessLevel'],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'האזנה',
                        checkedNode: false,
                        focusNode: focusNodes[29],
                        textInputAction: TextInputAction.next,
                        initialValue: 'sd',
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[30]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: ['medicalMetrics', 'Lung Auscultation'],
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
                        checkedNode: false,
                        focusNode: focusNodes[30],
                        textInputAction: TextInputAction.next,
                        initialValue: 'sd',
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[31]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: ['medicalMetrics', 'breathingCondition'],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'קצב נשימה',
                        checkedNode: false,
                        focusNode: focusNodes[31],
                        textInputAction: TextInputAction.next,
                        initialValue: '',
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[32]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: ['medicalMetrics', 'breathingRate'],
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
                        checkedNode: false,
                        focusNode: focusNodes[32],
                        textInputAction: TextInputAction.next,
                        initialValue: 'sd',
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[33]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: ['medicalMetrics', 'bloodPressure'],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'רמת פחמן דו חמצני',
                        checkedNode: false,
                        focusNode: focusNodes[33],
                        textInputAction: TextInputAction.next,
                        initialValue: '',
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[34]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: ['medicalMetrics', 'CO2Level'],
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
                        checkedNode: false,
                        focusNode: focusNodes[34],
                        textInputAction: TextInputAction.next,
                        initialValue: 'sd',
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[35]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: ['medicalMetrics', 'lungCondition'],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'מצב העור',
                        checkedNode: false,
                        focusNode: focusNodes[35],
                        textInputAction: TextInputAction.next,
                        initialValue: '',
                        onSubmitted: (_) {},
                        writeToJson: writeToJson,
                        jsonPath: ['medicalMetrics', 'skinCondition'],
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
