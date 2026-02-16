import 'package:auto_size_text/auto_size_text.dart';
import 'package:coolapp/views/pages/videos/video_player.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/views/pages/videos/physics_videos/curriculum_topic_filters.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/topic_widgets.dart';

class Optics extends StatefulWidget {
  const Optics({super.key});

  @override
  State<Optics> createState() => _OpticsState();
}

class _OpticsState extends State<Optics> {
  final double _width = 400;
  final double _height = 200;
  Map<int, bool> hoveredStates = {};
  final List<Map<String, dynamic>> videosList = [
    {
      'title': 'Unit 1: Introduction to Optics',
      'description':
          'Light as electromagnetic waves, properties of light, and the electromagnetic spectrum',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/optics/Unit%201%20Introducution%20to%20Light.mp4', //completed 12/25/2025 merry christmas!
    },
    {
      'title': 'Unit 2: Lenses Part 1',
      'description':
          'Law of reflection, introduction to convex and concave lenses, real and virtual images.',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/optics/Unit%202%20Lenses%20Part%201.mp4', //completed 12/25/2025
    },
    {
      'title': 'Unit 3: Lenses Part 2',
      'description':
          'Relationship between height, magnification, and distance in convex and concave lenses.',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/optics/Unit%203%20Lenses%20Part%202.mp4', //completed 12/25/2025
    },
  ];
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.topicTitle = 'Optics';
    final visibleVideos = CurriculumTopicFilters.filterUnits(
      courseTitle: globals.courseTitle,
      topicKey: CurriculumTopicFilters.optics,
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
                    'The study of light behavior including reflection, refraction, diffraction, and the formation of images through various optical systems',
                topIcon: Icons.wb_sunny,
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
