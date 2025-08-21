import 'package:auto_size_text/auto_size_text.dart';
import 'package:coolapp/views/pages/videos/not_logged_in.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/dynamics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/electricity_and_magnetism.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/intro_to_physics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/kinematics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/momentum_and_collisions.dart';
import 'package:coolapp/views/pages/videos/video_pages/courses_page.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';
import 'package:animations/animations.dart';

class TopicsPage extends StatefulWidget {
  const TopicsPage({super.key});

  @override
  State<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  bool _checkedAuth = false;
  Widget _combineButtons() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color.fromARGB(255, 15, 48, 40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButtons(
            icon: Icons.arrow_back_rounded,
            label: "Courses",
            isEnabled: true,
          ),
          SizedBox(width: 16),
          Container(height: 30, width: 1, color: Colors.white),
          SizedBox(width: 16),
          _buildButtons(
            icon: Icons.arrow_forward_rounded,
            label: "Next",

            isEnabled: false,
          ),
        ],
      ),
    );
  }

  Widget _buildButtons({
    required IconData icon, // "left" or "right"
    required String label,
    required bool isEnabled,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled
            ? Color.fromARGB(255, 15, 118, 110)
            : const Color.fromARGB(255, 238, 238, 238),
        foregroundColor: isEnabled
            ? Colors.white
            : const Color.fromARGB(255, 158, 158, 158),
        disabledBackgroundColor: const Color.fromARGB(255, 238, 238, 238),
        disabledForegroundColor: const Color.fromARGB(255, 158, 158, 158),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        textStyle: TextStyle(fontWeight: FontWeight.w600),
        elevation: isEnabled ? 0 : 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {
        if (isEnabled) {
          print("Backwards Pressed");
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 200),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const CoursePage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: animation.drive(
                        Tween(begin: const Offset(-1, 0), end: Offset.zero),
                      ),
                      child: child,
                    );
                  },
            ),
          );
        }
      },
    );
  }

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
    bool isHovered = hoveredStates[index] ?? false;
    return MouseRegion(
      onEnter: (_) => setState(() => hoveredStates[index] = true),
      onExit: (_) => setState(() => hoveredStates[index] = false),
      child: AnimatedContainer(
        height: 20,
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: isHovered
                  ? Color(0xFF0A4D3B).withOpacity(0.3)
                  : Colors.black.withOpacity(0.15),
              blurRadius: isHovered ? 12 : 8,
              offset: isHovered ? Offset(0, 6) : Offset(0, 4),
              spreadRadius: isHovered ? 1 : 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => videoPage),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isHovered
                      ? [Color(0xFF0A6150), Color(0xFF073D33)]
                      : [Color(0xFF084D3F), Color(0xFF052E27)],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      height: 2,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 20, 175, 77),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    ),
                  ),
                  SizedBox(height: 16),

                  Text(
                    description,
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      color: Color(0xFFCCF7E3),
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Spacer(),

                  Container(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.play_circle_outline, size: 18),
                      label: Text("Explore Units"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 167, 198, 131),
                        foregroundColor: Color.fromARGB(255, 15, 48, 40),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        textStyle: TextStyle(fontWeight: FontWeight.w600),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => videoPage),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Map<int, bool> hoveredStates = {};
  final List<Map<String, dynamic>> courseList = [
    {
      'title': 'Introduction to Physics',
      'imagePath': 'images/intro_to_physics.jpg',
      'description':
          'Short topic explaining the introduction to physics, including vectors, velocity, and displacement',
      'videoPage': IntroToPhysics(),
    },
    {
      'title': 'Kinematics',
      'imagePath': 'images/kinematics.jpg',
      'description':
          'Projectile Motion, Kinematics formulae, Movement of objects',
      'videoPage': Kinematics(),
    },
    {
      'title': 'Electricity and Magnetism',
      'imagePath': 'images/electricity.jpg',
      'description':
          'Electric fields, circuits, magnetic interactions, and electromagnetic waves',
      'videoPage': ElectricityAndMagnetism(),
    },
    {
      'title': 'Momentum and Collisions',
      'imagePath': 'images/momentum.jpg',
      'description':
          'Momentum, elastic and non-elastic collisions, and impulse',
      'videoPage': MomentumAndCollisions(),
    },
    {
      'title': 'Forces and Dynamics',
      'imagePath': 'images/dynamics.jpg',
      'description':
          "Newton's Laws, Introduction to forces, Free Body Diagrams",
      'videoPage': Dynamics(),
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
      appBar: TimedAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(
                255,
                146,
                243,
                198,
              ).withOpacity(0.08), // Very light green tint
              Color.fromARGB(255, 209, 250, 229).withOpacity(0.04),
            ],
          ),
        ),
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, top: 16, bottom: 20),
                    child: Text(
                      'Physics Topics and Subfields',
                      style: GoogleFonts.mPlus1(fontSize: 40),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 500,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.94,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final course = courseList[index];
                      return _buildVideoButton(
                        course['title'] ?? '',
                        course['imagePath'] ?? '',
                        course['description'] ?? '',
                        index,
                        course['videoPage']!,
                      );
                    }, childCount: courseList.length),
                  ),
                ),
              ],
            ),

            Positioned(
              bottom: 20,
              left:
                  MediaQuery.of(context).size.width / 2 -
                  125, //change this when dealing with button
              child: _combineButtons(),
            ),
          ],
        ),
      ),
    );
  }
}
