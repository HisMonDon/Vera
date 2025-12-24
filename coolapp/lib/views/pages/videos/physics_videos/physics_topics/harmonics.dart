import 'package:auto_size_text/auto_size_text.dart';
import 'package:coolapp/views/pages/videos/video_player.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/topic_widgets.dart';

class Harmonics extends StatefulWidget {
  const Harmonics({super.key});

  @override
  State<Harmonics> createState() => _HarmonicsState();
}

class _HarmonicsState extends State<Harmonics> {
  double _width = 400;
  double _height = 200;
  Map<int, bool> hoveredStates = {};
  final List<Map<String, dynamic>> videosList = [
    {
      'title': 'Unit 1: Pendulums',
      'description':
          'Introduction to pendulum motion, period, frequency, and the small-angle model.',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/oscillations/Unit%201%20Pendulums.mp4', //completed 2025/12/23
    },
    {
      'title': 'Unit 2: Springs and Hookes law',
      'description':
          'Hooke’s law, spring force graphs, and how spring constant affects motion.',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/oscillations/Unit%202%20Springs%20and%20Hookes%20Law.mp4', //completed 2025/12/23
    },
    {
      'title': 'Unit 3: Springs and Conservation of Energy',
      'description':
          'Energy methods for mass–spring systems: PE in springs, KE, and total energy.',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/oscillations/Unit%203%20Springs%20and%20Conservation%20of%20Energy.mp4', //completed 2025/12/23
    },
    {
      'title': 'Unit 4: Springs and Momentum - Past AP Physics 1 Example',
      'description':
          'AP-style problem: collisions with springs using momentum and energy ideas.',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/oscillations/Unit%204%20Springs%20and%20Momentum%20-%20Past%20AP%20Physics%201%20Example.mp4', //completed 2025/12/23
    },
    {
      'title': 'Unit 5: Pendulums and Work - Past AP Physics 1 Example',
      'description':
          'AP-style problem: using work/energy to analyze pendulum speed and height.',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/oscillations/Unit%205%20Pendulums%20and%20Work%20-%20Past%20AP%20Physics%201%20Examplar.mp4', //completed 2025/12/23
    },
  ];
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.topicTitle = 'Harmonics';
    return Scaffold(
      appBar: TimedAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(width: 2, height: 10),
              TopicWidgets.buildTopLayout(
                title: globals.topicTitle,
                context: context,
                description:
                    'The study of periodic motion, vibrations, and oscillations in systems with restoring forces',
                topIcon: Icons.waves,
              ),
              SizedBox(width: 2, height: 20),
              Column(
                children: List.generate(videosList.length, (index) {
                  final video = videosList[index];
                  return TopicWidgets.buildVideoButton(
                    title: video['title'] ?? '',
                    description: video['description'] ?? '',
                    index: index,
                    videoPage: video['videoPage']!,
                    videosList: videosList,
                    videoLink: video['videoLink'],
                    context: context,
                    hoveredStates: hoveredStates,
                    onHoverChanged: (index, isHovered) {
                      setState(() {
                        hoveredStates[index] = isHovered;
                      });
                    },
                  );
                }),
              ),
              TopicWidgets.buildBackButton(context: context),
            ],
          ),
        ),
      ),
    );
  }
}
