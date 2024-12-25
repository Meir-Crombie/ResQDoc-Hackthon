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
    Navigator.pushNamed(
      context,
      '/paramedic',
      arguments: {"recordingName": filePath},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 199, 49),
      appBar: AppBar(
        title: Text('כונן'),
        titleTextStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          fontFamily: 'David',
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 123, 0),
        actions: [],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 255, 207, 163),
              const Color.fromARGB(255, 255, 255, 255),
              const Color.fromARGB(255, 255, 255, 255)
            ], // צבעי השיפוע
            begin: Alignment.topLeft, // תחילת השיפוע
            end: Alignment.bottomRight, // סוף השיפוע
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Spacer(),
              SizedBox(
                width: 300, // רוחב התמונה
                height: 250, // גובה התמונה
                child: Image.asset('assets/svgviewer-png-output.png'),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 255, 122, 122),
                      const Color.fromARGB(255, 255, 60, 0),
                      const Color.fromARGB(255, 151, 35, 0)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: ElevatedButton(
                  onPressed: isRecording ? stopRecording : startRecording,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                    backgroundColor: const Color.fromARGB(255, 255, 60, 0),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                    textStyle: TextStyle(
                        fontSize: 30,
                        fontFamily: 'David',
                        fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100), // הפוך למרובע
                    ),
                  ),
                  child: Icon(
                    isRecording ? Icons.stop : Icons.mic, // אייקון דינמי
                    size: 100,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 10),
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
                      elevation: 0, // גובה הצל
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // פינות לא מעוגלות
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 100, vertical: 15), // שוליים פנימיים
                      textStyle:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('תיעוד'),
                  ),
                ],
              ),
              SizedBox(
                width: 150, // רוחב התמונה
                height: 250, // גובה התמונה
                child: Image.asset('assets/logo_ichud_2.png'),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.settings,
                      size: 40,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.info,
                      size: 40,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/about');
                    },
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
