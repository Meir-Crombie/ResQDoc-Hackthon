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
        title: Text('כונן'),
        titleTextStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          fontFamily: 'David',
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 123, 0),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 255, 169, 89),
              const Color.fromARGB(255, 255, 169, 89),
              const Color.fromARGB(255, 151, 55, 0)
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
              ), // הוספת התמונה עם שינוי ג

              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 255, 169, 89),
                      const Color.fromARGB(255, 255, 169, 89),
                      const Color.fromARGB(255, 151, 55, 0)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(0),
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
                      borderRadius: BorderRadius.circular(0), // הפוך למרובע
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.mic,
                        size: 30,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10),
                      Text(isRecording ? 'הפסק הקלטה' : 'התחל הקלטה'),
                    ],
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
                            BorderRadius.circular(0), // פינות לא מעוגלות
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
                      Navigator.pushNamed(context, '/Settings');
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
