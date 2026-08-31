import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/views/pages/videos/physics_videos/curriculum_topic_filters.dart';
import 'package:coolapp/views/pages/videos/physics_videos/topic_registry.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/topic_widgets.dart';

//not done
class Electricity extends StatefulWidget {
  const Electricity({super.key});

  static const List<Map<String, dynamic>> videos = [
    {
      'curriculumKey': 'circuits_intro',
      'title': 'Introduction to Circuits',
      'description':
          "Ohm's law, behaviour of current, voltage, and resistance in different types of circuits.",
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/electricity_and_magnetism/1%20Introduction%20to%20Circuits.mp4', // added 2025/12/21
    },
    {
      'curriculumKey': 'kirchhoff_current',
      'title': "Kirchhoff's Current Law",
      'description':
          "Introduction to Kirchhoff's Current Law, example problems on application.",
      'videoLink':
          "https://pub-56767059a1844d06818006869a91df08.r2.dev/electricity_and_magnetism/2%20Kirchhoff's%20Current%20Law.mp4", // added 2025/12/21
    },
    {
      'curriculumKey': 'circuits_example',
      'title': "AP/IB Style Circuit Problem",
      'description':
          "Example on a combination of ohm's law, circuit behaviour, and Kirchhoff's Current law.",
      'videoLink':
          "https://pub-56767059a1844d06818006869a91df08.r2.dev/electricity_and_magnetism/3%20Circuit%20Example.mp4", // added 2025/12/21
    },
    {
      'curriculumKey': 'capacitance',
      'title': 'Capacitance',
      'description':
          'Parallel plate capacitors, energy storage, and behaviour of capaciters over time.',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/electricity_and_magnetism/4%20Capacitance.mp4', // added 2025/12/21
    },
  ];

  @override
  State<Electricity> createState() =>
      _ElectricityState();
}

class _ElectricityState extends State<Electricity> {
  /// This page's topic. All display copy is looked up from it, so the
  /// name here cannot disagree with Explore, the lesson page or the player.
  static const String _topicKey = CurriculumTopicFilters.electricity;

  final double _width = 400;
  final double _height = 200;
  Map<int, bool> hoveredStates = {};
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.topicTitle = TopicRegistry.nameOf(_topicKey);
    //print("topic title: Momentum and collisions, unit title reset");
    final visibleVideos = CurriculumTopicFilters.filterUnits(
      courseKey: globals.courseKey,
      topicKey: CurriculumTopicFilters.electricity,
      units: Electricity.videos,
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
                    topicKey: CurriculumTopicFilters.electricity,
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
