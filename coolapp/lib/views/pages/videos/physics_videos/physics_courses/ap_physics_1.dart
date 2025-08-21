import 'package:auto_size_text/auto_size_text.dart';
import 'package:coolapp/views/pages/videos/free_videos.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/kinematics.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/views/pages/videos/video_player.dart';

//not done
class ApPhysics1 extends StatefulWidget {
  const ApPhysics1({super.key});

  @override
  State<ApPhysics1> createState() => _ApPhysics1State();
}

class _ApPhysics1State extends State<ApPhysics1> {
  Widget _buildVideoButton(
    String title,
    String description,
    int index,
    Widget videoPage,
    String videoLink,
  ) {
    bool isCompleted = false; //later will implement completion tracking
    bool isHovered = hoveredStates[index] ?? false;

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
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isHovered
                  ? Color.fromARGB(255, 9, 71, 55).withOpacity(0.25)
                  : Colors.black.withOpacity(0.1),
              blurRadius: isHovered ? 8 : 4,
              offset: isHovered ? Offset(0, 4) : Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              if (index == videosList.length - 1) {
                globals.nextVideoTitle = 'last_one';
              } else {
                globals.nextVideoTitle = videosList[index + 1]['title'];
              }
              globals.videoLink = videoLink;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => videoPage),
              );
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isHovered
                      ? [
                          Color.fromARGB(255, 10, 97, 80),
                          Color.fromARGB(255, 7, 61, 51),
                        ]
                      : [
                          Color.fromARGB(255, 8, 77, 63),
                          Color.fromARGB(255, 5, 46, 39),
                        ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isHovered
                      ? Color.fromARGB(255, 34, 197, 94).withOpacity(0.6)
                      : const Color.fromARGB(0, 121, 27, 27), //transparent
                  width: 1.5,
                ),
              ),
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
      'videoPage': VideoPlayerScreen(),
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
      'title': 'Unit 4: Circular Motion',
      'description': "Centripetal acceleration and Kepler's laws",
      'videoPage': VideoPlayerScreen(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title': 'Unit 5: Energy and Work',
      'description':
          'Work-energy theorem and conservation of Energy (Very important unit)',
      'videoPage': VideoPlayerScreen(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title': 'Unit 6: Momentum', //shared with grade 12 phy
      'description': 'Collision analysis and center of mass',
      'videoPage': VideoPlayerScreen(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title': 'Unit 7: Harmonics',
      'description': 'Pendulum dynamics and spring systems',
      'videoPage': VideoPlayerScreen(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title': 'Unit 8: Rotational Motion',
      'description': 'Rotational kinematics and moment of inertia',
      'videoPage': VideoPlayerScreen(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title': 'Unit 9: Fluids',
      'description': "Bernoulli's principle and Pascal's law applications",
      'videoPage': VideoPlayerScreen(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
  ];
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.courseTitle = 'AP Physics 1';
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
                    "AP Physics 1",
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
