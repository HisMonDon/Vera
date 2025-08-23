import 'package:auto_size_text/auto_size_text.dart';
import 'package:coolapp/views/pages/videos/video_player.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/topic_widgets.dart';

//not done
class MomentumAndCollisions extends StatefulWidget {
  const MomentumAndCollisions({super.key});

  @override
  State<MomentumAndCollisions> createState() => _MomentumAndCollisionsState();
}

class _MomentumAndCollisionsState extends State<MomentumAndCollisions> {
  double _width = 400;
  double _height = 200;
  Map<int, bool> hoveredStates = {};
  final List<Map<String, dynamic>> videosList = [
    {
      'title': 'Unit 1: Introduction to Momentum',
      'description':
          'Introduction to momentum, apply basic momentum formulae to moving objects',
      'videoPage': VideoPlayerScreen(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title': 'Unit 2: Momentum in 2D',
      'description':
          'Break momentum into x- and y-components and apply conservation in both directions to solve planar collision problems.',
      'videoPage': VideoPlayerScreen(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title': 'Unit 3: Impulse and Momentum change',
      'description': 'How forces change momentum over time',
      'videoPage': VideoPlayerScreen(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title': 'Unit 4: Types of Collisions',
      'description':
          'Differences between elastic, inelastic, and perfectly inelastic collisions by analyzing how momentum and kinetic energy behave.',
      'videoPage': VideoPlayerScreen(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title': 'Momentum practice problems',
      'description': 'Practice problems with momentum',
      'videoPage': VideoPlayerScreen(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
  ];
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.topicTitle = 'Momentum and Collisions';
    print("topic title: Momentum and collisions, unit title reset");
    return Scaffold(
      appBar: TimedAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(width: 2, height: 10),
              Row(
                children: [
                  AutoSizeText(
                    "Momentum and Collisions",
                    maxLines: 1,
                    style: GoogleFonts.mPlus1(
                      fontSize: 30,
                      color: const Color.fromARGB(255, 236, 240, 236),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 2, height: 20),
              Column(
                children: List.generate(videosList.length, (index) {
                  final video = videosList[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20,
                    ), // spacing between buttons
                    child: TopicWidgets.buildVideoButton(
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
                    ),
                  );
                }),
              ),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 28, 150, 109),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'BACK',
                    style: GoogleFonts.mPlus1(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
