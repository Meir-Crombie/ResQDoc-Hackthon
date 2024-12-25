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
  final player =
      AudioPlayer(); // Audio player instance for playback functionality
  final recorder =
      AudioRecorder(); // Audio recorder instance for recording functionality
  bool isRecording = false; // Boolean flag to track recording status
  String? filePath; // File path for the recorded audio
  int secondsElapsed = 0; // Counter for elapsed time during recording
  Timer? timer; // Timer to update elapsed time

  // Function to format elapsed time into "MM:SS" format
  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    player
        .dispose(); // Dispose of the audio player when the widget is destroyed
    timer?.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  // Function to start recording audio
  Future<void> startRecording() async {
    final bool isPermissionGranted =
        await recorder.hasPermission(); // Check for recording permissions
    if (!isPermissionGranted) {
      return; // Exit if permissions are not granted
    }

    final directory =
        await getApplicationDocumentsDirectory(); // Get app's documents directory
    String fileName =
        'recording_${DateTime.now().millisecondsSinceEpoch}.mp3'; // Generate unique file name
    filePath =
        '${directory.path}/$fileName'; // Combine directory path and file name

    await recorder.start(const RecordConfig(),
        path: filePath!); // Start recording with specified config

    setState(() {
      isRecording = true; // Update recording status
      secondsElapsed = 0; // Reset elapsed time
    });

    // Start a timer to update the elapsed time every second
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        secondsElapsed++;
      });
    });
  }

  // Function to stop recording audio
  Future<void> stopRecording() async {
    await recorder.stop(); // Stop the recording
    timer?.cancel(); // Stop the timer

    try {
      final directory =
          await getApplicationDocumentsDirectory(); // Get app's documents directory
      final jsonFile = File(
          '${directory.path}/recording_info.json'); // Define JSON file to save recording info

      if (!await jsonFile.exists()) {
        await jsonFile.create(
            recursive: true); // Create the JSON file if it doesn't exist
      }

      // Save recording details (file path and duration) in the JSON file
      final data = {'filePath': filePath, 'duration': secondsElapsed};
      await jsonFile.writeAsString(json.encode(data));
    } catch (e) {
      debugPrint('Error saving JSON: $e'); // Log error if saving fails
    }

    if (!mounted) return; // Check if the widget is still mounted
    setState(() {
      isRecording = false; // Update recording status
    });

    // Navigate to the paramedic screen with the recorded file's name as an argument
    Navigator.pushNamed(
      context,
      '/paramedic',
      arguments: {"recordingName": filePath},
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width
    final screenHeight =
        MediaQuery.of(context).size.height; // Get screen height

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 255, 123, 0), // App bar background color
        title: Row(
          children: const [
            Icon(
              Icons.home, // Home icon
              color: Color.fromARGB(255, 0, 0, 0), // Icon color
            ),
            SizedBox(width: 10), // Spacing between icon and title
            Text(
              '',
              style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20), // Title text style
            ),
          ],
        ),
        automaticallyImplyLeading: false, // Disable default back button
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu, // Menu icon
                  color: Color.fromARGB(255, 0, 0, 0), // Icon color
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer(); // Open end drawer
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
                const Color.fromARGB(
                    255, 255, 207, 163), // Gradient start color
                const Color.fromARGB(255, 255, 255, 255), // Gradient end color
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
                      const Color.fromARGB(
                          255, 255, 123, 0), // Gradient color for header
                      const Color.fromARGB(255, 255, 123, 0),
                    ],
                  ),
                ),
                child: const Text(
                  'תפריט', // Menu title
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0), // Text color
                    fontSize: 24, // Font size
                    fontWeight: FontWeight.bold, // Bold font
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings), // Settings icon
                title: const Text('הגדרות'), // Settings text
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.pushNamed(
                      context, '/settings'); // Navigate to settings
                },
              ),
              ListTile(
                leading: const Icon(Icons.info), // Info icon
                title: const Text('About'), // About text
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.pushNamed(context, '/about'); // Navigate to about
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent, // Transparent background
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight, // Full screen height
          width: screenWidth, // Full screen width
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(
                    255, 255, 255, 255), // Gradient start color
                const Color.fromARGB(255, 255, 191, 132), // Gradient end color
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Align content at the top
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center horizontally
              children: <Widget>[
                SizedBox(
                  height: screenHeight * 0.05, // Vertical spacing
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceEvenly, // Even spacing between images
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: screenWidth * 0.4, // Set image width
                        child: Image.asset(
                            'assets/svgviewer-png-output.png'), // First image
                      ),
                    ),
                    Flexible(
                      child: SizedBox(
                        width: screenWidth * 0.4, // Set image width
                        child: Image.asset(
                            'assets/logo_ichud_2.png'), // Second image
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.05), // Vertical spacing
                if (isRecording)
                  Text(
                    formatTime(secondsElapsed), // Display elapsed time
                    style: GoogleFonts.robotoMono(
                      fontSize: screenWidth * 0.07, // Text size
                      fontWeight: FontWeight.bold, // Bold text
                      color: const Color.fromARGB(255, 197, 0, 0), // Text color
                      letterSpacing: 2, // Letter spacing
                    ),
                  ),
                SizedBox(height: screenHeight * 0.02), // Vertical spacing
                ElevatedButton(
                  onPressed: isRecording
                      ? stopRecording
                      : startRecording, // Toggle recording
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.15, // Horizontal padding
                      vertical: screenWidth * 0.15, // Vertical padding
                    ),
                    backgroundColor: isRecording
                        ? const Color.fromARGB(
                            255, 197, 0, 0) // Stop button color
                        : const Color.fromARGB(
                            255, 255, 255, 255), // Record button color
                    shape: CircleBorder(), // Circular button shape
                  ),
                  child: Icon(
                    color: isRecording
                        ? const Color.fromARGB(
                            255, 255, 255, 255) // Stop icon color
                        : const Color.fromARGB(
                            255, 197, 0, 0), // Record icon color
                    isRecording ? Icons.stop : Icons.mic, // Toggle icon
                    size: screenWidth * 0.25, // Icon size
                  ),
                ),
                SizedBox(height: screenHeight * 0.05), // Vertical spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceEvenly, // Even spacing between buttons
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context,
                            '/paramedic'); // Navigate to paramedic screen
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color.fromARGB(
                            255, 255, 123, 0), // Text color
                        backgroundColor: Colors.white, // Background color
                        side: BorderSide(
                          color: const Color.fromARGB(
                              255, 255, 123, 0), // Border color
                          width: 2, // Border width
                        ),
                        elevation: 0, // No shadow
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30), // Rounded corners
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 15), // Button padding
                        textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black), // Text style
                      ),
                      child: const Text('תיעוד'), // Button label
                    ),
                  ],
                ),
                const SizedBox(height: 40), // Vertical spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceEvenly, // Even spacing between buttons
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context,
                            '/studymode'); // Navigate to study mode screen
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color.fromARGB(
                            255, 255, 123, 0), // Text color
                        backgroundColor: Colors.white, // Background color
                        side: BorderSide(
                          color: const Color.fromARGB(
                              255, 255, 123, 0), // Border color
                          width: 2, // Border width
                        ),
                        elevation: 0, // No shadow
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30), // Rounded corners
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 73, vertical: 15), // Button padding
                        textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black), // Text style
                      ),
                      child: const Text('טופס מקוצר'), // Button label
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
