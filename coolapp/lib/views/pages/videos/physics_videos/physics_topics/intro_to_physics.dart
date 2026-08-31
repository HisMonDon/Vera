import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/views/pages/videos/physics_videos/curriculum_topic_filters.dart';
import 'package:coolapp/views/pages/videos/physics_videos/topic_registry.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/topic_widgets.dart';

//not done
class IntroToPhysics extends StatefulWidget {
  const IntroToPhysics({super.key});

  static const List<Map<String, dynamic>> videos = [
    {
      'curriculumKey': 'vectors_scalars',
      'title': 'Vectors and Scalars',
      'description': 'Definition and examples of vectors and scalars',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/intro_to_physics/Unit%201%20Vectors%20and%20Scalars.mp4', //completed with cloudflare on 2025/10/18, updated 2025/12/21
    },
    {
      'curriculumKey': 'error_analysis',
      'title': 'Error Analysis and Measurement',
      'description':
          'Tools and techniques for measurement, error analysis and uncertainty in measurements',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/intro_to_physics/Unit%202%20Lab%20Work%20and%20Uncertainties.mp4', //completed 2025/12/21
    },
  ];

  @override
  State<IntroToPhysics> createState() => _IntroToPhysicsState();
}

class _IntroToPhysicsState extends State<IntroToPhysics> {
  /// This page's topic. All display copy is looked up from it, so the
  /// name here cannot disagree with Explore, the lesson page or the player.
  static const String _topicKey = CurriculumTopicFilters.introToPhysics;

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
      topicKey: CurriculumTopicFilters.introToPhysics,
      units: IntroToPhysics.videos,
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
                    topicKey: CurriculumTopicFilters.introToPhysics,
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
