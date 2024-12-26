import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/pages/past_doc.dart';
import 'package:path_provider/path_provider.dart';

class MissionsPage extends StatefulWidget {
  const MissionsPage({super.key});

  @override
  _MissionsPageState createState() => _MissionsPageState();
}

class _MissionsPageState extends State<MissionsPage> {
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
      final filePath = '$directoryPath/file$jsonNum.json';
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
        title: Text('היסטוריית קריאות',
            style: TextStyle(fontFamily: 'AlmoniTzarAAA')),
        backgroundColor: const Color.fromARGB(255, 255, 123, 0),
      ),
      body: missionFiles.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: missionFiles.length,
              itemBuilder: (context, index) {
                int missionNum = missionFiles[index];
                return FutureBuilder<String?>(
                  future: readFromJson(
                      ['response', 'eventDetails', 'id'], missionNum),
                  builder: (context, snapshot) {
                    SizedBox(height: 10);
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
                          'Mission $missionNum',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'Error reading file or data not found',
                          style: TextStyle(color: Colors.white70),
                        ),
                        tileColor: Colors.redAccent,
                      );
                    } else {
                      return ListTile(
                        title: Text(
                          'Mission $missionNum',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'ID: ${snapshot.data}',
                          style: TextStyle(color: Colors.white70),
                        ),
                        tileColor: const Color.fromARGB(255, 247, 139, 76),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PastDoc(fileNum: '$missionNum'),
                            ),
                          );
                        },
                      );
                    }
                  },
                );
              },
            ),
      endDrawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(
                    255, 255, 163, 110), // Gradient start color
                const Color.fromARGB(255, 255, 255, 255), // Gradient end color
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl, // Force LTR alignment
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(
                            255, 255, 255, 255), // Gradient color for header
                        const Color.fromARGB(255, 247, 139, 76),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/logo_ichud_2.png', // Add your image asset path here
                        fit: BoxFit.cover,
                        height: 100,
                        width: 167,
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home), // Info icon
                  title: const Text(
                    'בית',
                    style: TextStyle(
                      fontFamily: 'AlmoniTzarAAA', // Updated font family
                    ),
                  ), // About text
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.pushNamed(context, '/home'); // Navigate to home
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history), // Info icon
                  title: const Text(
                    'היסטוריה',
                    style: TextStyle(
                      fontFamily: 'AlmoniTzarAAA', // Updated font family
                    ),
                  ), // History text
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.pushNamed(
                        context, '/history'); // Navigate to history
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings), // Settings icon
                  title: const Text(
                    'הגדרות',
                    style: TextStyle(
                      fontFamily: 'AlmoniTzarAAA', // Updated font family
                    ),
                  ), // Settings text
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.pushNamed(
                        context, '/settings'); // Navigate to settings
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info), // Info icon
                  title: const Text(
                    'About',
                    style: TextStyle(
                      fontFamily: 'AlmoniTzarAAA', // Updated font family
                    ),
                  ), // About text
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.pushNamed(context, '/about'); // Navigate to about
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
