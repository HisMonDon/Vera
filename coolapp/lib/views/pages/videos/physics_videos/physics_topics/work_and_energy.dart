import 'package:auto_size_text/auto_size_text.dart';
import 'package:coolapp/views/pages/videos/video_player.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/topic_widgets.dart';

class WorkAndEnergy extends StatefulWidget {
  const WorkAndEnergy({super.key});

  @override
  State<WorkAndEnergy> createState() => _WorkAndEnergyState();
}

class _WorkAndEnergyState extends State<WorkAndEnergy> {
  double _width = 400;
  double _height = 200;
  Map<int, bool> hoveredStates = {};
  final List<Map<String, dynamic>> videosList = [
    {
      'title': 'Unit 1: Work and Work-Energy Theorem',
      'description':
          'Definition of work, calculating work from forces and displacements, and applying the work-energy theorem',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/work_and_energy/Unit%201%20Work-Energy%20Theorem.mp4', //completed 2025/12/20
    },
    {
      'title': 'Unit 2: Kinetic and Potential Energy',
      'description':
          'Energy of motion, gravitational potential energy, elastic potential energy, and energy conversions',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/work_and_energy/Unit%202%20Kinetic%20and%20Potential%20Energy.mp4', //completed 2025/12/20
    },
    {
      'title': 'Unit 3: Conservation of Energy',
      'description':
          'Energy conservation principles, isolated systems, and solving problems with conservation laws',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/work_and_energy/Unit%203%20Conservation%20of%20Energy.mp4', //completed 2025/12/20
    },
    {
      'title': 'Practice: AP Physics 1 2024 Energy Problem',
      'description':
          'Use gravitational potential energy and kinetic energy to solve a practical AP exam problem.',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/work_and_energy/Unit%204%20Conservation%20of%20Energy%20Example%20AP%20Physics%201%202024%20Exam.mp4', //completed 2025/12/20
    },
    {
      'title': 'Unit 4: Power and Efficiency',
      'description':
          'Real life application of energy, efficiency calculations.',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/work_and_energy/Unit%205%20Energy%20Efficiency.mp4', //completed 2025/12/20
    },
  ];
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.topicTitle = 'Work and Energy';
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
                    'Calculate work done by forces, analyze kinetic and potential energy transformations, and apply conservation of energy to solve complex physics problems',
                topIcon: Icons.bolt_outlined,
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
