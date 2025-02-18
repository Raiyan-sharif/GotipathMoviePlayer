import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  static const platform = MethodChannel('video_player_channel');
  bool isPlaying = false;
  
  static const String videoUrl = 
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

  Future<void> _togglePlayPause() async {
    try {
      final bool result = await platform.invokeMethod('togglePlayPause', {
        'url': videoUrl,
        'isPlaying': isPlaying,
      });
      
      setState(() {
        isPlaying = result;
      });
    } on PlatformException catch (e) {
      debugPrint("Failed to toggle play/pause: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Native Video Player'),
            const SizedBox(height: 20),
            IconButton(
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              iconSize: 48,
              onPressed: _togglePlayPause,
            ),
          ],
        ),
      ),
    );
  }
}
