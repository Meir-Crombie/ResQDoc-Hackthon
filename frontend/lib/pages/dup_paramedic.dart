import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'dup_tools.dart';

Future<Map<String, dynamic>> readJson() async {
  final String response = await rootBundle.loadString('data/dummydata.json');
  return jsonDecode(response);
}

class ParamedicDoc extends StatefulWidget {
  const ParamedicDoc({super.key, required this.fileName});
  final String fileName;
  @override
  State<ParamedicDoc> createState() => _ParamedicDocState();
}

//class HomePage extends StatefulWidget {
//  const HomePage({super.key});
//  @override
//  State<HomePage> createState() => _HomePageState();
//}

//class _HomePageState extends State<HomePage> {}

class _ParamedicDocState extends State<ParamedicDoc> {
  final List<FocusNode> focusNodes = [];
  Map<String, dynamic>? jsonData;
  String? errorMessage;

  final ScrollController _scrollController =
      ScrollController(); // צור ScrollController
  final GlobalKey _medicalMetricsKey = GlobalKey();
  final GlobalKey _findingsKey = GlobalKey();
  final GlobalKey _patientDetailsKey = GlobalKey();
  final GlobalKey _eventDetailsKey = GlobalKey();
  final GlobalKey _medicDetailsKey = GlobalKey();

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

  //This method requests from the server the dummy data which is saved in the backend, if failed it will return a local dummy JSON
  Future<dynamic> readJsonFromServer(String fileName) async {
    try {
      final response =
          await http.get(Uri.parse('http://20.84.43.139:5000/analyzeDemo'));
      if (response.statusCode == 200) {
        print("---------- HERE IS THE RESPONSE ----------");
        return jsonDecode(response.body);
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
      final jsonDataLocal = await readJsonFromServer(widget.fileName);
      jsonData = jsonDataLocal;

      print('JSON Loaded Successfully: $jsonData'); // הודעת דיבוג
      print('Specificly: $jsonData["response"]["patientDetails"]');
      print('Specificly: $jsonData["response"]["patientDetails"]["firstName"]');
      setState(() {
        // jsonData = jsonDataLocal;
      });
    } catch (e) {
      print('Error loading JSON: $e'); // הודעת דיבוג במקרה של שגיאה
      errorMessage = 'Error loading JSON data';
      setState(() {});
    }
  }

  Future<void> writeToJson(String text, List<String> path) async {}

  @override
  void dispose() {
    // Dispose of all FocusNodes
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context,
          duration: Duration(seconds: 1), curve: Curves.easeInOut);
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
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text('תיעוד רפואי מלא'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 123, 0),
        actions: [
          IconButton(
            icon: Icon(Icons.local_hospital), // Icon of your choice
            tooltip: 'Paramedic',
            onPressed: () {
              Navigator.pushNamed(context, '/past');
            },
          ),
        ],
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
                          children: [
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                _scrollToSection(
                                    _medicalMetricsKey); // פעולה שתבוצע בלחיצה על הכפתור
                              },
                              child: Text('מדדים רפואיים'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 250, 190, 255),
                                foregroundColor:
                                    const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                _scrollToSection(
                                    _findingsKey); // פעולה שתבוצע בלחיצה על הכפתור
                              },
                              child: Text('ממצאים רפואיים'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 250, 190, 255),
                                foregroundColor:
                                    const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                _scrollToSection(
                                    _patientDetailsKey); // פעולה שתבוצע בלחיצה על הכפתור
                              },
                              child: Text('פרטי מטופל'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 250, 190, 255),
                                foregroundColor:
                                    const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                _scrollToSection(
                                    _eventDetailsKey); // פעולה שתבוצע בלחיצה על הכפתור
                              },
                              child: Text('פרטי אירוע'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 250, 190, 255),
                                foregroundColor:
                                    const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                _scrollToSection(
                                    _medicDetailsKey); // פעולה שתבוצע בלחיצה על הכפתור
                              },
                              child: Text('פרטי כונן'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 250, 190, 255),
                                foregroundColor:
                                    const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            SizedBox(width: 8),
                          ]))),
            )),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: ScrollController(),
          // עטוף את התוכן ב-SingleChildScrollView
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  key: _medicDetailsKey,
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
                    key: _medicDetailsKey,
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
                        initialValue: jsonData!['response']['patientDetails']
                                    ['idOrPassport']
                                ?.toString() ??
                            "Wrong Fetch",
                        checkedNode: false, // וודא שהפרמטר מועבר כאן
                        focusNode: focusNodes[0],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[1]);
                        },
                        writeToJson: null,
                        jsonPath: [
                          'response',
                          'patientDetails',
                          'idOrPassport'
                        ],
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
                        initialValue: jsonData!['response']['patientDetails']
                                    ['firstName']
                                ?.toString() ??
                            "Wrong Fetch",
                        writeToJson: null,
                        jsonPath: ['response', 'patientDetails', 'firstName'],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  key: _eventDetailsKey,
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
                        initialValue: jsonData!['response']['patientDetails']
                                    ['lastName']
                                ?.toString() ??
                            "Wrong Fetch",
                        writeToJson: writeToJson,
                        jsonPath: ['response', 'eventDetails', 'id'],
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
                        initialValue: jsonData!['response']['patientDetails']
                                    ['age']
                                ?.toString() ??
                            "Wrong Fetch",
                        writeToJson: writeToJson,
                        jsonPath: ['response', 'eventDetails', 'timeOpened'],
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
                    initialValue: jsonData!['response']['patientDetails']
                                ['city']
                            ?.toString() ??
                        "Wrong Fetch",
                    writeToJson: writeToJson,
                    jsonPath: ['response', 'eventDetails', 'city'],
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
                        initialValue: jsonData!['response']['patientDetails']
                                    ['houseNumber']
                                ?.toString() ??
                            "Wrong Fetch",
                        writeToJson: writeToJson,
                        jsonPath: ['response', 'eventDetails', 'houseNumber'],
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
                        initialValue: jsonData!['response']['patientDetails']
                                    ['street']
                                ?.toString() ??
                            "Wrong Fetch",
                        writeToJson: writeToJson,
                        jsonPath: ['response', 'eventDetails', 'street'],
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
                    initialValue: jsonData!['response']['patientDetails']
                                ['firstName']
                            ?.toString() ??
                        "Wrong Fetch",
                    writeToJson: writeToJson,
                    jsonPath: ['response', 'eventDetails', 'patientName'],
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
                        initialValue: jsonData!['response']['smartData']
                                    ['findings']['mainComplaint']
                                ?.toString() ??
                            "Wrong Fetch",
                        writeToJson: writeToJson,
                        jsonPath: ['response', 'eventDetails', 'missionEvent'],
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
                        initialValue: jsonData!['response']['smartData']
                                    ['findings']['statusWhenFound']
                                ?.toString() ??
                            "Wrong Fetch",
                        writeToJson: writeToJson,
                        jsonPath: ['response', 'eventDetails', 'timeArrived'],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  key: _patientDetailsKey,
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
                        initialValue: jsonData!['response']['patientDetails']
                                    ['idOrPassport']
                                ?.toString() ??
                            "Wrong Fetch",
                        writeToJson: writeToJson,
                        jsonPath: [
                          'response',
                          'patientDetails',
                          'idOrPassport'
                        ],
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
                        initialValue: jsonData!['response']['patientDetails']
                                    ['firstName']
                                ?.toString() ??
                            "Wrong Fetch",
                        writeToJson: writeToJson,
                        jsonPath: ['response', 'patientDetails', 'firstName'],
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
                        initialValue: jsonData!['response']['patientDetails']
                                    ['lastName']
                                ?.toString() ??
                            "Wrong Fetch",
                        writeToJson: writeToJson,
                        jsonPath: ['response', 'patientDetails', 'lastName'],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'גיל המטופל',
                        checkedNode: false,
                        focusNode: focusNodes[13],
                        textInputAction: TextInputAction.next,
                        initialValue: jsonData!['response']['patientDetails']
                                    ['age']
                                ?.toString() ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[14]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: ['response', 'patientDetails', 'age'],
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
                    initialValue: jsonData!['response']['patientDetails']
                                ['gender']
                            ?.toString() ??
                        "Wrong Fetch",
                    writeToJson: writeToJson,
                    jsonPath: ['response', 'patientDetails', 'gender'],
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
                    initialValue: jsonData!['response']['patientDetails']
                                ['city']
                            ?.toString() ??
                        "Wrong Fetch",
                    onSubmitted: (_) {
                      return FocusScope.of(context)
                          .requestFocus(focusNodes[16]);
                    },
                    writeToJson: writeToJson,
                    jsonPath: ['response', 'patientDetails', 'city'],
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
                        initialValue: jsonData!['response']['patientDetails']
                                    ['street']
                                ?.toString() ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[17]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: ['response', 'patientDetails', 'street'],
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
                        initialValue: jsonData!['response']['patientDetails']
                                    ['houseNumber']
                                ?.toString() ??
                            "Wrong Fetch",
                        writeToJson: writeToJson,
                        jsonPath: ['response', 'patientDetails', 'houseNumber'],
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
                    initialValue: jsonData!['response']['patientDetails']
                                ['phone']
                            ?.toString() ??
                        "Wrong Fetch",
                    onSubmitted: (_) {
                      return FocusScope.of(context)
                          .requestFocus(focusNodes[19]);
                    },
                    writeToJson: writeToJson,
                    jsonPath: ['response', 'patientDetails', 'phone'],
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
                    initialValue: jsonData!['response']['patientDetails']
                                ['email']
                            ?.toString() ??
                        "Wrong Fetch",
                    onSubmitted: (_) {
                      return FocusScope.of(context)
                          .requestFocus(focusNodes[20]);
                    },
                    writeToJson: writeToJson,
                    jsonPath: ['response', 'patientDetails', 'email'],
                  ),
                ),
              ),

              //Header - Medical Findings Details
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  key: _findingsKey,
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
                        initialValue: jsonData!['response']['smartData']
                                    ['findings']['statusWhenFound']
                                ?.toString() ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[21]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: [
                          'response',
                          'smartData',
                          'findings',
                          'statusWhenFound'
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'סטטוס המטופל',
                        checkedNode: false,
                        focusNode: focusNodes[21],
                        textInputAction: TextInputAction.next,
                        initialValue: jsonData!['response']['smartData']
                                    ['findings']['patientStatus']
                                ?.toString() ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[22]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: [
                          'response',
                          'smartData',
                          'findings',
                          'patientStatus'
                        ],
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
                        initialValue: jsonData!['response']['smartData']
                                    ['findings']['mainComplaint']
                                ?.toString() ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[24]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: [
                          'response',
                          'smartData',
                          'findings',
                          'mainComplaint'
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'אבחון המטופל',
                        checkedNode: false,
                        focusNode: focusNodes[24],
                        textInputAction: TextInputAction.next,
                        initialValue: jsonData!['response']['smartData']
                                    ['findings']['diagnosis']
                                ?.toString() ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[25]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: [
                          'response',
                          'smartData',
                          'findings',
                          'diagnosis'
                        ],
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
                        initialValue: jsonData!['response']['smartData']
                                    ['findings']['statusWhenFound']
                                ?.toString() ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[26]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: [
                          'response',
                          'smartData',
                          'findings',
                          'statusWhenFound'
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'אנמנזה וסיפור המקרה',
                        checkedNode: false,
                        focusNode: focusNodes[26],
                        textInputAction: TextInputAction.next,
                        initialValue: jsonData!['response']['smartData']
                                    ['findings']['anamnesis']
                                ?.toString() ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[27]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: [
                          'response',
                          'smartData',
                          'findings',
                          'anamnesis'
                        ],
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
                    initialValue: jsonData!['response']['smartData']['findings']
                                ['medicalSensitivities']
                            ?.toString() ??
                        "Wrong Fetch",
                    onSubmitted: (_) {
                      return FocusScope.of(context)
                          .requestFocus(focusNodes[28]);
                    },
                    writeToJson: writeToJson,
                    jsonPath: [
                      'response',
                      'smartData',
                      'findings',
                      'medicalSensitivities'
                    ],
                  ),
                ),
              ),

              //Header - Medical Messuerments Details
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  key: _medicalMetricsKey,
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
                        initialValue: jsonData!['response']['smartData']
                                    ['medicalMetrics']['consciousnessLevel']
                                ?.toString() ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[29]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: [
                          'response',
                          'smartData',
                          'medicalMetrics',
                          'consciousnessLevel'
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'האזנה',
                        checkedNode: false,
                        focusNode: focusNodes[29],
                        textInputAction: TextInputAction.next,
                        initialValue: jsonData!['response']['smartData']
                                    ['medicalMetrics']['Lung Auscultation']
                                ?.toString() ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[30]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: [
                          'response',
                          'smartData',
                          'medicalMetrics',
                          'Lung Auscultation'
                        ],
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
                        initialValue: jsonData!['response']['smartData']
                                    ['medicalMetrics']['breathingCondition']
                                ?.toString() ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[31]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: [
                          'response',
                          'smartData',
                          'medicalMetrics',
                          'breathingCondition'
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'קצב נשימה',
                        checkedNode: false,
                        focusNode: focusNodes[31],
                        textInputAction: TextInputAction.next,
                        initialValue: jsonData!['response']['smartData']
                                    ['medicalMetrics']['breathingRate']
                                ?.toString() ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[32]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: [
                          'response',
                          'smartData',
                          'medicalMetrics',
                          'breathingRate'
                        ],
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
                        initialValue: jsonData!['response']['smartData']
                                    ['medicalMetrics']['bloodPressure']['value']
                                ?.toString() ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[33]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: [
                          'response',
                          'smartData',
                          'medicalMetrics',
                          'bloodPressure'
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'רמת פחמן דו חמצני',
                        checkedNode: false,
                        focusNode: focusNodes[33],
                        textInputAction: TextInputAction.next,
                        initialValue: jsonData!['response']['smartData']
                                    ['medicalMetrics']['CO2Level']
                                ?.toString() ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[34]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: [
                          'response',
                          'smartData',
                          'medicalMetrics',
                          'CO2Level'
                        ],
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
                        initialValue: jsonData!['response']['smartData']
                                    ['medicalMetrics']['Lung Auscultation']
                                ?.toString() ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[35]);
                        },
                        writeToJson: writeToJson,
                        jsonPath: [
                          'response',
                          'smartData',
                          'medicalMetrics',
                          'lungCondition'
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'מצב העור',
                        checkedNode: false,
                        focusNode: focusNodes[35],
                        textInputAction: TextInputAction.next,
                        initialValue: jsonData!['response']['smartData']
                                    ['medicalMetrics']['skinCondition']
                                ?.toString() ??
                            "Wrong Fetch",
                        onSubmitted: (_) {},
                        writeToJson: writeToJson,
                        jsonPath: [
                          'response',
                          'smartData',
                          'medicalMetrics',
                          'skinCondition'
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
