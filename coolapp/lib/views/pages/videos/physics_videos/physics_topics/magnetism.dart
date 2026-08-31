import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/views/pages/videos/physics_videos/curriculum_topic_filters.dart';
import 'package:coolapp/views/pages/videos/physics_videos/topic_registry.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/topic_widgets.dart';

//not done
class Magnetism extends StatefulWidget {
  const Magnetism({super.key});

  static const List<Map<String, dynamic>> videos = [
    {
      'curriculumKey': 'rhr',
      'title': 'Right Hand Rule',
      'description':
          'Introduction on how to use the right hand rule, applications.',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/electricity_and_magnetism/5%20Right%20hand%20rule.mp4', // added 2025/12/21
    },
    {
      'curriculumKey': 'magnetic_flux',
      'title': 'Magnetic Flux (IB/AP)',
      'description':
          "Introduction to magnetic flux, effect of angles, applications",
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/electricity_and_magnetism/IBAP%20Introduction%20to%20Magnetic%20Flux.mp4', // added 2025/12/21
    },
  ];

  @override
  State<Magnetism> createState() =>
      _MagnetismState();
}

class _MagnetismState extends State<Magnetism> {
  /// This page's topic. All display copy is looked up from it, so the
  /// name here cannot disagree with Explore, the lesson page or the player.
  static const String _topicKey = CurriculumTopicFilters.magnetism;

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
      topicKey: CurriculumTopicFilters.magnetism,
      units: Magnetism.videos,
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
                    topicKey: CurriculumTopicFilters.magnetism,
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
