import 'package:auto_size_text/auto_size_text.dart';
import 'package:coolapp/views/pages/videos/not_logged_in.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/electricity_and_magnetism.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/intro_to_physics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/kinematics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/momentum_and_collisions.dart';
import 'package:coolapp/views/pages/videos/video_pages/courses_page.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';

class TopicsPage extends StatefulWidget {
  const TopicsPage({super.key});

  @override
  State<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  bool _checkedAuth = false;

  Widget _buildVideoButton(
    String title,
    String imagePath,
    String description,
    int index,
    Widget videoPage,
  ) {
    if (!globals.isLoggedIn) {
      return NotLoggedIn(); //keep in mind that this js does the message in every single button
    }

    double _width;
    double _height;
    bool isHovered = hoveredStates[index] ?? false;
    if (isHovered) {
      _width = 450;
      _height = 550;
    } else {
      _height = 500;
      _width = 500;
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
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 30, 60, 50),
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
              AutoSizeText(
                title,
                maxLines: 1,
                style: GoogleFonts.montserrat(
                  fontSize: 30,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              const SizedBox(width: 1, height: 10),
              Image(image: AssetImage(imagePath)),
              const SizedBox(width: 1, height: 20),
              AutoSizeText(
                description,
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 199, 252, 221),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _width = 400;
  double _height = 500;
  Map<int, bool> hoveredStates = {};
  final List<Map<String, dynamic>> courseList = [
    {
      'title': 'Introduction to Physics',
      'imagePath': 'images/intro_to_physics.jpg',
      'description':
          'Covers the basics of physics, including vectors, velocity, and displacement',
      'videoPage': IntroToPhysics(),
    },
    {
      'title': 'Kinematics',
      'imagePath': 'images/kinematics.jpg',
      'description': 'Tutorial videos on kinematics and projectile motion',
      'videoPage': Kinematics(),
    },
    {
      'title': 'Electricity and Magnetism',
      'imagePath': 'images/electricity.jpg',
      'description':
          'Tutorial videos on electric fields, circuits, magnetic interactions, and electromagnetic waves',
      'videoPage': ElectricityAndMagnetism(),
    },
    {
      'title': 'Momentum and Collisions',
      'imagePath': 'images/momentum.jpg',
      'description':
          'Tutorial videos on momentum, elastic and non-elastic collisions, and impulse',
      'videoPage': MomentumAndCollisions(),
    },
  ];
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method

    int buttonColorShift = 10;
    bool phy_11_hovered = false;
    if (!globals.isLoggedIn) {
      return NotLoggedIn();
    }
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Physics Topics and Subfields',
                  style: GoogleFonts.mPlus1(fontSize: 40),
                ),
                SizedBox(height: 20),
                Flexible(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = constraints.maxWidth > 1000
                          ? 3
                          : constraints.maxWidth > 700
                          ? 2
                          : 1;

                      return GridView.builder(
                        shrinkWrap: false,
                        physics: AlwaysScrollableScrollPhysics(),

                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: courseList.length,
                        itemBuilder: (context, index) {
                          final course = courseList[index];
                          return _buildVideoButton(
                            course['title'] ?? '',
                            course['imagePath'] ?? '',
                            course['description'] ?? '',
                            index,
                            course['videoPage']!,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 20,
            left:
                MediaQuery.of(context).size.width / 2 -
                125, //change this when dealing with button
            child: SizedBox(
              width: 250,
              height: 80,
              child: Container(
                height: 80,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: Color.fromARGB(255, 60, 90, 70),
                ),
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(fixedSize: Size(100, 50)),
                      onPressed: () {
                        print("Backwards Pressed");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => CoursePage()),
                        );
                      },

                      child: Icon(Icons.arrow_back, size: 30),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(100, 50),
                        disabledBackgroundColor: const Color.fromARGB(
                          255,
                          10,
                          73,
                          59,
                        ),
                      ),
                      onPressed: null,
                      child: Icon(Icons.arrow_forward, size: 30),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
