import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/views/pages/videos/physics_videos/curriculum_topic_filters.dart';
import 'package:coolapp/views/pages/videos/physics_videos/topic_registry.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/topic_widgets.dart';

class RotationalMotion extends StatefulWidget {
  const RotationalMotion({super.key});

  static const List<Map<String, dynamic>> videos = [
    {
      'curriculumKey': 'rotation_intro',
      'title': 'Introduction to Rotational Motion',
      'description':
          'Basic concepts of circular motion, angular displacement, and angular velocity',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/rotational_motion/Unit%201%20Introduction%20to%20Rotational%20Motion.mp4', //completed 2025/12/27
    },
    {
      'curriculumKey': 'rotation_kinematics',
      'title': 'Rotational Kinematics',
      'description':
          'Angular position, velocity, and acceleration relationships in rotational motion',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/rotational_motion/Unit%202%20Rotational%20Kinematics.mp4', //completed 2025/12/27
    },
    {
      'curriculumKey': 'torque_equilibrium',
      'title': 'Torque and Rotational Equilibrium',
      'description':
          'Introduction and leeson on how torque causes rotational accceleration and balanced torque systems.',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/rotational_motion/Unit%203%20Torque%20and%20Rotational%20Equilibrium.mp4', //completed 2025/12/27
    },
    {
      'curriculumKey': 'torque_ap_example',
      'title': 'Torque and Rotational Forces Example',
      'description':
          'Past AP Exam FRQ question analyzing the calculations of torque in a real world example.',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/rotational_motion/app.yt1z.net%20-%202024%20AP%20Physics%201%20Solutions%20Free%20Response%20Q3%20(1080p).mp4', //completed 2025/12/27
    },
    {
      'curriculumKey': 'moment_inertia',
      'title': 'Moment of Inertia',
      'description':
          'Understanding rotational mass, calculating moment of inertia for different objects',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/rotational_motion/Unit%205%20Moment%20of%20Inertia.mp4', //completed 2025/12/27
    },
  ];

  @override
  State<RotationalMotion> createState() => _RotationalMotionState();
}

class _RotationalMotionState extends State<RotationalMotion> {
  /// This page's topic. All display copy is looked up from it, so the
  /// name here cannot disagree with Explore, the lesson page or the player.
  static const String _topicKey = CurriculumTopicFilters.rotationalMotion;

  final double _width = 400;
  final double _height = 200;
  Map<int, bool> hoveredStates = {};
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.topicTitle = TopicRegistry.nameOf(_topicKey);
    final visibleVideos = CurriculumTopicFilters.filterUnits(
      courseKey: globals.courseKey,
      topicKey: CurriculumTopicFilters.rotationalMotion,
      units: RotationalMotion.videos,
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
                    topicKey: CurriculumTopicFilters.rotationalMotion,
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
