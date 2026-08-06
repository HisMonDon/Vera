import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/views/pages/videos/physics_videos/curriculum_topic_filters.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/topic_widgets.dart';

class Harmonics extends StatefulWidget {
  const Harmonics({super.key});

  static const List<Map<String, dynamic>> videos = [
    {
      'curriculumKey': 'pendulum',
      'title': 'Pendulums',
      'description':
          'Introduction to pendulum motion, period, frequency, and the small-angle model.',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/oscillations/Unit%201%20Pendulums.mp4', //completed 2025/12/23
    },
    {
      'curriculumKey': 'springs_hookes',
      'title': 'Springs and Hookes Law',
      'description':
          'Hooke’s law, spring force graphs, and how spring constant affects motion.',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/oscillations/Unit%202%20Springs%20and%20Hookes%20Law.mp4', //completed 2025/12/23
    },
    {
      'curriculumKey': 'springs_energy',
      'title': 'Springs and Conservation of Energy',
      'description':
          'Energy methods for mass–spring systems: PE in springs, KE, and total energy.',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/oscillations/Unit%203%20Springs%20and%20Conservation%20of%20Energy.mp4', //completed 2025/12/23
    },
    {
      'curriculumKey': 'harmonics_ap_momentum',
      'title': 'Springs and Momentum - Past AP Physics 1 Example',
      'description':
          'AP-style problem: collisions with springs using momentum and energy ideas.',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/oscillations/Unit%204%20Springs%20and%20Momentum%20-%20Past%20AP%20Physics%201%20Example.mp4', //completed 2025/12/23
    },
    {
      'curriculumKey': 'harmonics_ap_work',
      'title': 'Pendulums and Work - Past AP Physics 1 Example',
      'description':
          'AP-style problem: using work/energy to analyze pendulum speed and height.',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/oscillations/Unit%205%20Pendulums%20and%20Work%20-%20Past%20AP%20Physics%201%20Examplar.mp4', //completed 2025/12/23
    },
  ];

  @override
  State<Harmonics> createState() => _HarmonicsState();
}

class _HarmonicsState extends State<Harmonics> {
  final double _width = 400;
  final double _height = 200;
  Map<int, bool> hoveredStates = {};
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.topicTitle = 'Harmonics';
    final visibleVideos = CurriculumTopicFilters.filterUnits(
      courseTitle: globals.courseTitle,
      topicKey: CurriculumTopicFilters.harmonics,
      units: Harmonics.videos,
    );
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
                children: List.generate(visibleVideos.length, (index) {
                  final video = visibleVideos[index];
                  return TopicWidgets.buildVideoButton(
                    title: video['title'] ?? '',
                    description: video['description'] ?? '',
                    index: index,
                    topicKey: CurriculumTopicFilters.harmonics,
                    videosList: visibleVideos,
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
