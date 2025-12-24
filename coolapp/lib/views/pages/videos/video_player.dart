import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/services/auth_service.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _hasSavedPastVideos = false;
  String stackedTitle = '';
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _updatePastVideos();
  }

  void _updatePastVideos() {
    int dupeIndex = -1;
    bool isDuped = false;
    if (globals.unitTitle == '') {
      print("Error?? Blank Unit Title");
      return;
    }
    for (int x = 0; x < 5; x++) {
      if (globals.pastVideos[x] ==
          '${globals.topicTitle}, ${globals.unitTitle}') {
        isDuped = true;
        dupeIndex = x;
        break;
      }
    }
    if (isDuped) {
      for (int x = dupeIndex; x > 0; x--) {
        globals.pastVideos[x] = globals.pastVideos[x - 1];
      }
      globals.pastVideos[0] = "${globals.topicTitle}, ${globals.unitTitle}";
      return;
    }
    for (int x = 0; x < 5; x++) {
      if (globals.pastVideos[x] == '') {
        globals.pastVideos[x] = '${globals.topicTitle}, ${globals.unitTitle}';
        return;
      }
    }
    for (int x = 4; x > 0; x--) {
      globals.pastVideos[x] = globals.pastVideos[x - 1];
    }
    globals.pastVideos[0] = "${globals.topicTitle}, ${globals.unitTitle}";
  }

  Future<void> _savePastVideos() async {
    if (_hasSavedPastVideos) return;
    final authService = AuthService();
    await authService.savePastVideos(globals.pastVideos);
    if (globals.userId.isNotEmpty && globals.idToken.isNotEmpty) {
      try {
        await savePastVideosToFirestore(
          globals.userId,
          globals.pastVideos,
          globals.idToken,
        );
      } catch (e) {
        print('Error saving to Firestore: $e');
      }
    }
    _hasSavedPastVideos = true;
  }

  Future<void> _initializePlayer() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(globals.videoLink));

    try {
      await _videoPlayerController.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: false,
        looping: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        playbackSpeeds: const [0.5, 1.0, 1.5, 2.0, 2.5],
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color.fromARGB(255, 167, 198, 131),
          handleColor: const Color.fromARGB(255, 195, 226, 172),
          backgroundColor: const Color.fromARGB(255, 5, 85, 58),
          bufferedColor: const Color.fromARGB(255, 5, 85, 58),
        ),
        autoInitialize: true,
      );
      setState(() {
        _isLoading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _savePastVideos());
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (globals.courseTitle != '') {
      stackedTitle =
          '${globals.courseTitle}, ${globals.topicTitle}, ${globals.unitTitle}';
    } else if (globals.topicTitle != '') {
      stackedTitle = '${globals.topicTitle}, ${globals.unitTitle}';
    } else {
      stackedTitle = globals.unitTitle;
    }

    return Scaffold(
      backgroundColor: globals.isLight
          ? const Color.fromARGB(255, 196, 221, 207)
          : const Color.fromARGB(255, 4, 34, 26),
      appBar: TimedAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (kIsWeb)
              Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Back'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            15,
                            48,
                            40,
                          ),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'Vera',
                          style: GoogleFonts.mPlus1(
                            fontSize: 48.0,
                            fontWeight: FontWeight.bold,
                            color: globals.isLight
                                ? const Color.fromARGB(255, 15, 48, 40)
                                : Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: globals.isLight
                                ? const Color.fromARGB(255, 15, 48, 40)
                                : const Color.fromARGB(255, 167, 198, 131),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Web',
                            style: GoogleFonts.montserrat(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: globals.isLight
                                  ? Colors.white
                                  : const Color.fromARGB(255, 15, 48, 40),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 19),
            AutoSizeText(
              stackedTitle,
              style: GoogleFonts.mPlus1(
                fontSize: 20,
                color: globals.isLight
                    ? const Color.fromARGB(255, 15, 48, 40)
                    : Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 400,
                color: Colors.black,
                child: _buildPlayer(),
              ),
            ),
            if (globals.nextVideoTitle != 'last_one')
              Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Next video: ${globals.nextVideoTitle}",
                        style: TextStyle(
                          fontSize: 20,
                          color: globals.isLight
                              ? const Color.fromARGB(255, 15, 48, 40)
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayer() {
    if (_isLoading) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.black,
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }
    if (_errorMessage != null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.black,
          child: _buildErrorDisplay(),
        ),
      );
    }
    if (_chewieController != null &&
        _chewieController!.videoPlayerController.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _videoPlayerController.value.aspectRatio,
        child: Chewie(controller: _chewieController!),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorDisplay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.error_outline,
          color: Color.fromARGB(255, 2, 110, 74),
          size: 48,
        ),
        const SizedBox(height: 16),
        Text(
          'Failed to load video: $_errorMessage',
          style: const TextStyle(color: Colors.white),
        ),
        const Text(
          '\nPlease check your internet connection',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _initializePlayer,
          child: const Text('Retry'),
        ),
      ],
    );
  }
}
