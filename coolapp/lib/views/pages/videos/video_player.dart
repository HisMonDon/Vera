import 'package:auto_size_text/auto_size_text.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/services/auth_service.dart';

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
  String stackedTitle =
      ''; //github format where u use / to seperate folders or tabs
  bool _hasSavedPastVideos = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _updatePastVideos(); // Update videos list when screen loads
  }

  //__________________________________________________________________
  //update past videos logic - moved to separate method
  void _updatePastVideos() {
    int dupeIndex = -1;
    bool isDuped = false;
    if (globals.unitTitle == '') {
      print("Error?? Blank Unit Title");
      return; //error handeling
    }
    for (int x = 0; x < 5; x++) {
      if (globals.pastVideos[x] ==
          globals.topicTitle + ', ' + globals.unitTitle) {
        //we remove and put it at most recent.
        isDuped = true;
        dupeIndex = x;
        break;
      }
    }
    if (isDuped) {
      for (int x = dupeIndex; x > 0; x--) {
        globals.pastVideos[x] = globals.pastVideos[x - 1];
      }
      globals.pastVideos[0] = globals.topicTitle + ", " + globals.unitTitle;
      return;
    }
    for (int x = 0; x < 5; x++) {
      if (globals.pastVideos[x] == '') {
        //if we still have empty space
        globals.pastVideos[x] = globals.topicTitle + ', ' + globals.unitTitle;
        return;
      }
    }
    for (int x = 4; x > 0; x--) {
      //pushes last one out, and puts most recent one
      globals.pastVideos[x] = globals.pastVideos[x - 1];
    }
    globals.pastVideos[0] = globals.topicTitle + ", " + globals.unitTitle;
  }
  //__________________________________________________________________

  Future<void> _savePastVideos() async {
    if (_hasSavedPastVideos) return;

    // save to SharedPreferences
    final authService = AuthService();
    await authService.savePastVideos(globals.pastVideos);

    // save to firestore if logged in
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
    // liisten to player state changes
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
      await player.open(Media(globals.videoLink));
      // Save after player is initialized
      WidgetsBinding.instance.addPostFrameCallback((_) => _savePastVideos());
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (globals.courseTitle != '') {
      //that means that we have all
      stackedTitle =
          globals.courseTitle +
          ', ' +
          globals.topicTitle +
          ', ' +
          globals.unitTitle;
    } else if (globals.topicTitle != '') {
      //put this because I might implement video of the day later on
      stackedTitle = globals.topicTitle + ', ' + globals.unitTitle;
    } else {
      stackedTitle = globals.unitTitle;
    }

    return Scaffold(
      appBar: TimedAppBar(), //add text here
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15),
            AutoSizeText(
              stackedTitle,
              style: GoogleFonts.mPlus1(
                fontSize: 15,
                color: const Color.fromARGB(255, 255, 255, 255),
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: hasError
                  ? _buildErrorDisplay()
                  : Container(
                      width: MediaQuery.of(context).size.width - 400,
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          color: Colors.black,
                          child: hasError
                              ? _buildErrorDisplay()
                              : Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Video(controller: controller),
                                    if (isBuffering)
                                      const CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                  ],
                                ),
                        ),
                      ),
                    ),
            ),

            if (globals.nextVideoTitle != 'last_one')
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Next video: ${globals.nextVideoTitle}",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
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
        Text('Failed to load video: $errorMessage'),
        Text('\nPlease check your internet connection'),
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
}
