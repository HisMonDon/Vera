import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;

import 'package:coolapp/views/pages/videos/physics_videos/curriculum_topic_filters.dart';
import 'package:coolapp/views/pages/videos/physics_videos/topic_registry.dart';

import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/topic_widgets.dart';

class Electrostatics extends StatefulWidget {
  const Electrostatics({super.key});

  static const List<Map<String, dynamic>> videos = [
    {
      'curriculumKey': 'charge',
      'title': 'Electric Charge',
      'description':
          'Fundamental properties of electric charge, conductors and insulators',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/Electrostatics/Unit%201%20Introduction%20to%20Electrostatics%20and%20Charges.mp4', //completed 2025/12/25
    },
    {
      'curriculumKey': 'coulomb_law',
      'title': 'Coulomb\'s Law',
      'description':
          'Force between electric charges and vector addition of electric forces',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/Electrostatics/Unit%202%20Coulombs%20Law.mp4', //completed 2025/12/25
    },
    {
      'curriculumKey': 'coulomb_energy',
      'title': 'Example - Coulomb\'s Law and Energy',
      'description':
          'Example problem focusing on how to solve energy problems using Coulomb\'s Law.',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/Electrostatics/Unit%203%20Coulombs%20Law%20and%20Energy.mp4', //completed 2025/12/25
    },
    {
      'curriculumKey': 'electric_field',
      'title': 'Electric Fields',
      'description':
          'Field concept, field lines, and calculating electric fields from various charge distributions, classifying strength through density of fields.',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/Electrostatics/Unit%204%20Electric%20Field%20Lines.mp4', //completed 2025/12/25
    },
    {
      'curriculumKey': 'capacitor',
      'title': 'Capacitance',
      'description':
          'Capacitors, dielectrics, and energy storage in electric fields',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/electricity_and_magnetism/4%20Capacitance.mp4', //completed 2025/12/25
    },
  ];

  @override
  State<Electrostatics> createState() => _ElectrostaticsState();
}

class _ElectrostaticsState extends State<Electrostatics> {
  /// This page's topic. All display copy is looked up from it, so the
  /// name here cannot disagree with Explore, the lesson page or the player.
  static const String _topicKey = CurriculumTopicFilters.electrostatics;

  final double _width = 400;
  final double _height = 200;
  Map<int, bool> hoveredStates = {};
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.topicTitle = TopicRegistry.nameOf(_topicKey);
    final visibleVideos = CurriculumTopicFilters.filterUnits(
      courseKey: globals.courseKey,
      topicKey: CurriculumTopicFilters.electrostatics,
      units: Electrostatics.videos,
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
                title: TopicRegistry.nameOf(_topicKey),
                context: context,
                description: TopicRegistry.descriptionOf(_topicKey),
                topIcon: TopicRegistry.byKey(_topicKey)!.icon,
              ),
              SizedBox(width: 2, height: 20),
              Column(
                children: List.generate(visibleVideos.length, (index) {
                  final video = visibleVideos[index];
                  return TopicWidgets.buildVideoButton(
                    title: video['title'] ?? '',
                    description: video['description'] ?? '',
                    index: index,
                    topicKey: CurriculumTopicFilters.electrostatics,
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
