import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final player = AudioPlayer();
  final recorder = AudioRecorder();
  bool isRecording = false;
  String? filePath;
  int secondsElapsed = 0;
  Timer? timer;

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    player.dispose();
    timer?.cancel();
    super.dispose();
  }

  Future<void> startRecording() async {
    final bool isPermissionGranted = await recorder.hasPermission();
    if (!isPermissionGranted) {
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    String fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.mp3';
    filePath = '${directory.path}/$fileName';

    await recorder.start(const RecordConfig(), path: filePath!);

    setState(() {
      isRecording = true;
      secondsElapsed = 0;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        secondsElapsed++;
      });
    });
  }

  Future<void> stopRecording() async {
    await recorder.stop();
    timer?.cancel();

    try {
      final directory = await getApplicationDocumentsDirectory();
      final jsonFile = File('${directory.path}/recording_info.json');

      if (!await jsonFile.exists()) {
        await jsonFile.create(recursive: true);
      }

      final data = {'filePath': filePath, 'duration': secondsElapsed};
      await jsonFile.writeAsString(json.encode(data));
    } catch (e) {
      debugPrint('שגיאה בשמירת JSON: $e');
    }

    if (!mounted) return;
    setState(() {
      isRecording = false;
    });

    Navigator.pushNamed(
      context,
      '/paramedic',
      arguments: {"recordingName": filePath},
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 123, 0),
        title: Row(
          children: const [
            Icon(
              Icons.home,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            SizedBox(width: 10),
            Text(
              '',
              style:
                  TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 255, 207, 163),
                const Color.fromARGB(255, 255, 255, 255),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 255, 123, 0),
                      const Color.fromARGB(255, 255, 123, 0),
                    ],
                  ),
                ),
                child: const Text(
                  'תפריט',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('הגדרות'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/about');
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          width: screenWidth,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 255, 255, 255),
                const Color.fromARGB(255, 255, 191, 132)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: screenWidth * 0.4,
                        child: Image.asset('assets/svgviewer-png-output.png'),
                      ),
                    ),
                    Flexible(
                      child: SizedBox(
                        width: screenWidth * 0.4,
                        child: Image.asset('assets/logo_ichud_2.png'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.05),
                if (isRecording)
                  Text(
                    formatTime(secondsElapsed),
                    style: GoogleFonts.robotoMono(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 197, 0, 0),
                      letterSpacing: 2,
                    ),
                  ),
                SizedBox(height: screenHeight * 0.02),
                ElevatedButton(
                  onPressed: isRecording ? stopRecording : startRecording,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.15,
                      vertical: screenWidth * 0.15,
                    ),
                    backgroundColor: isRecording
                        ? const Color.fromARGB(255, 197, 0, 0)
                        : const Color.fromARGB(255, 255, 255, 255),
                    shape: CircleBorder(),
                  ),
                  child: Icon(
                    color: isRecording
                        ? const Color.fromARGB(255, 255, 255, 255)
                        : const Color.fromARGB(255, 197, 0, 0),
                    isRecording ? Icons.stop : Icons.mic,
                    size: screenWidth * 0.25,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/paramedic');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 255, 123, 0),
                        backgroundColor: Colors.white, // צבע הרקע
                        side: BorderSide(
                          color: const Color.fromARGB(
                              255, 255, 123, 0), // מסגרת כתומה
                          width: 2, // עובי המסגרת
                        ),
                        elevation: 0, // ללא צל
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30), // פינות מעוגלות
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 15),
                        textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      child: const Text('תיעוד'),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/studymode');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 255, 123, 0),
                        backgroundColor: Colors.white, // צבע הרקע
                        side: BorderSide(
                          color: const Color.fromARGB(
                              255, 255, 89, 0), // מסגרת כתומה
                          width: 2, // עובי המסגרת
                        ),
                        elevation: 0, // ללא צל
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30), // פינות מעוגלות
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 73, vertical: 15),
                        textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      child: const Text('טופס מקוצר'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
