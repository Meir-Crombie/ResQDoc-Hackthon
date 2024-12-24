import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<Map<String, dynamic>> readJson() async {
  final String response = await rootBundle.loadString('data/dummydata.json');
  return jsonDecode(response);
}

class ParamedicDoc extends StatefulWidget {
  const ParamedicDoc({super.key});

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

  Future<void> loadJsonData() async {
    try {
      jsonData = await readJson();
      print('JSON Loaded Successfully: $jsonData'); // הודעת דיבוג
      setState(() {});
    } catch (e) {
      print('Error loading JSON: $e'); // הודעת דיבוג במקרה של שגיאה
      errorMessage = 'Error loading JSON data';
      setState(() {});
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

  Future<void> writeToJson(String text, String labelText) async {
    try {
      print("data: is not null $text $labelText ");
      print("data: is not null");

      final directoryPath = 'storage/emulated/0/Documents';
      final filePath = '$directoryPath/file.json';
      final directory = Directory(directoryPath); // Ensure the directory exists
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      final file = File(filePath);
      Map<String, dynamic> jsonData; // Check if the file already exists
      if (await file.exists()) {
        // Read the current JSON data from the file
        String content = await file.readAsString();
        if (content.isNotEmpty) {
          jsonData = jsonDecode(content);
        } else {
          jsonData = {};
        }
      } else {
        // If the file does not exist, create an empty map
        jsonData = {};
      } // Update the existing label or add a new field
      jsonData[labelText] = text; // Write back the updated JSON data
      await file.writeAsString(jsonEncode(jsonData), mode: FileMode.write);
      print('Data written to file successfully');
    } catch (e) {
      print('Error writing to file: $e');
    }
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
                        initialValue: jsonData!['drivers'][0]['id'].toString(),
                        checkedNode: false, // וודא שהפרמטר מועבר כאן
                        focusNode: focusNodes[0],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[1]);
                        },
                        writeToJson: null,
                        jsontext: "ignore",
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
                        jsontext: "ignore",
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
                        checkedNode: false,
                        focusNode: focusNodes[2],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[3]);
                        },
                        initialValue: jsonData!['patients'][0]['id'].toString(),
                        writeToJson: null,
                        jsontext: "ignore",
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
                        jsontext: "ignore",
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
                    jsontext: "ignore",
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
                        jsontext: "ignore",
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
                        jsontext: "ignore",
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
                    checkedNode: false,
                    focusNode: focusNodes[7],
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) {
                      return FocusScope.of(context).requestFocus(focusNodes[8]);
                    },
                    initialValue: jsonData!['patients'][0]['name'].toString(),
                    writeToJson: null,
                    jsontext: "ignore",
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
                        jsontext: "ignore",
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
                        jsontext: "ignore",
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
                        jsontext: "idOrPassport",
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
                        jsontext: "firstName",
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
                        jsontext: "lastName",
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
                        jsontext: "age",
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
                    jsontext: "gender",
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
                    jsontext: "city",
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
                        jsontext: "street",
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
                        jsontext: "houseNumber",
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
                    jsontext: "phone",
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
                    jsontext: "email",
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
                        checkedNode: false,
                        focusNode: focusNodes[20],
                        textInputAction: TextInputAction.next,
                        initialValue: 'sd',
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[21]);
                        },
                        writeToJson: writeToJson,
                        jsontext: "findings",
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
                        jsontext: "patientStatus",
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
                        jsontext: "mainComplaint",
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
                        jsontext: "diagnosis",
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
                        jsontext: "statusWhenFound",
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
                        jsontext: "anamnesis",
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
                    jsontext: "medicalSensitivities",
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
                        checkedNode: false,
                        focusNode: focusNodes[28],
                        textInputAction: TextInputAction.next,
                        initialValue: 'sd',
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[29]);
                        },
                        writeToJson: writeToJson,
                        jsontext: "consciousnessLevel",
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
                        jsontext: "Lung Auscultation",
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
                        jsontext: "breathingCondition",
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
                        jsontext: "breathingRate",
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
                        jsontext: "bloodPressure",
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
                        jsontext: "CO2Level",
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
                        jsontext: "lungCondition",
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
                        jsontext: "skinCondition",
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
  final String initialValue; // Initial value for the text field
  bool checkedNode; // Mutable to toggle on double-tap
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Function(String text, String labelText)? writeToJson;
  final String jsontext;

  DefaultTextField({
    required this.labelText,
    required this.initialValue,
    required this.checkedNode,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
    required this.writeToJson,
    required this.jsontext,
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

  Future<void> writeToJson(String text, String labelText) async {
    try {
      print("data: $text $labelText");
      final directoryPath = 'storage/emulated/0/Documents';
      final filePath = '$directoryPath/file.json';
      final directory = Directory(directoryPath); // Ensure the directory exists
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      final file = File(filePath);
      Map<String, dynamic> jsonData; // Check if the file already exists
      if (await file.exists()) {
        // Read the current JSON data from the file
        String content = await file.readAsString();
        if (content.isNotEmpty) {
          jsonData = jsonDecode(content);
        } else {
          jsonData = {};
        }
      } else {
        // If the file does not exist, create an empty map
        jsonData = {};
      } // Update the existing label or add a new field
      jsonData[labelText] =
          text; // Write back the updated JSON data with a newline character
      await file.writeAsString('${jsonEncode(jsonData)}\n',
          mode: FileMode.write);
      print('Data written to file successfully');
    } catch (e) {
      print('Error writing to file: $e');
    }
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
            writeToJson(_controller.text, widget.labelText);
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
                  widget.labelText); // Write to JSON _saveTextFieldData();
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
