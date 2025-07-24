import 'package:auto_size_text/auto_size_text.dart';
import 'package:coolapp/views/pages/videos/free_videos.dart';
import 'package:coolapp/views/pages/videos/physics_videos/kinematics.dart';
import 'package:flutter/material.dart';
//import 'package:coolapp/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';

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
      'videoPage': FreeVideos(),
    },
    {
      'title': 'Unit 2: Kinematics',
      'description': 'Motion graphs and kinematic equations',
      'videoPage': Kinematics(),
    },
    {
      'title': 'Unit 3: Circular Motion',
      'description': "Centripetal acceleration and Kepler's laws",
      'videoPage': FreeVideos(),
    },
    {
      'title': 'Unit 4: Energy',
      'description':
          'Work-energy theorem and conservation of Energy (Very important unit)',
      'videoPage': FreeVideos(),
    },
    {
      'title': 'Unit 5: Momentum', //shared with grade 12 phy
      'description': 'Collision analysis and center of mass',
      'videoPage': FreeVideos(),
    },
    {
      'title': 'Unit 6: Harmonics',
      'description': 'Pendulum dynamics and spring systems',
      'videoPage': FreeVideos(),
    },
    {
      'title': 'Unit 7: Rotational Motion',
      'description': 'Rotational kinematics and moment of inertia',
      'videoPage': FreeVideos(),
    },
    {
      'title': 'Unit 8: Fluids',
      'description': "Bernoulli's principle and Pascal's law applications",
      'videoPage': FreeVideos(),
    },
  ];
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method

    int buttonColorShift = 10;
    bool phy_11_hovered = false;
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
                    ),
                  );
                }),
              ),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
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
