import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/views/pages/videos/physics_videos/curriculum_topic_filters.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/topic_widgets.dart';

class SampleVideos extends StatefulWidget {
  const SampleVideos({super.key});

  static const List<Map<String, dynamic>> videos = [
    {
      'curriculumKey': 'vectors_scalars',
      'title': 'Vectors and Scalars',
      'description': 'Definition and examples of vectors and scalars',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/intro_to_physics/Unit%201%20Vectors%20and%20Scalars.mp4', //Completed 2025/12/31
    },
    {
      'curriculumKey': 'kinematics_1d',
      'title': "Kinematics in 1D",
      'description':
          "Basic kinematics, introduction to acceleration and velocity",
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/Unit%201%201D%20Kinematics.mp4', //Completed 2025/12/31
    },
  ];

  @override
  State<SampleVideos> createState() => _SampleVideosState();
}

class _SampleVideosState extends State<SampleVideos> {
  final double _width = 400;
  final double _height = 200;
  Map<int, bool> hoveredStates = {};
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.topicTitle = 'Sample Videos';
    //print("topic title: Momentum and collisions, unit title reset");
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
                    "Sample videos showcasing a regular lesson structure. Introduces the basic concepts of vectors, position, velocity, and acceleration.",
                topIcon: Icons.lightbulb,
              ),
              SizedBox(width: 2, height: 20),
              Column(
                children: List.generate(SampleVideos.videos.length, (index) {
                  final video = SampleVideos.videos[index];
                  return TopicWidgets.buildVideoButton(
                    title: video['title'] ?? '',
                    description: video['description'] ?? '',
                    index: index,
                    topicKey: CurriculumTopicFilters.sampleVideos,
                    videosList: SampleVideos.videos,
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
