import 'package:auto_size_text/auto_size_text.dart';
import 'package:coolapp/views/pages/videos/video_player.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;

import 'package:coolapp/views/pages/videos/physics_videos/curriculum_topic_filters.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/topic_widgets.dart';

class Electrostatics extends StatefulWidget {
  const Electrostatics({super.key});

  @override
  State<Electrostatics> createState() => _ElectrostaticsState();
}

class _ElectrostaticsState extends State<Electrostatics> {
  final double _width = 400;
  final double _height = 200;
  Map<int, bool> hoveredStates = {};
  final List<Map<String, dynamic>> videosList = [
    {
      'curriculumKey': 'charge',
      'title': 'Unit 1: Electric Charge',
      'description':
          'Fundamental properties of electric charge, conductors and insulators',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/Electrostatics/Unit%201%20Introduction%20to%20Electrostatics%20and%20Charges.mp4', //completed 2025/12/25
    },
    {
      'curriculumKey': 'coulomb_law',
      'title': 'Unit 2: Coulomb\'s Law',
      'description':
          'Force between electric charges and vector addition of electric forces',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/Electrostatics/Unit%202%20Coulombs%20Law.mp4', //completed 2025/12/25
    },
    {
      'curriculumKey': 'coulomb_energy',
      'title': 'Unit 3: Example - Coulomb\'s Law and Energy',
      'description':
          'Example problem focusing on how to solve energy problems using Coulomb\'s Law.',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/Electrostatics/Unit%203%20Coulombs%20Law%20and%20Energy.mp4', //completed 2025/12/25
    },
    {
      'curriculumKey': 'electric_field',
      'title': 'Unit 3: Electric Fields',
      'description':
          'Field concept, field lines, and calculating electric fields from various charge distributions, classifying strength through density of fields.',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/Electrostatics/Unit%204%20Electric%20Field%20Lines.mp4', //completed 2025/12/25
    },
    {
      'curriculumKey': 'capacitor',
      'title': 'Unit 5: Capacitance',
      'description':
          'Capacitors, dielectrics, and energy storage in electric fields',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/electricity_and_magnetism/4%20Capacitance.mp4', //completed 2025/12/25
    },
  ];
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.topicTitle = 'Electrostatics';
    final visibleVideos = CurriculumTopicFilters.filterUnits(
      courseTitle: globals.courseTitle,
      topicKey: CurriculumTopicFilters.electrostatics,
      units: videosList,
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
                    'The study of electric charges at rest, electric fields, electric potential, and their applications',
                topIcon: Icons.bolt,
              ),
              SizedBox(width: 2, height: 20),
              Column(
                children: List.generate(visibleVideos.length, (index) {
                  final video = visibleVideos[index];
                  return TopicWidgets.buildVideoButton(
                    title: video['title'] ?? '',
                    description: video['description'] ?? '',
                    index: index,
                    videoPage: video['videoPage']!,
                    videosList: visibleVideos,
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
