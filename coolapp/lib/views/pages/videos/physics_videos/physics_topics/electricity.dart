import 'package:auto_size_text/auto_size_text.dart';
import 'package:coolapp/views/pages/videos/free_videos.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/views/pages/videos/video_player.dart';
import 'package:coolapp/views/pages/videos/physics_videos/curriculum_topic_filters.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/topic_widgets.dart';

//not done
class Electricity extends StatefulWidget {
  const Electricity({super.key});

  @override
  State<Electricity> createState() =>
      _ElectricityState();
}

class _ElectricityState extends State<Electricity> {
  final double _width = 400;
  final double _height = 200;
  Map<int, bool> hoveredStates = {};
  final List<Map<String, dynamic>> videosList = [
    {
      'curriculumKey': 'circuits_intro',
      'title': 'Introduction to Circuits',
      'description':
          "Ohm's law, behaviour of current, voltage, and resistance in different types of circuits.",
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/electricity_and_magnetism/1%20Introduction%20to%20Circuits.mp4', // added 2025/12/21
    },
    {
      'curriculumKey': 'kirchhoff_current',
      'title': "Kirchhoff's Current Law",
      'description':
          "Introduction to Kirchhoff's Current Law, example problems on application.",
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          "https://pub-56767059a1844d06818006869a91df08.r2.dev/electricity_and_magnetism/2%20Kirchhoff's%20Current%20Law.mp4", // added 2025/12/21
    },
    {
      'curriculumKey': 'circuits_example',
      'title': "AP/IB Style Circuit Problem",
      'description':
          "Example on a combination of ohm's law, circuit behaviour, and Kirchhoff's Current law.",
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          "https://pub-56767059a1844d06818006869a91df08.r2.dev/electricity_and_magnetism/3%20Circuit%20Example.mp4", // added 2025/12/21
    },
    {
      'curriculumKey': 'capacitance',
      'title': 'Capacitance',
      'description':
          'Parallel plate capacitors, energy storage, and behaviour of capaciters over time.',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/electricity_and_magnetism/4%20Capacitance.mp4', // added 2025/12/21
    },
  ];
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.topicTitle = 'Electricity';
    //print("topic title: Momentum and collisions, unit title reset");
    final visibleVideos = CurriculumTopicFilters.filterUnits(
      courseTitle: globals.courseTitle,
      topicKey: CurriculumTopicFilters.electricity,
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
                    'Principles of electric phenomena, exploring concepts such as electric charge, electric fields, potential difference, current, resistance, and circuits',
                topIcon: Icons.flash_on,
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
