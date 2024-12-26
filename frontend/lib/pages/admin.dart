import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/pages/past_doc.dart';
import 'package:path_provider/path_provider.dart';
import 'history_for_maneger.dart';

class AdminsPage extends StatefulWidget {
  @override
  _AdminsPageState createState() => _AdminsPageState();
}

class _AdminsPageState extends State<AdminsPage> {
  List<int> missionFiles = [];

  @override
  void initState() {
    super.initState();
    _loadMissionFiles();
  }

  Future<String?> readFromJson(List<String> path, int jsonNum) async {
    try {
      print("Path to read: ${path.join(' -> ')}");

      // Get the file path
      final directoryPath = (await getApplicationDocumentsDirectory()).path;
      final filePath = '$directoryPath/verified$jsonNum.json';
      final file = File(filePath);

      print('Reading from file: $filePath');

      // Check if the file exists
      if (await file.exists()) {
        // Read the JSON data from the file
        String content = await file.readAsString();
        print('File content: $content');
        if (content.isNotEmpty) {
          Map<String, dynamic> jsonData =
              Map<String, dynamic>.from(jsonDecode(content));
          print('Parsed JSON: $jsonData');

          // Traverse the path to fetch the value
          Map<String, dynamic> currentMap = jsonData;
          for (int i = 0; i < path.length - 1; i++) {
            if (currentMap.containsKey(path[i])) {
              currentMap = currentMap[path[i]] as Map<String, dynamic>;
              print("Current map after '${path[i]}': $currentMap");
            } else {
              print('Path does not exist: ${path[i]}');
              return null;
            }
          }
          // Return the value at the last key in the path
          return currentMap[path.last]?.toString();
        }
      }

      print('File does not exist or is empty.');
      return null;
    } catch (e) {
      print('Error reading from file: $e');
      return null;
    }
  }

  Future<void> _loadMissionFiles() async {
    final directoryPath = await getApplicationDocumentsDirectory();
    final directory = directoryPath;

    // List all files in the directory
    List<FileSystemEntity> files =
        directory.listSync().whereType<File>().toList();
    for (var file in files) {
      if (file is File && file.path.endsWith('.json')) {
        // Extract the mission number from the file name using regex (e.g., mission2.json -> 2)
        String fileName = file.path.split('/').last;
        RegExp regExp = RegExp(
            r'^file(\d+)\.json$'); // Ensure it matches only mission$num.json
        Match? match = regExp.firstMatch(fileName);
        if (match != null) {
          int missionNum = int.parse(match.group(1)!);
          print(
              'Found mission file: $fileName with mission number: $missionNum'); // Debugging print
          setState(() {
            missionFiles.add(missionNum);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('אישור קריאות', style: TextStyle(fontFamily: 'AlmoniTzarAAA')),
        backgroundColor: const Color.fromARGB(255, 255, 123, 0),
      ),
      body: missionFiles.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: missionFiles.length,
              itemBuilder: (context, index) {
                int missionNum = missionFiles[index];
                return FutureBuilder<List<bool>>(
                  future: _checkMissionProgress(missionNum),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListTile(
                        title: Text(
                          'Loading mission $missionNum...',
                          style: TextStyle(color: Colors.white),
                        ),
                        tileColor: const Color.fromARGB(255, 255, 255, 255),
                      );
                    } else if (snapshot.hasError || snapshot.data == null) {
                      return ListTile(
                        title: Text(
                          '$missionNum אירוע',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'Error reading file or data not found',
                          style: TextStyle(color: Colors.white70),
                        ),
                        tileColor: Colors.redAccent,
                      );
                    } else {
                      double progress =
                          snapshot.data!.where((v) => v).length / 5;
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(
                                8.0), // Adjust padding as needed
                            child: ListTile(
                              title: Text(
                                '$missionNum אירוע',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Verified Progress: ${(progress * 100).toStringAsFixed(0)}%',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  SizedBox(
                                      height:
                                          8), // Space between text and progress bar
                                  ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return LinearGradient(
                                        colors: progress > 0
                                            ? [Colors.green, Colors.orange]
                                            : [Colors.orange, Colors.orange],
                                        stops: [0.0, 1.0],
                                      ).createShader(
                                        Rect.fromLTRB(
                                            0,
                                            0,
                                            bounds.width * progress,
                                            bounds.height),
                                      );
                                    },
                                    blendMode: BlendMode.srcIn,
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      backgroundColor: Colors.grey[300],
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              tileColor:
                                  const Color.fromARGB(255, 247, 139, 76),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PastDocForConfirmation(
                                            fileNum: '$missionNum'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                );
              },
            ),
      endDrawer: _buildEndDrawer(context),
    );
  }

  Future<List<bool>> _checkMissionProgress(int missionNum) async {
    try {
      final results = await Future.wait([
        readFromJson(['verified', 'eventId'], missionNum),
        readFromJson(['verified', 'patientDetails'], missionNum),
        readFromJson(['verified', 'smartData', 'findings'], missionNum),
        readFromJson(['verified', 'smartData', 'medicalMetrics'], missionNum),
        readFromJson(['verified', 'eventDetails'], missionNum),
      ]);

      return results
          .map((result) => (result != "false" && result != null))
          .toList();
    } catch (e) {
      return [false, false, false, false, false];
    }
  }

  Widget _buildEndDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 255, 163, 110),
              const Color.fromARGB(255, 255, 255, 255),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 255, 255, 255),
                      const Color.fromARGB(255, 247, 139, 76),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/logo_ichud_2.png',
                      fit: BoxFit.cover,
                      height: 100,
                      width: 167,
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text(
                  'בית',
                  style: TextStyle(fontFamily: 'AlmoniTzarAAA'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/home');
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text(
                  'היסטוריה',
                  style: TextStyle(fontFamily: 'AlmoniTzarAAA'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/history');
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text(
                  'הגדרות',
                  style: TextStyle(fontFamily: 'AlmoniTzarAAA'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text(
                  'About',
                  style: TextStyle(fontFamily: 'AlmoniTzarAAA'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/about');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
