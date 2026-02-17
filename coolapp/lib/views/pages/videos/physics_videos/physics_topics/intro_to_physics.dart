import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/views/pages/videos/physics_videos/curriculum_topic_filters.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/views/pages/videos/video_player.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/topic_widgets.dart';

//not done
class IntroToPhysics extends StatefulWidget {
  const IntroToPhysics({super.key});

  @override
  State<IntroToPhysics> createState() => _IntroToPhysicsState();
}

class _IntroToPhysicsState extends State<IntroToPhysics> {
  final double _width = 400;
  final double _height = 200;
  Map<int, bool> hoveredStates = {};
  final List<Map<String, dynamic>> videosList = [
    {
      'curriculumKey': 'vectors_scalars',
      'title': 'Vectors and Scalars',
      'description': 'Definition and examples of vectors and scalars',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/intro_to_physics/Unit%201%20Vectors%20and%20Scalars.mp4', //completed with cloudflare on 2025/10/18, updated 2025/12/21
    },
    {
      'curriculumKey': 'error_analysis',
      'title': 'Error Analysis and Measurement',
      'description':
          'Tools and techniques for measurement, error analysis and uncertainty in measurements',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/intro_to_physics/Unit%202%20Lab%20Work%20and%20Uncertainties.mp4', //completed 2025/12/21
    },
  ];
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.topicTitle = 'Introduction to Physics';
    //print("topic title: Momentum and collisions, unit title reset");
    final visibleVideos = CurriculumTopicFilters.filterUnits(
      courseTitle: globals.courseTitle,
      topicKey: CurriculumTopicFilters.introToPhysics,
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
                    'Short topic explaining the introduction to physics, including vectors, velocity, and displacement',
                topIcon: Icons.show_chart,
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
