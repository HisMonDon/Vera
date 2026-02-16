import 'package:auto_size_text/auto_size_text.dart';
import 'package:coolapp/views/pages/videos/free_videos.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/views/pages/videos/video_player.dart';
import 'package:coolapp/views/pages/videos/physics_videos/curriculum_topic_filters.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/topic_widgets.dart';

class Dynamics extends StatefulWidget {
  const Dynamics({super.key});

  @override
  State<Dynamics> createState() => _DynamicsState();
}

class _DynamicsState extends State<Dynamics> {
  final double _width = 400;
  final double _height = 200;
  Map<int, bool> hoveredStates = {};
  final List<Map<String, dynamic>> videosList = [
    {
      'title': "Unit 1: Introduction to Dynamics",
      'description':
          "Difference between dynamics and kinematics, Newton's three laws",
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/dynamics/introduction_to_dynamics.mp4', //Completed 2025/12/17
    },
    {
      'title': "Unit 2: Free Body Diagrams",
      'description':
          "Short tutorial on a very important type of diagram in physics",
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/dynamics/free_body_diagrams.mp4', //Completed 2025/12/17
    },
    {
      'title': 'Unit 3: Gravity and Normal Force',
      'description': 'Introduces the idea of gravity and normal force',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/dynamics/normal_force.mp4', //Completed 2025/12/17
    },
    {
      'title': 'Unit 4: Friction',
      'description':
          "Friction calculations with coefficient of friction and normal force",
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/dynamics/friction.mp4', //Completed 2025/12/17, fixed 2025/12/20
    },
    {
      'title': 'Unit 5: Extra Dynamics Examples',
      'description': "More problems on net force and normal force",
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/dynamics/extra_dynamics_problems.mp4', //Completed 2025/12/17
    },
  ];
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.topicTitle = 'Forces and Dynamics';
    //print("topic title: Momentum and collisions, unit title reset");
    final visibleVideos = CurriculumTopicFilters.filterUnits(
      courseTitle: globals.courseTitle,
      topicKey: CurriculumTopicFilters.dynamics,
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
                    "Examine how forces influence motion through Newton’s laws of motion. Concepts such as mass, weight, friction, tension, and normal force, learn how to analyze interactions between objects, use Free Body Diagrams",
                topIcon: Icons.rectangle,
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
