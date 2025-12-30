import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class AboutThisAppPage extends StatefulWidget {
  AboutThisAppPage({super.key});

  @override
  State<AboutThisAppPage> createState() => _AboutThisAppPageState();
}

class _AboutThisAppPageState extends State<AboutThisAppPage> {
  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _sampleImagesController.dispose();
    super.dispose();
  }

  final ScrollController _sampleImagesController = ScrollController();
  Timer? _timer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TimedAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              _buildTitleHeader(context),
              const SizedBox(height: 48),
              _buildChenyuLuSection(context),
              const SizedBox(height: 48),
              _buildWhatIsVeraSection(context),
              const SizedBox(height: 48),
              _buildIntroVideoSection(context),
              const SizedBox(height: 48),
              _buildSignUpButton(),
              const SizedBox(height: 48),
              _buildBottomCopyright(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleHeader(BuildContext context) {
    return Row(
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
    );
  }

  Widget _buildChenyuLuSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 18, 59, 49),
            Color.fromARGB(214, 10, 97, 80),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(73, 0, 0, 0),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage('images/chenyuluPFP.png'),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Chenyu Lu",
                  style: GoogleFonts.mPlus1(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Founder, CEO, Lead Developer & Physics Instructor",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 195, 215, 181),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "• St. Robert Physics Club Executive Trainer\n• 3rd Place in the Canadian Young Physics Tournament\n• 5 On AP Physics 1, AP Chemistry, and AP Computer Science A",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: const Color.fromARGB(
                      255,
                      246,
                      248,
                      247,
                    ).withOpacity(0.9),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    launchUrl(Uri.parse("https://www.chenyulu.dev"));
                  },
                  icon: const Icon(Icons.web),
                  label: const Text("Visit My Website"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 167, 198, 131),
                    foregroundColor: const Color.fromARGB(255, 15, 48, 40),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatIsVeraSection(BuildContext context) {
    return Column(
      children: [
        Text(
          "What is Vera?",
          style: GoogleFonts.mPlus1(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: globals.isLight
                ? const Color.fromARGB(255, 7, 77, 53)
                : const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Vera is a video platform made with Flutter and Dart dedicated to making learning physics accessible and easy for everyone. From high school IB curricula to advanced AP topics, our study paths break concepts into short, structured lessons with clear visuals, guided examples, and real past AP exam problems so that you understand physics completely.",
          textAlign: TextAlign.center,
          style: GoogleFonts.mPlus1(
            fontSize: 20,
            color: globals.isLight
                ? const Color.fromARGB(221, 0, 0, 0)
                : const Color.fromARGB(221, 255, 255, 255),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 32),
        _buildSampleImagesRow(),
      ],
    );
  }

  void _startAutoScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
        if (!mounted || !_sampleImagesController.hasClients) {
          timer.cancel();
          return;
        }

        final double maxScrollExtent =
            _sampleImagesController.position.maxScrollExtent;
        final double currentOffset = _sampleImagesController.offset;
        const double scrollAmount = 1;

        if (currentOffset >= maxScrollExtent) {
          _sampleImagesController.jumpTo(0);
        } else {
          _sampleImagesController.jumpTo(currentOffset + scrollAmount);
        }
      });
    });
  }

  final List<String> displayPaths = [
    'images_tutorial/display1.png',
    'images_tutorial/display2.png',
    'images_tutorial/display3.png',
    'images_tutorial/display6.png',
    'images_tutorial/display4.png',
    'images_tutorial/display5.png',
    'images_tutorial/display7.png',
  ];

  Widget _buildSampleImagesRow() {
    return SingleChildScrollView(
      controller: _sampleImagesController,
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(displayPaths.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                width: 600,
                height: 300,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 18, 59, 49),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                    image: DecorationImage(
                        image: AssetImage(displayPaths[index]),
                        fit: BoxFit.cover)),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildIntroVideoSection(BuildContext context) {
    return Column(
      children: [
        Text(
          "Intro to Vera",
          style: GoogleFonts.mPlus1(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: globals.isLight
                ? const Color.fromARGB(255, 7, 77, 53)
                : Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 400,
            color: Colors.black,
            child: _IntroVideoPlayer(),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: () {
        Beamer.of(context, root: true).beamToNamed('/profile');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 167, 198, 131),
        foregroundColor: const Color.fromARGB(255, 15, 48, 40),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        "Click Here to Sign Up Now",
        style: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBottomCopyright() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "2025 Chenyu Studios",
          style: TextStyle(
            fontSize: 10,
            color: globals.isLight
                ? const Color.fromARGB(255, 0, 0, 0)
                : const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        const SizedBox(width: 3),
        Icon(
          Icons.copyright_sharp,
          size: 15,
          color: globals.isLight
              ? const Color.fromARGB(255, 0, 0, 0)
              : const Color.fromARGB(255, 255, 255, 255),
        ),
      ],
    );
  }
}

class _IntroVideoPlayer extends StatefulWidget {
  // @override
  _IntroVideoPlayerState createState() => _IntroVideoPlayerState();
}

class _IntroVideoPlayerState extends State<_IntroVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  String? _errorMessage;
  bool _hasVideoController = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future _initializePlayer() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _chewieController?.dispose();
    _chewieController = null;

    if (_hasVideoController) {
      await _videoPlayerController.dispose();
      _hasVideoController = false;
    }

    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
        'https://pub-56767059a1844d06818006869a91df08.r2.dev/Vera%20Introduction.mp4'));
    _hasVideoController = true;

    _videoPlayerController.addListener(() {
      if (mounted) setState(() {});
    });

    try {
      //'images_tutorial/display1.png',
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: false,
        looping: false,
        aspectRatio: 16 / 9,
        // allowedScreenSleep: false,
        playbackSpeeds: [0.5, 1.0, 1.5, 2.0, 2.5],
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color.fromARGB(255, 167, 198, 131),
          handleColor: const Color.fromARGB(255, 195, 226, 172),
          backgroundColor: const Color.fromARGB(255, 5, 85, 58),
          bufferedColor: const Color.fromARGB(255, 5, 85, 58),
        ),
        placeholder: Image.asset(
          'images_tutorial/vera_intro_thumbnail.png',
        ),
        // placeholder: Container(
        //   color: Colors.grey,
        // ),
        autoInitialize: true,
      );
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
  Widget build(BuildContext context) {
    return _buildPlayer();
  }

  Widget _buildPlayer() {
    if (_isLoading) {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: ColoredBox(
          color: Colors.black,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_errorMessage != null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(color: Colors.black, child: _buildErrorDisplay()),
      );
    }

    if (_chewieController == null) {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: ColoredBox(
          color: Colors.black,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final isInit = _videoPlayerController.value.isInitialized;
    final aspect = isInit ? _videoPlayerController.value.aspectRatio : (16 / 9);

    return AspectRatio(
      aspectRatio: aspect,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Chewie(controller: _chewieController!),
          if (!isInit)
            Image.asset(
              'images_tutorial/vera_intro_thumbnail.png',
              fit: BoxFit.cover,
            ),
        ],
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

  @override
  void dispose() {
    if (_hasVideoController) {
      _videoPlayerController.dispose();
    }
    _chewieController?.dispose();
    super.dispose();
  }
}
