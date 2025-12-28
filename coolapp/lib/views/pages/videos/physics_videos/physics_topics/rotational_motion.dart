import 'package:auto_size_text/auto_size_text.dart';
import 'package:coolapp/views/pages/videos/video_player.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/topic_widgets.dart';

class RotationalMotion extends StatefulWidget {
  const RotationalMotion({super.key});

  @override
  State<RotationalMotion> createState() => _RotationalMotionState();
}

class _RotationalMotionState extends State<RotationalMotion> {
  double _width = 400;
  double _height = 200;
  Map<int, bool> hoveredStates = {};
  final List<Map<String, dynamic>> videosList = [
    {
      'title': 'Unit 1: Introduction to Rotational Motion',
      'description':
          'Basic concepts of circular motion, angular displacement, and angular velocity',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/rotational_motion/Unit%201%20Introduction%20to%20Rotational%20Motion.mp4', //completed 2025/12/27
    },
    {
      'title': 'Unit 2: Rotational Kinematics',
      'description':
          'Angular position, velocity, and acceleration relationships in rotational motion',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/rotational_motion/Unit%202%20Rotational%20Kinematics.mp4', //completed 2025/12/27
    },
    {
      'title': 'Unit 3: Torque and Rotational Equilibrium',
      'description':
          'Introduction and leeson on how torque causes rotational accceleration and balanced torque systems.',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/rotational_motion/Unit%203%20Torque%20and%20Rotational%20Equilibrium.mp4', //completed 2025/12/27
    },
    {
      'title': 'Unit 4: Torque and Rotational Forces Example',
      'description':
          'Past AP Exam FRQ question analyzing the calculations of torque in a real world example.',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/Holder%20Video%20(Video%20not%20Released%20Yet).mp4', //completed 2025/12/27
    },
    {
      'title': 'Unit 5: Moment of Inertia',
      'description':
          'Understanding rotational mass, calculating moment of inertia for different objects',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/rotational_motion/Unit%205%20Moment%20of%20Inertia.mp4', //completed 2025/12/27
    },
  ];
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.topicTitle = 'Rotational Motion';
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
                    'Analyze motion in circular paths, including angular velocity, acceleration, torque, moment of inertia, and angular momentum conservation',
                topIcon: Icons.rotate_right,
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
