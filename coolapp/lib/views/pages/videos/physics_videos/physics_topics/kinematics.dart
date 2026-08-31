import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/views/pages/videos/physics_videos/curriculum_topic_filters.dart';
import 'package:coolapp/views/pages/videos/physics_videos/topic_registry.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/topic_widgets.dart';

//not done
class Kinematics extends StatefulWidget {
  const Kinematics({super.key});

  static const List<Map<String, dynamic>> videos = [
    {
      'curriculumKey': 'motion_1d',
      'title':
          '1D Motion Analysis', //1D MOTION ANALYSIS DONE 2025/09/11 VERSION 1.0 // updated 2025/12/30
      'description':
          'Basic kinematics, introduction to acceleration and velocity',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/Unit%201%201D%20Kinematics.mp4',
    },
    {
      'curriculumKey': 'motion_2d_part1',
      'title':
          '2D Motion Analysis Part 1', //DONE 2025/09/14 VERSION 1.0 // updated 2025/12/30
      'description': 'Introduction to 2D kinematics with velocity',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/Unit%202%202D%20Kinematics.mp4',
    },
    {
      'curriculumKey': 'motion_2d_part2',
      'title': '2D Motion Analysis Part 2', //DONE 2025/09/14 VERSION 1.0
      'description':
          'Introduces various kinematics formulae and constants used for solving problems',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/Kinematics%202D%20Part%202.mp4',
    },
    {
      'curriculumKey': 'motion_2d_part3',
      'title': '2D Motion Analysis Part 3', //DONE 2025/09/14 VERSION 1.0
      'description':
          'Application of kinematics formulae and vectors on an example problem',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/Kinematics%202D%20Part%203.mp4',
    },
    {
      'curriculumKey': 'motion_2d_examples',
      'title':
          'More 2D Kinematics Example', //DONE 2025/09/28 VERSION 1.0
      'description': 'Extra practice on 2D Kinematics',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/More%20Kinematics%20Examples%201.mp4',
    },
    {
      'curriculumKey': 'motion_2d_harder',
      'title':
          'Harder 2D Kinematics Examples', //DONE 2025/09/28 VERSION 1.0
      'description': 'More practice on 2D Kinematics',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/Kinematics%20harder%20quesitons.mp4',
    },
    {
      'curriculumKey': 'motion_graphical',
      'title': 'Graphical Kinematics',
      'description': 'Slope-area interpretations of motion graphs',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/Graphical%20Kinematics.mp4', //Done 2025/12/21 time flies
    },
  ];

  @override
  State<Kinematics> createState() => _KinematicsState();
}

class _KinematicsState extends State<Kinematics> {
  /// This page's topic. All display copy is looked up from it, so the
  /// name here cannot disagree with Explore, the lesson page or the player.
  static const String _topicKey = CurriculumTopicFilters.kinematics;

  final double _width = 400;
  final double _height = 200;
  Map<int, bool> hoveredStates = {};
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    // add an immediate check in build method
    globals.topicTitle = TopicRegistry.nameOf(_topicKey);
    //print("topic title: Momentum and collisions, unit title reset");
    final visibleVideos = CurriculumTopicFilters.filterUnits(
      courseKey: globals.courseKey,
      topicKey: CurriculumTopicFilters.kinematics,
      units: Kinematics.videos,
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
                    topicKey: CurriculumTopicFilters.kinematics,
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
