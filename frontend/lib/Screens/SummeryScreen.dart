import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/widgets/RowOfContent.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

const double spaceBetweenNodes = 100;
const double widthOfLine = 1.1;
const int startColor = 0xffffFF5900;
const int endColor = 0xffffFEFEFE;

late GoogleMapController mapController;

void _onMapCreated(GoogleMapController controller) {
  mapController = controller;
}

//The function call back to show google maps
void googleMapsShow(ctx, lat, log) {
  showGeneralDialog(
    context: ctx,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(ctx).modalBarrierDismissLabel,
    barrierColor: Colors.black45,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (BuildContext buildContext, Animation animation,
        Animation secondaryAnimation) {
      return Center(
        child: Container(
          height: 300,
          width: 300,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(45.521563, -122.677433),
              zoom: 11.0,
            ),
            myLocationEnabled: true,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
        child: child,
      );
    },
  );
}

var DummySystemJSON = {
  "Phase Two": {
    "Agents": "Shmuel",
    "Arrived At": "15:05",
  }
};
var DummyBackendJSON = {
  "Phase One": {
    "Location": "Jerusalem",
    "Call Accepted At": "15:00",
  },
  "Phase Three": {
    "Main Couse": "Animal bite",
  },
  "Phase Four": {
    "Treatments Given": ["CPR", "epipen"],
    "Took At": "15:13",
  },
  "Phase Five": {
    "Status": "Patient R.I.P ☠️",
    "Call Closed At": "15:40",
  },
};
Future<Map<String, dynamic>> loadJsonFromFile(String fileNumber) async {
  try {
    // Load local JSON file
    final directoryPath = (await getApplicationDocumentsDirectory()).path;
    final filePath = '$directoryPath/file$fileNumber.json';
    final file = File(filePath);
    final jsonString = await file.readAsString();
    final jsonData = json.decode(jsonString);

    // Extract response field
    if (!jsonData.containsKey('response')) {
      throw Exception('No response field in JSON');
    }
    print("SNET");
    // Send POST request to server
    final response = await http.post(
      Uri.parse('http://http://20.84.43.139:5000/summary'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'response': jsonData['response']}),
    );
    print("GOT");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get summary: ${response.statusCode}');
    }
  } catch (e) {
    print('Error processing JSON: $e');
    throw Exception('Failed to process JSON file');
  }
}

class SummeryScreen extends StatefulWidget {
  const SummeryScreen({super.key, this.filepath});
  final String? filepath;

  @override
  State<SummeryScreen> createState() => _SummeryScreenState();
}

class _SummeryScreenState extends State<SummeryScreen> {
  Map<String, dynamic>? jsonData; // Make nullable

  @override
  void initState() {
    super.initState();
    if (widget.filepath != null) {
      loadJsonFromFile(widget.filepath!).then((data) {
        setState(() {
          jsonData = data;
        });
      }).catchError((error) {
        print('Error loading JSON: $error');
        // Handle error state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(jsonData);
    if (jsonData == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      body: Container(
        //Gradient coloring
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [0.025, 1.0], // Start at 20% from bottom
            colors: [
              Color(startColor),
              Color(endColor),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Phase one - Call Accepted
              RowofContent(
                mainTitleLeft: "Call Been Received",
                subTitleLeft: "Area: ${jsonData!["Phase One"]!["Location"]}",
                clockValue: "${jsonData!["Phase One"]!["Call Accepted At"]}",
                icon: Icons.inbox,
                onPressFunc: () =>
                    googleMapsShow(context, 45.521563, -122.677433),
              ),
              Container(
                width: widthOfLine, // Line thickness
                height: spaceBetweenNodes, // Line height
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                margin: EdgeInsets.symmetric(horizontal: 10),
              ),

              //Phase two - Wearing arrived
              RowofContent(
                onPressFunc: () {},
                mainTitleLeft: "Wearing has arrived",
                subTitleLeft:
                    "Agent: ${DummySystemJSON["Phase Two"]!["Agents"]}", //TODO: Fix, and promot all the agents
                clockValue: "${DummySystemJSON["Phase Two"]!["Arrived At"]}",
                icon: Icons.account_balance,
              ),
              Container(
                width: widthOfLine, // Line thickness
                height: spaceBetweenNodes, // Line height
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                margin: EdgeInsets.symmetric(horizontal: 10),
              ),

              //Phase three - Couses
              RowofContent(
                onPressFunc: () {},
                mainTitleLeft: "Main Couse",
                subTitleLeft:
                    "Case Found: ${jsonData!["Phase Three"]!["Main Couse"]}",
                clockValue:
                    "${DummySystemJSON["Phase Two"]!["Arrived At"]}", //TODO: Fix its to have more meaningfull value
                icon: Icons.info,
              ),
              Container(
                width: widthOfLine, // Line thickness
                height: spaceBetweenNodes, // Line height
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                margin: EdgeInsets.symmetric(horizontal: 10),
              ),

              //Phase four - Treatments
              RowofContent(
                onPressFunc: () {},
                mainTitleLeft: "Treatments given",
                subTitleLeft:
                    "Action: ${jsonData!["Phase Four"]!["Treatments Given"]}",
                clockValue: "${jsonData!["Phase Four"]!["Took At"]}",
                icon: Icons.account_tree_outlined,
              ),
              Container(
                width: widthOfLine, // Line thickness
                height: spaceBetweenNodes, // Line height
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                margin: EdgeInsets.symmetric(horizontal: 10),
              ),

              //Phase fine - Call closed
              RowofContent(
                onPressFunc: () {},
                mainTitleLeft: "Call Closed",
                subTitleLeft: "Status: ${jsonData!["Phase Five"]!["Status"]}",
                clockValue:
                    "${DummyBackendJSON["Phase Five"]!["Call Closed At"]}",
                icon: Icons.check,
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton.icon(
                //TODO return to home screen
                onPressed: () {},
                icon: Icon(Icons.call_missed_outgoing_rounded),
                label: Text("Back"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
