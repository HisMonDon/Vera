import 'package:auto_size_text/auto_size_text.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/electricity_and_magnetism.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/intro_to_physics.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/views/pages/videos/video_player.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/kinematics.dart';

//not done
class Grade11Physics extends StatefulWidget {
  const Grade11Physics({super.key});

  @override
  State<Grade11Physics> createState() => _Grade11PhysicsState();
}

class _Grade11PhysicsState extends State<Grade11Physics> {
  Widget _buildVideoButton(
    String title,
    String description,
    int index,
    Widget videoPage,
    String videoLink,
  ) {
    double _width;
    double _height;
    bool isHovered = hoveredStates[index] ?? false;
    if (isHovered) {
      _width = 400;
      _height = 200;
    } else {
      _height = 210;
      _width = 400;
    }

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          hoveredStates[index] = true;
        });
      },
      onExit: (_) {
        setState(() {
          hoveredStates[index] = false;
        });
      },
      child: AnimatedScale(
        duration: Duration(milliseconds: 200),
        scale: isHovered ? 1.05 : 1.0,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 10, 73, 59),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (index == videosList.length - 1) {
                globals.nextVideoTitle =
                    'last_one'; //check if the thing is named 'last_one'
              } else {
                globals.nextVideoTitle = videosList[index + 1]['title'];
              }
              globals.videoLink = videoLink;
              print("Pushing nav page ontop of stack...");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => videoPage),
              );
            },
            child: Column(
              children: [
                const SizedBox(width: 1, height: 30),
                Text(
                  title,
                  maxLines: 1,
                  style: GoogleFonts.montserrat(
                    fontSize: 30,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                const SizedBox(width: 1, height: 15),
                AutoSizeText(
                  description,
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 199, 252, 221),
                  ),
                  maxLines: 1,
                ),
                const SizedBox(width: 1, height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _width = 400;
  double _height = 200;
  Map<int, bool> hoveredStates = {};
  final List<Map<String, dynamic>> videosList = [
    {
      'title': 'Unit 1: Vectors and Scalars',
      'description': 'Addition and calculations with vectors and scalars.',
      'videoPage': IntroToPhysics(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title': 'Unit 2: Kinematics',
      'description': 'Motion graphs and kinematic equations',
      'videoPage': Kinematics(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title': "Unit 3: Dynamics",
      'description': "Forces and Newton's Laws",
      'videoPage': VideoPlayerScreen(), //change to new physics topic
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title': 'Unit 4: Energy and Work',
      'description':
          'Work-energy theorem and conservation of Energy (Very important unit)',
      'videoPage': VideoPlayerScreen(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title': 'Unit 5: Waves and Sound',
      'description': 'Harmonics, resonance, and Doppler effect',
      'videoPage': VideoPlayerScreen(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title': 'Unit 6: Electricity:',
      'description': 'Series and parallel combinations and power calculations',
      'videoPage':
          ElectricityAndMagnetism(), //redirect this to the thing inside electricity unit
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
  ];
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.courseTitle = 'Grade 11 Physics';
    globals.topicTitle = '';
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(width: 2, height: 10),
              Row(
                children: [
                  AutoSizeText(
                    "Grade 11 Physics",
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
                    child: _buildVideoButton(
                      video['title'] ?? '',
                      video['description'] ?? '',
                      index,
                      video['videoPage']!,
                      video['videoLink'],
                    ),
                  );
                }),
              ),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    globals.topicTitle = '';
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
