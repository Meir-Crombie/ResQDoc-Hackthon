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
  double currentPosition = 0;
  double totalDuration = 0;
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
    // Generate a unique file name using the current timestamp
    String fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
    filePath = '${directory.path}/$fileName';

    // Define the configuration for the recording
    const config = RecordConfig(
      // Specify the format, encoder, sample rate, etc., as needed
      encoder: AudioEncoder.aacLc, // For example, using AAC codec
      sampleRate: 44100, // Sample rate
      bitRate: 128000, // Bit rate
    );

    // Start recording to file with the specified configuration
    await recorder.start(config, path: filePath!);
    setState(() {
      isRecording = true;
    });
  }

  Future<void> stopRecording() async {
    final path = await recorder.stop();
    setState(() {
      isRecording = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text('איחוד הצלה - תיעוד כונן'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 255, 187, 0),
        ),
        body: SafeArea(
            child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isRecording
                  ? ElevatedButton(
                      onPressed: stopRecording,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                      ),
                      child: const Text('Stop'),
                    )
                  : ElevatedButton(
                      onPressed: startRecording,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                      ),
                      child: const Text('Record'),
                    ),
            ],
          ),
          Center(
            child: TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/paramedic');
              },
              icon: Icon(Icons.info),
              label: Text(
                'תיעוד כונן',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ])));
  }
}
