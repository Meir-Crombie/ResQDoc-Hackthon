import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'tools.dart';
import 'package:path/path.dart' as path; // Add this import

Future<Map<String, dynamic>> readBackendJson() async {
  final String response = await rootBundle.loadString('data/dummydata.json');
  return jsonDecode(response);
}

Future<Map<String, dynamic>> readFrontendJson() async {
  final String response =
      await rootBundle.loadString('data/frontDataBase.json');
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
  Map<String, dynamic>? serverJsonData;
  Map<String, dynamic>? localJsonData;
  String? errorMessage;

  final GlobalKey _medicalMetricsKey = GlobalKey(debugLabel: 'medicalMetrics');
  final GlobalKey _findingsKey = GlobalKey(debugLabel: 'findings');
  final GlobalKey _patientDetailsKey = GlobalKey(debugLabel: 'patientDetails');
  final GlobalKey _eventDetailsKey = GlobalKey(debugLabel: 'eventDetails');
  final GlobalKey _medicDetailsKey = GlobalKey(debugLabel: 'medicDetails');

  @override
  void initState() {
    super.initState();
    // Create a FocusNode for each DefaultTextField
    for (int i = 0; i < 38; i++) {
      // Adjust based on your total number of fields
      focusNodes.add(FocusNode());
    }
    // Load JSON data and then execute subsequent code
    _initializeData();
  }

  Future<void> _initializeData() async {
    await loadJsonData(); // Ensure loadJsonData completes before proceeding

    List<String> texts = [
      localJsonData!['response']['eventDetails']['eventId'] ?? "Invalid value",
      localJsonData!['response']['eventDetails']['timeEventOpened'] ??
          "Invalid value",
      localJsonData!['response']['eventDetails']['eventCity'] ??
          "Invalid value",
      localJsonData!['response']['eventDetails']['eventHouseNumber'] ??
          "Invalid value",
      localJsonData!['response']['eventDetails']['eventStreet'] ??
          "Invalid value",
      localJsonData!['response']['eventDetails']['timeMedicArrived'] ??
          "Invalid value",
      localJsonData!['response']['patientDetails']['firstName'] ??
          "Invalid value",
      localJsonData!['response']['eventDetails']['caseThatWasLaunched'] ??
          "Invalid value",
    ];

    SaveToJson.saveToJson(texts); // Execute only after loadJsonData completes
  }

  //This method requests from the server the dummy data which is saved in the backend, if failed it will return a local dummy JSON
  Future<dynamic> readJsonFromServer(String fileName) async {
    try {
      if (fileName == "") {
        final response =
            await http.get(Uri.parse('http://20.84.43.139:5000/showCase'));
        if (response.statusCode == 200) {
          print("---------- HERE IS THE RESPONSE ----------");
          return jsonDecode(response.body);
        }
        throw Exception('Failed to load JSON data');
      } else {
        print("Entering API request");
        // Create multipart request
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://20.84.43.139:5000/final'),
        );

        // Add audio file to request
        var audioFile = await http.MultipartFile.fromPath(
          'audio', // field name expected by server
          fileName,
          filename: path.basename(fileName),
        );

        request.files.add(audioFile);

        // Send request
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          print("HELOO AGAIN NIGAA");
          return jsonDecode(response.body);
        }
        throw Exception('Failed to load JSON data');
      }
    } catch (e) {
      print('ERROR WHEN FETCHING FROM SERVER: $e');
      return await readBackendJson();
    }
  }

  Future<void> loadJsonData() async {
    try {
      // jsonData = await readJson();
      final jsonDataServer = await readJsonFromServer(widget.fileName);
      final jsonDataLocal = await readFrontendJson();
      serverJsonData = jsonDataServer;
      localJsonData = jsonDataLocal;

      print(
          'server JSON Loaded Successfully: $serverJsonData'); // הודעת דיבוגlocalJsonData
      print('\n');
      print('local JSON Loaded Successfully: $localJsonData'); // הודעת דיבוג

      setState(() {
        // jsonData = jsonDataLocal;
      });
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

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: Duration(milliseconds: 300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (serverJsonData == null) {
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
            icon: Icon(Icons.save), // Icon of your choice
            tooltip: 'save to json',
            color: const Color.fromARGB(255, 0, 255, 8),
            onPressed: () async {
              if (await StaticTools.checkEmptyValues()) {
                // All elements in allowSubmit are true
                Navigator.pushNamed(context, '/past');
              } else {
                // Not all elements are true
                print('Some fields are not ready yet.');
              }
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 234, 216, 236),
                                foregroundColor:
                                    const Color.fromARGB(255, 0, 0, 0),
                              ),
                              child: Text('מדדים רפואיים'),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                _scrollToSection(
                                    _findingsKey); // פעולה שתבוצע בלחיצה על הכפתור
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 234, 216, 236),
                                foregroundColor:
                                    const Color.fromARGB(255, 0, 0, 0),
                              ),
                              child: Text('ממצאים רפואיים'),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                _scrollToSection(
                                    _patientDetailsKey); // פעולה שתבוצע בלחיצה על הכפתור
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 234, 216, 236),
                                foregroundColor:
                                    const Color.fromARGB(255, 0, 0, 0),
                              ),
                              child: Text('פרטי מטופל'),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                _scrollToSection(
                                    _eventDetailsKey); // פעולה שתבוצע בלחיצה על הכפתור
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 234, 216, 236),
                                foregroundColor:
                                    const Color.fromARGB(255, 0, 0, 0),
                              ),
                              child: Text('פרטי אירוע'),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                _scrollToSection(
                                    _medicDetailsKey); // פעולה שתבוצע בלחיצה על הכפתור
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 234, 216, 236),
                                foregroundColor:
                                    const Color.fromARGB(255, 0, 0, 0),
                              ),
                              child: Text('פרטי כונן'),
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
                        initialValue: localJsonData!['response']
                                ['patientDetails']['idOrPassport'] ??
                            "Wrong Fetch",
                        checkedNode: true, // וודא שהפרמטר מועבר כאן
                        focusNode: focusNodes[0],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[1]);
                        },
                        writeToJson: null,
                        jsonPath: [],
                        isEditable: false,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'שם כונן',
                        checkedNode: true,
                        focusNode: focusNodes[1],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[2]);
                        },
                        initialValue: localJsonData!['response']
                                ['patientDetails']['firstName'] ??
                            "Wrong Fetch",
                        writeToJson: null,
                        jsonPath: [],
                        isEditable: false,
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
                        checkedNode: true,
                        focusNode: focusNodes[2],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[3]);
                        },
                        initialValue: localJsonData!['response']['eventDetails']
                                ['id'] ??
                            "Wrong Fetch",
                        jsonPath: ['response', 'eventDetails', 'id'],
                        isEditable: false,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'זמן פתיחת האירוע',
                        checkedNode: true,
                        focusNode: focusNodes[3],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[4]);
                        },
                        initialValue: localJsonData!['response']['eventDetails']
                                ['timeOpened'] ??
                            "Wrong Fetch",
                        jsonPath: ['response', 'eventDetails', 'timeOpened'],
                        isEditable: false,
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
                    checkedNode: true,
                    focusNode: focusNodes[4],
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) {
                      return FocusScope.of(context).requestFocus(focusNodes[5]);
                    },
                    initialValue: localJsonData!['response']['eventDetails']
                            ['city'] ??
                        "Wrong Fetch",
                    jsonPath: ['response', 'eventDetails', 'city'],
                    isEditable: false,
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
                        checkedNode: true,
                        focusNode: focusNodes[5],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[6]);
                        },
                        initialValue: localJsonData!['response']['eventDetails']
                                ['houseNumber'] ??
                            "Wrong Fetch",
                        writeToJson: null,
                        jsonPath: ['response', 'eventDetails', 'houseNumber'],
                        isEditable: false,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'רחוב',
                        checkedNode: true,
                        focusNode: focusNodes[6],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[7]);
                        },
                        initialValue: localJsonData!['response']['eventDetails']
                                ['street'] ??
                            "Wrong Fetch",
                        writeToJson: null,
                        jsonPath: ['response', 'eventDetails', 'street'],
                        isEditable: false,
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
                        labelText: 'המקרה שהוזנק',
                        checkedNode: true,
                        focusNode: focusNodes[8],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[9]);
                        },
                        initialValue: localJsonData!['response']['eventDetails']
                                ['missionevent'] ??
                            "Wrong Fetch",
                        writeToJson: null,
                        jsonPath: [
                          'response',
                          'eventDetails',
                          'missionevent',
                        ],
                        isEditable: false,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextField(
                        labelText: 'זמן הגעת הכונן',
                        checkedNode: true,
                        focusNode: focusNodes[9],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[10]);
                        },
                        initialValue: localJsonData!['response']['eventDetails']
                                ['timeArrived'] ??
                            "Wrong Fetch",
                        writeToJson: null,
                        jsonPath: ['response', 'eventDetails', 'timeArrived'],
                        isEditable: false,
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
                        initialValue:
                            serverJsonData!['response']['id'] ?? "Wrong Fetch",
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
                        initialValue: serverJsonData!['response']['name'] ??
                            "Wrong Fetch",
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
                        initialValue: serverJsonData!['response']['name'] ??
                            "Wrong Fetch",
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
                        initialValue:
                            serverJsonData!['response']['age'] ?? "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[14]);
                        },
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
                    initialValue: localJsonData!['response']['patientDetails']
                            ['gender'] ??
                        "Wrong Fetch",
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
                    initialValue:
                        serverJsonData!['response']['city'] ?? "Wrong Fetch",
                    onSubmitted: (_) {
                      return FocusScope.of(context)
                          .requestFocus(focusNodes[16]);
                    },
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
                        initialValue: localJsonData!['response']
                                ['patientDetails']['street'] ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[17]);
                        },
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
                        initialValue: localJsonData!['response']
                                ['patientDetails']['houseNumber'] ??
                            "Wrong Fetch",
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
                    initialValue: localJsonData!['response']['patientDetails']
                            ['phone'] ??
                        "Wrong Fetch",
                    onSubmitted: (_) {
                      return FocusScope.of(context)
                          .requestFocus(focusNodes[19]);
                    },
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
                    initialValue: localJsonData!['response']['patientDetails']
                            ['email'] ??
                        "Wrong Fetch",
                    onSubmitted: (_) {
                      return FocusScope.of(context)
                          .requestFocus(focusNodes[20]);
                    },
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
                        initialValue: localJsonData!['response']['smartData']
                                ['findings']['statusWhenFound'] ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[21]);
                        },
                        jsonPath: [
                          'response',
                          'smartData',
                          'findings',
                          'caseFound'
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
                        initialValue: serverJsonData!['response']['pain'] ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[23]);
                        },
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
                        initialValue: localJsonData!['response']['smartData']
                                ['findings']['mainComplaint'] ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[24]);
                        },
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
                        initialValue: localJsonData!['response']['smartData']
                                ['findings']['diagnosis'] ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[25]);
                        },
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
                        initialValue: localJsonData!['response']['smartData']
                                ['findings']['statusWhenFound'] ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[26]);
                        },
                        jsonPath: [
                          'response',
                          'smartData',
                          'findings',
                          'statusWhenFound'
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
                    focusNode: focusNodes[26],
                    textInputAction: TextInputAction.next,
                    initialValue: serverJsonData!['response']['allergies'] ??
                        "Wrong Fetch",
                    onSubmitted: (_) {
                      return FocusScope.of(context)
                          .requestFocus(focusNodes[27]);
                    },
                    jsonPath: [
                      'response',
                      'smartData',
                      'findings',
                      'medicalSensitivities'
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DefaultTextField(
                    labelText: 'אנמנזה וסיפור המקרה',
                    checkedNode: false,
                    focusNode: focusNodes[27],
                    textInputAction: TextInputAction.next,
                    initialValue: localJsonData!['response']['smartData']
                            ['findings']['anamnesis'] ??
                        "Wrong Fetch",
                    onSubmitted: (_) {
                      return FocusScope.of(context)
                          .requestFocus(focusNodes[28]);
                    },
                    jsonPath: [
                      'response',
                      'smartData',
                      'findings',
                      'anamnesis'
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
                        initialValue: localJsonData!['response']['smartData']
                                ['medicalMetrics']['consciousnessLevel'] ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[29]);
                        },
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
                        initialValue: localJsonData!['response']['smartData']
                                ['medicalMetrics']['Lung Auscultation'] ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[30]);
                        },
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
                        initialValue: localJsonData!['response']['smartData']
                                ['medicalMetrics']['breathingCondition'] ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[31]);
                        },
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
                        initialValue: localJsonData!['response']['smartData']
                                ['medicalMetrics']['breathingRate'] ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[32]);
                        },
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
                        initialValue: serverJsonData!['response']
                                ['bloodPressure'] ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[33]);
                        },
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
                        initialValue: localJsonData!['response']['smartData']
                                ['medicalMetrics']['CO2Level'] ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[34]);
                        },
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
                        initialValue: localJsonData!['response']['smartData']
                                ['medicalMetrics']['Lung Auscultation'] ??
                            "Wrong Fetch",
                        onSubmitted: (_) {
                          return FocusScope.of(context)
                              .requestFocus(focusNodes[35]);
                        },
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
                        initialValue: localJsonData!['response']['smartData']
                                ['medicalMetrics']['skinCondition'] ??
                            "Wrong Fetch",
                        onSubmitted: (_) {},
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
