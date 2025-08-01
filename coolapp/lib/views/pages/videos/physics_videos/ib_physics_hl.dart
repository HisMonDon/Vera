import 'package:auto_size_text/auto_size_text.dart';
import 'package:coolapp/views/pages/videos/free_videos.dart';
import 'package:flutter/material.dart';
//import 'package:coolapp/globals.dart' as globals;
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
      'title': 'Unit 1: Measurement and Uncertainties',
      'description':
          'Error propagation, uncertainty calculations, and graphical analysis techniques',
      'videoPage': FreeVideos(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title': 'Unit 2: Kinematics',
      'description': 'Motion graphs and kinematic equations',
      'videoPage': FreeVideos(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title': 'Unit 3: Rotational Motion',
      'description': 'Rotational kinematics and moment of inertia',
      'videoPage': FreeVideos(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title':
          'Unit 4:  Thermal Physics', //make a whole folder for this perchance?
      'description':
          'Kinetic theory, thermodynamics laws, and heat transfer mechanisms',
      'videoPage': FreeVideos(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title': 'Unit 5: Electricity and Magnetism',
      'description':
          "Maxwell's equations, electromagnetic induction, and AC circuits",
      'videoPage': FreeVideos(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title': 'Unit 6: Quantum Physics',
      'description':
          "Wave-particle duality, nuclear physics, and radioactive decay",
      'videoPage': FreeVideos(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
    {
      'title':
          'HL Extension: Gravitational Field', //shared with grade 12 physics
      'description': "Orbital mechanics and gravitational potential",
      'videoPage': FreeVideos(),
      'videoLink':
          'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4',
    },
  ];
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method

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
                    "IB Physics HL",
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
