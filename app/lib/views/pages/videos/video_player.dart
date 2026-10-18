import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:beamer/beamer.dart';
import 'package:vera/widgets/timed_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vera/globals.dart' as globals;
import 'package:vera/services/auth_service.dart';
import 'package:vera/services/caption_loader.dart';
import 'package:vera/widgets/transcript_panel.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({
    super.key,
    this.topicKey = '',
    this.curriculumKey = '',
  });

  /// Identify the lesson so its caption file can be found. Empty when the
  /// player is reached without route parameters, in which case captions are
  /// simply unavailable.
  final String topicKey;
  final String curriculumKey;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _hasSavedPastVideos = false;
  bool _isSavingPastVideos = false;
  bool _hasRecordedWatch = false;
  String stackedTitle = '';
  bool _isLoading = true;
  String? _errorMessage;
  Subtitles? _captions;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Beamer.of(context).removeLastHistoryElement();
    });
  }

  void _updatePastVideos() {
    if (globals.unitTitle == '') {
      print("Error?? Blank Unit Title");
      return;
    }
    final entry = '${globals.topicTitle}, ${globals.unitTitle}';
    final updated = <String>[
      entry,
      ...globals.pastVideos.where((v) => v.isNotEmpty && v != entry),
    ].take(5).toList();
    while (updated.length < 5) {
      updated.add('');
    }
    globals.pastVideos = updated;
  }

  void _onPlaybackChanged() {
    if (_hasRecordedWatch || !_videoPlayerController.value.isPlaying) return;
    _hasRecordedWatch = true;
    _videoPlayerController.removeListener(_onPlaybackChanged);
    _updatePastVideos();
    _savePastVideos();
  }

  Future<void> _savePastVideos() async {
    if (_hasSavedPastVideos || _isSavingPastVideos) return;
    _isSavingPastVideos = true;
    try {
      final authService = AuthService();
      await authService.savePastVideos(globals.pastVideos);
      if (globals.userId.isEmpty) {
        _hasSavedPastVideos = true;
        return;
      }
      _hasSavedPastVideos = await savePastVideosToFirestore(
        globals.userId,
        globals.pastVideos,
      );
    } catch (e) {
      print('Error saving to Firestore: $e');
    } finally {
      _isSavingPastVideos = false;
    }
  }

  Future<void> _initializePlayer() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(globals.videoLink));

    // Null when this lesson has no caption file yet; Chewie then hides its
    // captions toggle instead of showing an empty one.
    _captions = await CaptionLoader.load(widget.topicKey, widget.curriculumKey);

    try {
      await _videoPlayerController.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: false,
        looping: false,
        subtitle: _captions,
        // Off by default: captions cover the diagram the instructor is drawing,
        // so let the student opt in via the toggle.
        showSubtitles: false,
        subtitleBuilder: (BuildContext context, dynamic subtitle) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            subtitle is String ? subtitle : subtitle.toString(),
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 17,
              height: 1.35,
              color: Colors.white,
            ),
          ),
        ),
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
      if (!mounted) return;
      _videoPlayerController.addListener(_onPlaybackChanged);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    if (_hasRecordedWatch && !_hasSavedPastVideos) {
      _savePastVideos();
    }
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
    final beamerDelegate = Beamer.of(context);
    return Scaffold(
      backgroundColor: globals.isLight
          ? const Color.fromARGB(255, 196, 221, 207)
          : const Color.fromARGB(255, 4, 34, 26),
      appBar: TimedAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                        beamerDelegate.beamBack();
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
                  if (kIsWeb)
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
            if (!_isLoading && _errorMessage == null)
              TranscriptPanel(
                captions: _captions,
                controller: _videoPlayerController,
                isLight: globals.isLight,
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
