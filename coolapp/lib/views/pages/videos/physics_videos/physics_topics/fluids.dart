import 'package:auto_size_text/auto_size_text.dart';
import 'package:coolapp/views/pages/videos/video_player.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/topic_widgets.dart';

class Fluids extends StatefulWidget {
  const Fluids({super.key});

  @override
  State<Fluids> createState() => _FluidsState();
}

class _FluidsState extends State<Fluids> {
  double _width = 400;
  double _height = 200;
  Map<int, bool> hoveredStates = {};
  final List<Map<String, dynamic>> videosList = [
    {
      'title': 'Unit 1: Introduction to Fluid Mechanics',
      'description':
          'Density, pressure, and the properties of fluids at rest and in motion',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/intro%20to%20fluids.mp4', //done 2025/11/01, patched 2025/11/08
    },
    {
      'title': 'Extra: IB and AP Tips and Tricks',
      'description': 'Tips and useful constants for IB and AP',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/fluid%20IB%20tip%20and%20tricks.mp4', //done 2025/11/01
    },
    {
      'title': 'Unit 2: Fluid Statics',
      'description':
          'Pascal\'s principle, hydrostatic pressure, and buoyancy (Archimedes\' principle)',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/buoyancy%20intro.mp4', //done 2025/11/01
    },
    {
      'title': 'Unit 3: Fluid Dynamics',
      'description':
          'Continuity equation, Bernoulli\'s equation, and fluid flow analysis',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/bernoullis%20equation.mp4', //done 2025/11/01, patched 2025/11/08
    },
    {
      'title': 'Unit 5: Fluid Statics and Dynamics Examples',
      'description': 'Examples on both fluid statics and dynamics',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/Holder%20Video%20(Video%20not%20Released%20Yet).mp4',
    },
  ];
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.topicTitle = 'Fluids';
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
