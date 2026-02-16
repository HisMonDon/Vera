import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/electricity.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/electrostatics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/harmonics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/intro_to_physics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/kinematics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/light.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/magnetism.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/modern.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/optics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/rotational_motion.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/thermal_physics.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';

//not done
class IbPhysicsHl extends StatefulWidget {
  const IbPhysicsHl({super.key});

  @override
  State<IbPhysicsHl> createState() => _IbPhysicsHlState();
}

class _IbPhysicsHlState extends State<IbPhysicsHl> {
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

  final double _width = 400;
  final double _height = 200;
  Map<int, bool> hoveredStates = {};
  final List<Map<String, dynamic>> videosList = [
    {
      'title': 'Topic 1: Measurement and Uncertainty',
      'description': 'Fundamental concepts, units, uncertainties, and vectors.',
      'videoPage': const IntroToPhysics(),
    },
    {
      'title': 'Topic 2: Mechanics (Kinematics & Dynamics)',
      'description': 'Motion, forces, work, energy, power, and momentum.',
      'videoPage': const Kinematics(),
    },
    {
      'title': 'Topic 3: Thermal Physics',
      'description':
          'Temperature, heat, kinetic theory of gases, and thermodynamics.',
      'videoPage': const ThermalPhysics(),
    },
    {
      'title': 'Topic 4: Waves (Harmonics)',
      'description':
          'Oscillations, travelling waves, wave characteristics, and interference.',
      'videoPage': const Harmonics(),
    },
    {
      'title': 'Topic 5: Electricity',
      'description':
          'Electric fields, heating effect, and electric circuits.',
      'videoPage': const Electricity(),
    },
    {
      'title': 'Topic 6: Magnetism',
      'description':
          'Magnetic fields and magnetic effects of electric currents.',
      'videoPage': const Magnetism(),
    },
    {
      'title': 'Topic 7: Circular Motion and Gravitation',
      'description':
          'Kinematics of uniform circular motion and gravitational fields.',
      'videoPage': const RotationalMotion(),
    },
    {
      'title': 'Topic 8: Wave Phenomena and Light',
      'description':
          'Simple harmonic motion, single-slit diffraction, interference, and resolution.',
      'videoPage': const Light(),
    },
    {
      'title': 'Topic 9: Fields (Electrostatics)',
      'description':
          'Describing fields, gravitational fields, electric fields, and magnetic fields.',
      'videoPage': const Electrostatics(),
    },
    {
      'title': 'Topic 10: Nuclear and Modern Physics',
      'description':
          'Introduction to modern physics concepts including special relativity, quantum mechanics, atomic structure, and nuclear physics.',
      'videoPage': const Modern(),
    },
  ];
    //add nuclear and quantum physics later
     /*A typical full IB Physics HL order (based on the IB themes plus HL add-ons) is closer to:

Measurements & Uncertainty (Intro)

Mechanics (Kinematics, Forces, Work/Energy, Momentum)

Rigid Body Mechanics (HL) & Circular motion & Gravitation

Thermal Physics & Thermodynamics (HL)

Waves & Wave Phenomena (HL)

Electricity & Magnetism (Fields + circuits + motion of charges)

Electromagnetic Induction (HL)

Nuclear & Atomic Physics

Quantum Physics (HL)

Relativity (HL) and advanced Fields content (potentials, equipotentials)*/
  ];
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.courseTitle = 'IB Physics HL';
    globals.topicTitle = '';
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
                      child: Icon(Icons.public, size: 40, color: Colors.white),
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
                              "IB Physics HL",
                              style: GoogleFonts.montserrat(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "International Baccalaureate Higher Level physics course with mathematical analysis and calculations.",
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
                    globals.courseTitle = '';
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
