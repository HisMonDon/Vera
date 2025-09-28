import 'package:auto_size_text/auto_size_text.dart';
import 'package:coolapp/views/pages/videos/video_player.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/topic_widgets.dart';

class Electrostatics extends StatefulWidget {
  const Electrostatics({super.key});

  @override
  State<Electrostatics> createState() => _ElectrostaticsState();
}

class _ElectrostaticsState extends State<Electrostatics> {
  double _width = 400;
  double _height = 200;
  Map<int, bool> hoveredStates = {};
  final List<Map<String, dynamic>> videosList = [
    {
      'title': 'Unit 1: Electric Charge',
      'description':
          'Fundamental properties of electric charge, conductors and insulators',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title': 'Unit 2: Coulomb\'s Law',
      'description':
          'Force between electric charges and vector addition of electric forces',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title': 'Unit 3: Electric Fields',
      'description':
          'Field concept, field lines, and calculating electric fields from various charge distributions',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title': 'Unit 4: Electric Potential',
      'description':
          'Electric potential energy, voltage, and equipotential surfaces',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title': 'Unit 5: Capacitance',
      'description':
          'Capacitors, dielectrics, and energy storage in electric fields',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
  ];
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.topicTitle = 'Electrostatics';
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
                    'The study of electric charges at rest, electric fields, electric potential, and their applications',
                topIcon: Icons.bolt,
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
