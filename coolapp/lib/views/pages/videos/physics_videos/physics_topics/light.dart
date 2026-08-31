import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/views/pages/videos/physics_videos/curriculum_topic_filters.dart';
import 'package:coolapp/views/pages/videos/physics_videos/topic_registry.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/topic_widgets.dart';

class Light extends StatefulWidget {
  const Light({super.key});

  static const List<Map<String, dynamic>> videos = [
    {
      'curriculumKey': 'light_intro',
      'title': 'Introduction to Light',
      'description':
          'Light as electromagnetic waves, properties of light, and the electromagnetic spectrum',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/optics/Unit%201%20Introducution%20to%20Light.mp4', //completed 12/25/2025 merry christmas!
    },
    {
      'curriculumKey': 'light_refraction',
      'title': 'Total Internal Refraction',
      'description':
          "Snell's law, Critical angle, introduction to total internal refraction and it's applications.",
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/optics/Unit%204%20Total%20Internal%20Reflection.mp4', //completed 12/25/2025
    },
    {
      'curriculumKey': 'light_interference',
      'title': "Young's Double Slit Experiment",
      'description':
          'Formulae and causes for the interference of light through a double slit, introduction to wave-particle duality.',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/optics/Unit%205%20Double%20Slit%20Experiment.mp4', //completed 12/25/2025
    },
  ];

  @override
  State<Light> createState() => _LightState();
}

class _LightState extends State<Light> {
  /// This page's topic. All display copy is looked up from it, so the
  /// name here cannot disagree with Explore, the lesson page or the player.
  static const String _topicKey = CurriculumTopicFilters.light;

  final double _width = 400;
  final double _height = 200;
  Map<int, bool> hoveredStates = {};
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.topicTitle = TopicRegistry.nameOf(_topicKey);
    final visibleVideos = CurriculumTopicFilters.filterUnits(
      courseKey: globals.courseKey,
      topicKey: CurriculumTopicFilters.light,
      units: Light.videos,
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
                    topicKey: CurriculumTopicFilters.light,
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
