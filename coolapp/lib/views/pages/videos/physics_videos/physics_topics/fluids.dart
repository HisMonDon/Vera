import 'package:auto_size_text/auto_size_text.dart';
import 'package:coolapp/views/pages/videos/video_player.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/views/pages/videos/physics_videos/curriculum_topic_filters.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/topic_widgets.dart';

class Fluids extends StatefulWidget {
  const Fluids({super.key});

  @override
  State<Fluids> createState() => _FluidsState();
}

class _FluidsState extends State<Fluids> {
  final double _width = 400;
  final double _height = 200;
  Map<int, bool> hoveredStates = {};
  final List<Map<String, dynamic>> videosList = [
    {
      'curriculumKey': 'fluids_intro',
      'title': 'Unit 1: Introduction to Fluid Mechanics',
      'description':
          'Density, pressure, and the properties of fluids at rest and in motion',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/intro%20to%20fluids.mp4', //done 2025/11/01, patched 2025/11/08
    },
    {
      'curriculumKey': 'fluids_ib_ap_tips',
      'title': 'Extra: IB and AP Tips and Tricks',
      'description': 'Tips and useful constants for IB and AP',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/fluid%20IB%20tip%20and%20tricks.mp4', //done 2025/11/01
    },
    {
      'curriculumKey': 'fluids_statics',
      'title': 'Unit 2: Fluid Statics',
      'description':
          'Pascal\'s principle, hydrostatic pressure, and buoyancy (Archimedes\' principle)',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/buoyancy%20intro.mp4', //done 2025/11/01
    },
    {
      'curriculumKey': 'fluids_dynamics',
      'title': 'Unit 3: Fluid Dynamics',
      'description':
          'Continuity equation, Bernoulli\'s equation, and fluid flow analysis',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/bernoullis%20equation.mp4', //done 2025/11/01, patched 2025/11/08
    },
    {
      'curriculumKey': 'fluids_example1',
      'title': 'Fluid Statics and Dynamics Examples',
      'description': 'Past AP Question on Fluid Statics and Buoyancy Force',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/2025%20AP%20Physics%201%20Solutions%20Free%20Response%20Q4%20(1080p).mp4', //done 2025/12/22
    },
    {
      'curriculumKey': 'fluids_example2',
      'title': 'Fluid Statics and Dynamics Examples 2',
      'description': 'Another practice question on Fluid Dynamics',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/AP%20Physics%201%20Fluids%20Example%20Question%201%20(1080p).mp4', //done 2025/12/22
    },
  ];
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.topicTitle = 'Fluids';
    final visibleVideos = CurriculumTopicFilters.filterUnits(
      courseTitle: globals.courseTitle,
      topicKey: CurriculumTopicFilters.fluids,
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
                    'The study of liquids and gases at rest and in motion, including pressure, buoyancy, and flow behavior',
                topIcon: Icons.water_drop,
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
