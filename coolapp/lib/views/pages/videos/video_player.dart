import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final Player player = Player();
  late final VideoController controller = VideoController(player);
  bool isPlaying = false;
  bool isBuffering = true;
  bool hasError = false;
  String errorMessage = '';
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  double volume = 1.0;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    // Listen to player state changes
    player.stream.playing.listen((playing) {
      setState(() {
        isPlaying = playing;
      });
    });

    player.stream.buffering.listen((buffering) {
      setState(() {
        isBuffering = buffering;
      });
    });

    player.stream.position.listen((pos) {
      setState(() {
        position = pos;
      });
    });

    player.stream.duration.listen((dur) {
      setState(() {
        duration = dur;
      });
    });

    player.stream.volume.listen((vol) {
      setState(() {
        volume = vol;
      });
    });

    player.stream.error.listen((error) {
      setState(() {
        hasError = true;
        errorMessage = error;
      });
    });

    try {
      await player.open(
        Media(
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
        ),
      );
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = e.toString();
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0
        ? '$hours:$minutes:$seconds'
        : '$minutes:$seconds';
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('skibidi')), //add text here
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: hasError
                  ? _buildErrorDisplay()
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        Video(controller: controller),
                        if (isBuffering)
                          const CircularProgressIndicator(color: Colors.white),
                      ],
                    ),
            ),
          ),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildErrorDisplay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 48),
        const SizedBox(height: 16),
        Text('Failed to load video: $errorMessage'),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            setState(() {
              hasError = false;
              errorMessage = '';
            });
            _initializePlayer();
          },
          child: const Text('Retry'),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.black12,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // progress slider

          // Time indicators and controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(position),
                style: const TextStyle(color: Colors.black87),
              ),

              Text(
                _formatDuration(duration),
                style: const TextStyle(color: Colors.black87),
              ),
            ],
          ),

          // Volume control
        ],
      ),
    );
  }
}
