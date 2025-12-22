import 'package:auto_size_text/auto_size_text.dart';
import 'package:coolapp/views/pages/videos/free_videos.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/views/pages/videos/video_player.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/topic_widgets.dart';

//not done
class ElectricityAndMagnetism extends StatefulWidget {
  const ElectricityAndMagnetism({super.key});

  @override
  State<ElectricityAndMagnetism> createState() =>
      _ElectricityAndMagnetismState();
}

class _ElectricityAndMagnetismState extends State<ElectricityAndMagnetism> {
  double _width = 400;
  double _height = 200;
  Map<int, bool> hoveredStates = {};
  final List<Map<String, dynamic>> videosList = [
    {
      'title': 'Unit 1: Introduction to Circuits',
      'description':
          "Ohm's law, behaviour of current, voltage, and resistance in different types of circuits.",
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/electricity_and_magnetism/1%20Introduction%20to%20Circuits.mp4', // added 2025/12/21
    },
    {
      'title': "Unit 2: Kirchhoff's Current Law",
      'description':
          "Introduction to Kirchhoff's Current Law, example problems on application.",
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          "https://pub-56767059a1844d06818006869a91df08.r2.dev/electricity_and_magnetism/2%20Kirchhoff's%20Current%20Law.mp4", // added 2025/12/21
    },
    {
      'title': "Unit 3: AP/IB style Circuit Problem",
      'description':
          "Example on a combination of ohm's law, circuit behaviour, and Kirchhoff's Current law.",
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          "https://pub-56767059a1844d06818006869a91df08.r2.dev/electricity_and_magnetism/3%20Circuit%20Example.mp4", // added 2025/12/21
    },
    {
      'title': 'Unit 4: Capacitance',
      'description':
          'Parallel plate capacitors, energy storage, and behaviour of capaciters over time.',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/electricity_and_magnetism/4%20Capacitance.mp4', // added 2025/12/21
    },
    {
      'title': 'Unit 5: Right hand rule',
      'description':
          'Introduction on how to use the right hand rule, applications.',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/electricity_and_magnetism/5%20Right%20hand%20rule.mp4', // added 2025/12/21
    },
    {
      'title': 'Unit 6: Magnetic Flux (IB/AP)',
      'description':
          "Introcution to magnetic flux, effect of angles, applications",
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/electricity_and_magnetism/IBAP%20Introduction%20to%20Magnetic%20Flux.mp4', // added 2025/12/21
    },
  ];
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.topicTitle = 'Electricity and Magnetism';
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
                    'Principles of electric and magnetic phenomena, right hand rule, exploring concepts such as electric charge, electric fields, potential difference, current, resistance, and circuits. Extend this understanding to magnetic fields, electromagnetic induction, and the relationship between electricity and magnetism',
                topIcon: Icons.flash_on,
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
