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
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Medical Documentation Saves Lives'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 187, 0),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.end, // Position buttons at the bottom
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: isRecording ? stopRecording : startRecording,
                  child: Text(isRecording ? 'Stop' : 'Record'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/paramedic');
                  },
                  child: const Text('Fill Form'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/about');
                  },
                  child: const Text('About Us'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
