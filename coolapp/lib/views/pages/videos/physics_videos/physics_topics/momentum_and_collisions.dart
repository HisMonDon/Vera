import 'package:auto_size_text/auto_size_text.dart';
import 'package:coolapp/views/pages/videos/video_player.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/views/pages/videos/physics_videos/curriculum_topic_filters.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/topic_widgets.dart';

//not done
class MomentumAndCollisions extends StatefulWidget {
  const MomentumAndCollisions({super.key});

  @override
  State<MomentumAndCollisions> createState() => _MomentumAndCollisionsState();
}

class _MomentumAndCollisionsState extends State<MomentumAndCollisions> {
  final double _width = 400;
  final double _height = 200;
  Map<int, bool> hoveredStates = {};
  final List<Map<String, dynamic>> videosList = [
    {
      'curriculumKey': 'momentum_intro',
      'title': 'Introduction to Momentum',
      'description':
          'Introduction to momentum, apply basic momentum formulae to moving objects',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/momentum_and_collisions/Unit%201%20Introduction%20to%20Momentum.mp4', //completed 2025/12/21
    },
    {
      'curriculumKey': 'collisions_elastic',
      'title': 'Inelastic and Elastic Momentum Questions',
      'description':
          'Questions on inelastic and elastic collisions, conservation of momentum and energy.',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/momentum_and_collisions/Inelastic%20and%20Elastic%20Momentum%20Questions%20(Conservation).mp4', //completed 2025/12/22
    },
    {
      'curriculumKey': 'momentum_2d',
      'title': 'Momentum in 2D',
      'description':
          'Break momentum into x and y components and apply conservation in both directions to solve planar collision problems.',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/momentum_and_collisions/Momentum%20in%202D.mp4', //completed 2025/12/22
    },
    {
      'curriculumKey': 'momentum_2d_practice',
      'title': '2D Momentum Practice',
      'description':
          'Extra example on 2D momentum, breaking vectors into x and y components',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/momentum_and_collisions/AP%20Physics%201%20While%20playing%20a%20game%20of%20billiards%2C%20your%200.17%20kg%20cue%20ball%2C%20travelling%20at%201.9%20m%20s%2C%20glan%20(1080p60)%20(1).mp4', //completed 2025/12/22
    },
    {
      'curriculumKey': 'impulse',
      'title': 'Impulse and Momentum Change',
      'description':
          'How forces change momentum over time, force-time graphs, real world applications',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/momentum_and_collisions/Impulse.mp4', //completed 2025/12/22
    },
  ];
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.topicTitle = 'Momentum and Collisions';
    //print("topic title: Momentum and collisions, unit title reset");
    final visibleVideos = CurriculumTopicFilters.filterUnits(
      courseTitle: globals.courseTitle,
      topicKey: CurriculumTopicFilters.momentumAndCollisions,
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
                    'Momentum, elastic and non-elastic collisions, and impulse',
                topIcon: Icons.train,
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
