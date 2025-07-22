import 'package:coolapp/services/auth_service.dart';
import 'package:coolapp/views/pages/videos/free_videos.dart';
import 'package:coolapp/views/pages/videos/locked_page.dart';
import 'package:coolapp/views/pages/videos/not_logged_in.dart';
import 'package:coolapp/views/pages/videos/paid_videos.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';

//ts is basaiclly the page bar thing
/* Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 180,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 18, 90, 72),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          Positioned(
            bottom: 28,
            right: MediaQuery.of(context).size.width / 2 + 8,
            child: ElevatedButton(
              onPressed: () {
                print("Pressed!");
              },
              child: Icon(Icons.arrow_back),
            ),
          ),
          Positioned(
            bottom: 28,
            left: MediaQuery.of(context).size.width / 2 + 8,
            child: ElevatedButton(
              onPressed: () {
                print("Pressed!");
              },
              child: Icon(Icons.arrow_forward),
            ),
          ),
        ],
      ),*/
class VideosPage extends StatefulWidget {
  const VideosPage({super.key});

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  bool _checkedAuth = false;

  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  // check auth status when dependencies change
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAuthAndNavigate();
  }

  //detect if it became active
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAuthAndNavigate();
    }
  }

  void _checkAuthAndNavigate() {
    if (!mounted) return;

    // prevent multiple navigation attempts in the same build cycle
    if (_checkedAuth) return;
    _checkedAuth = true;

    // reset the flag after the current build cycle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkedAuth = false;

      if (!globals.isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NotLoggedIn()),
        );
      }
    });
  }

  Widget _buildVideoButton(
    String title,
    String imagePath,
    String description,
    int index,
  ) {
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
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: _width,
        height: _height,
        child: SizedBox(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 10, 73, 59),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              print("Phy 1!");
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
                const SizedBox(width: 1, height: 10),
                Image(image: AssetImage(imagePath)),
                const SizedBox(width: 1, height: 20),
                Text(
                  description,
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 199, 252, 221),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _width = 400;
  double _height = 500;
  Map<int, bool> hoveredStates = {};
  final List<Map<String, String>> courseList = [
    {
      'title': 'IB Physics HL',
      'imagePath': 'images/ib_physics_hl.jpg',
      'description':
          'Complete International Baccalaureate Higher Level physics curriculum with focus on experimental skills and data analysis.',
    },
    {
      'title': 'Kinematics',
      'imagePath': 'images/kinematics.jpg',
      'description': 'A course all about kinematics and projectile motion',
    },
    {
      'title': 'Electricity and Magnetism',
      'imagePath': 'images/electricity.jpg',
      'description':
          'Focuses on electric fields, circuits, magnetic interactions, and electromagnetic waves',
    },
    {
      'title': 'Introduction to Physics',
      'imagePath': 'images/intro_to_physics.jpg',
      'description':
          'Covers the basics of physics, including vectors, velocity, and displacement',
    },
    {
      'title': 'Grade 11 Physics',
      'imagePath': 'images/physics_11.jpg',
      'description':
          'Videos and tutorials for the Grade 11 Physics Ontario curriculum.',
    },
    {
      'title': 'Grade 12 Physics',
      'imagePath': 'images/physics_12.jpg',
      'description':
          'Videos and tutorials for the Grade 12 Physics Ontario curriculum.',
    },
    {
      'title': 'AP Physics 1',
      'imagePath': 'images/ap_courses.jpg',
      'description':
          'Preparation videos for the AP Physics 1 exam covering kinematics, Newton\'s laws, circular motion, and simple harmonic oscillators.',
    },
    {
      'title': 'AP Physics 2',
      'imagePath': 'images/ap_physics_2.png',
      'description':
          'Algebra-based physics covering fluid mechanics, thermodynamics, electricity, magnetism, optics, and quantum phenomena',
    },
  ];
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    if (!globals.isLoggedIn && !_checkedAuth) {
      _checkAuthAndNavigate();
    }
    int buttonColorShift = 10;
    bool phy_11_hovered = false;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
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
              );
            },
          ),
        ),
      ),
    );
  }
}
