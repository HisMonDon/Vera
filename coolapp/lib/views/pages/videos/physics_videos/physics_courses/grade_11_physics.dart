import 'package:auto_size_text/auto_size_text.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/dynamics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/electricity_and_magnetism.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/harmonics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/intro_to_physics.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
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
    //String imagePath,
  ) {
    bool isCompleted = false; //later will implement completion tracking
    bool isHovered = hoveredStates[index] ?? false;

    return MouseRegion(
      onEnter: (_) => setState(
        () => hoveredStates[index] = true,
      ), // changed this for no error
      onExit: (_) => setState(() => hoveredStates[index] = false),
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
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isHovered
                    ? Color.fromARGB(255, 8, 77, 63)
                    : Color.fromARGB(255, 8, 83, 68),

                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isHovered
                      ? Color.fromARGB(255, 167, 198, 131)
                      : const Color.fromARGB(0, 121, 27, 27), //transparent
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? Color.fromARGB(255, 34, 197, 94)
                          : Color.fromARGB(255, 15, 118, 110).withOpacity(0.3),
                    ),
                    child: Center(
                      child: isCompleted
                          ? Icon(
                              Icons.check,
                              color: Colors.white,
                            ) // implement isCompleted later
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.montserrat(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          description,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: Color.fromARGB(255, 204, 247, 227),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 167, 198, 131),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.play_arrow_rounded,
                        size: 24,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (index == videosList.length - 1) {
                          globals.nextVideoTitle = 'last_one';
                        } else {
                          globals.nextVideoTitle =
                              videosList[index + 1]['title'];
                        }
                        globals.videoLink = videoLink;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => videoPage),
                        );
                      },
                    ),
                  ),
                ],
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
      'videoPage': Dynamics(), //change to new physics topic
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
      'title': 'Unit 5: Harmonics',
      'description': 'Pendulum dynamics, waves and sounds',
      'videoPage': Harmonics(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title': 'Unit 6: Electricity',
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
    return Scaffold(
      appBar: TimedAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(width: 2, height: 10),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 10, 97, 80),
                      Color.fromARGB(255, 7, 61, 51),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    //might look good?
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 167, 198, 131),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.school, size: 40, color: Colors.white),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 10),
                            Text(
                              "Grade 11 Physics",
                              style: GoogleFonts.montserrat(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Ontario curriculum physics course covering mechanics, waves, and electricity fundamentals",
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: Color(0xFFCCF7E3),
                              ),
                            ),
                            SizedBox(height: 16),

                            //course stats underneath
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 2, height: 20),
              Column(
                children: List.generate(videosList.length, (index) {
                  final video = videosList[index];
                  return _buildVideoButton(
                    video['title'] ?? '',
                    video['description'] ?? '',
                    index,
                    video['videoPage']!,
                    video['videoLink'],
                  );
                }),
              ),
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.arrow_back),
                  label: Text("Return to Courses"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 167, 198, 131),
                    foregroundColor: const Color.fromARGB(255, 15, 48, 40),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    globals.topicTitle = '';
                    Navigator.of(context).pop();
                  },
                ),
              ),

              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
