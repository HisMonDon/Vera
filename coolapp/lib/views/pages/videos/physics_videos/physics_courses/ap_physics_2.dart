import 'package:auto_size_text/auto_size_text.dart';
import 'package:coolapp/views/pages/videos/free_videos.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/electricity_and_magnetism.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/electrostatics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/optics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/quantum_mechanics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/thermal_physics.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/views/pages/videos/video_player.dart';

//not done
class ApPhysics2 extends StatefulWidget {
  const ApPhysics2({super.key});

  @override
  State<ApPhysics2> createState() => _ApPhysics2State();
}

class _ApPhysics2State extends State<ApPhysics2> {
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
      'title': 'Unit 1: Thermodynamics',
      'description': 'Kinetic Theory Of Gases, Laws of Thermodynamics',
      'videoPage': ThermalPhysics(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title': 'Unit 2: Electrostatics',
      'description': "Electric Charge, Coulomb's Law, Electric Field",
      'videoPage': Electrostatics(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title': 'Unit 3: Electric Circuits and Magnetism',
      'description':
          'RC Time Constants, Circuit Analysis, Magnetic fields, EMF, Moving Charges',
      'videoPage': ElectricityAndMagnetism(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },

    {
      'title': 'Unit 4: Optics',
      'description': 'Lens equations and optical instruments',
      'videoPage': Optics(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title': 'Unit 5: Modern Physics',
      'description': 'Nuclear, Quantum, Atomic Physics, wave functions',
      'videoPage': QuantumMechanics(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
  ];
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.courseTitle = 'AP Physics 2';
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
                      child: Icon(Icons.science, size: 40, color: Colors.white),
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
                              "AP Physics 2",
                              style: GoogleFonts.montserrat(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Algebra-based college-level physics focused on fluid mechanics, thermodynamics, electricity, magnetism and optics",
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
