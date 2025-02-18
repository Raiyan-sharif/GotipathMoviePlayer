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
  bool showControls = true;
  
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
        // Show controls briefly when state changes
        showControls = true;
        _autoHideControls();
      });
    } on PlatformException catch (e) {
      debugPrint("Failed to toggle play/pause: '${e.message}'.");
    }
  }

  void _toggleControls() {
    setState(() {
      showControls = !showControls;
      if (showControls) {
        _autoHideControls();
      }
    });
  }

  void _autoHideControls() {
    if (isPlaying) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && isPlaying) {
          setState(() {
            showControls = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // Video container (this will be our native view)
            const ColoredBox(
              color: Colors.black,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
            // Controls overlay
            if (showControls)
              Container(
                color: Colors.black26,
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause_circle : Icons.play_circle,
                      color: Colors.white,
                    ),
                    iconSize: 64,
                    onPressed: _togglePlayPause,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
