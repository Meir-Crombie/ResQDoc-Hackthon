import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

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

  @override
  void dispose() {
    player.dispose();
    recorder.dispose();
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

    const config = RecordConfig(
      encoder: AudioEncoder.aacLc,
      sampleRate: 44100,
      bitRate: 128000,
    );

    await recorder.start(config, path: filePath!);
    setState(() {
      isRecording = true;
    });
  }

  Future<void> stopRecording() async {
    await recorder.stop();
    if (!mounted) return;
    setState(() {
      isRecording = false;
    });
    // Navigate to the paramedic documentation page after stopping the recording
    Navigator.pushNamed(context, '/paramedic');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 199, 49),
      appBar: AppBar(
        title: Text('תיעוד כונן'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 123, 0),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Add your settings page navigation here
              Navigator.pushNamed(context, '/Settings');
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 255, 255, 255),
              const Color.fromARGB(255, 255, 243, 133),
              const Color.fromARGB(255, 255, 145, 0)
            ], // צבעי השיפוע
            begin: Alignment.topLeft, // תחילת השיפוע
            end: Alignment.bottomRight, // סוף השיפוע
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: isRecording ? stopRecording : startRecording,
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                  backgroundColor: const Color.fromARGB(255, 255, 17, 0),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                  textStyle:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                child: Text(isRecording ? 'הפסק הקלטה' : 'התחל הקלטה'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/paramedic');
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          const Color.fromARGB(255, 0, 0, 0), // צבע הטקסט
                      backgroundColor:
                          const Color.fromARGB(255, 255, 89, 0), // צבע הרקע
                      elevation: 10, // גובה הצל
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(0), // פינות לא מעוגלות
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20), // שוליים פנימיים
                      textStyle:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('תיעוד'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/about');
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      backgroundColor: const Color.fromARGB(
                          255, 255, 89, 0), // צבע טקסט הכפתור
                      elevation: 10, // גובה הצל
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0), // פינות מעוגלות
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20), // שוליים פנימיים
                      textStyle:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('עלינו'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
