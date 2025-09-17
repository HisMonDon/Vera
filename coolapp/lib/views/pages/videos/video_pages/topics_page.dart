import 'package:auto_size_text/auto_size_text.dart';
import 'package:coolapp/views/pages/videos/not_logged_in.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/dynamics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/electricity_and_magnetism.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/electrostatics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/fluids.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/harmonics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/intro_to_physics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/kinematics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/momentum_and_collisions.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/optics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/other.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/quantum_mechanics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/rotational_motion.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/thermal_physics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/work_and_energy.dart';
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
    globals.courseTitle = '';
    return ElevatedButton.icon(
      icon: Icon(icon, size: 20, color: const Color.fromARGB(255, 15, 48, 40)),
      label: Text(
        label,
        style: TextStyle(color: const Color.fromARGB(255, 15, 48, 40)),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled
            ? Color.fromARGB(255, 167, 198, 131)
            : const Color.fromARGB(255, 238, 238, 238),
        foregroundColor: isEnabled
            ? Colors.white
            : const Color.fromARGB(255, 158, 158, 158),
        disabledBackgroundColor: const Color.fromARGB(255, 238, 238, 238),
        disabledForegroundColor: const Color.fromARGB(255, 158, 158, 158),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        textStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: const Color.fromARGB(255, 15, 48, 40),
        ),

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
                        color: Color.fromARGB(255, 167, 198, 131),
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
  List<Map<String, dynamic>> courseList = [
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
          'Motion analysis, explore concepts such as displacement, velocity, acceleration, and time, and how to apply kinematic equations to describe motion in one and two dimensions.',
      'videoPage': Kinematics(),
    },

    {
      'title': 'Forces and Dynamics',
      'imagePath': 'images/dynamics.jpg',
      'description':
          "Examine how forces influence motion through Newton's laws of motion. Concepts such as mass, weight, friction, tension, and normal force, learn how to analyze interactions between objects, use Free Body Diagrams",
      'videoPage': Dynamics(),
    },

    {
      'title': 'Work and Energy',
      'imagePath': 'images/work_and_energy.jpg',
      'description':
          'Calculate work done by forces, analyze kinetic and potential energy transformations, and apply conservation of energy to solve complex physics problems',
      'videoPage': WorkAndEnergy(),
    },
    {
      'title': 'Electricity and Magnetism',
      'imagePath': 'images/electricity.jpg',
      'description':
          'Principles of electric and magnetic phenomena, right hand rule, exploring concepts such as electric charge, electric fields, potential difference, current, resistance, and circuits. Extend this understanding to magnetic fields, electromagnetic induction, and the relationship between electricity and magnetism',
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
      'title': 'Optics',
      'imagePath': 'images/optics.png',
      'description':
          'Mirror and lens equations, analyze optical instruments, understand diffraction patterns and interference phenomena. Calculate critical angles for total internal reflection and solve problems involving polarization.',
      'videoPage': Optics(),
    },
    {
      'title': 'Fluids',
      'imagePath': 'images/fluids.png',
      'description':
          'Hydrostatic pressure at different depths, analyze buoyant forces using Archimedes\' principle, apply Bernoulli\'s equation to fluid flow problems, and understand viscosity effects in real-world applications like blood flow and aerodynamics.',
      'videoPage': Fluids(),
    },
    {
      'title': 'Harmonics',
      'imagePath': 'images/harmonics.jpg',
      'description':
          'Analyze simple harmonic motion equations, calculate periods of pendulums and spring systems, understand resonance conditions, solve damped oscillation problems, and model coupled oscillators in mechanical and electrical systems.',
      'videoPage': Harmonics(),
    },
    {
      'title': 'Electrostatics',
      'imagePath': 'images/electrostatics.png',
      'description':
          'Electric fields and forces using Coulomb\'s law, analyze charge distributions, determine electric potential and energy, solve capacitor problems, and understand electric field mapping through equipotential surfaces.',
      'videoPage': Electrostatics(),
    },
    {
      'title': 'Quantum Mechanics',
      'imagePath': 'images/quantum_mechanics.jpg',
      'description':
          'Photoelectric effect, calculate de Broglie wavelengths, apply Heisenberg\'s uncertainty principle, analyze quantum tunneling scenarios, and explore probability distributions in atomic models and wave functions.',
      'videoPage': QuantumMechanics(),
    },
    {
      'title': 'Rotational Motion',
      'imagePath': 'images/rotational_motion.jpg',
      'description':
          'Angular velocity, torque calculations, moment of inertia for different shapes, angular momentum conservation, and rotational kinetic energy. Learn to solve problems with rotating objects and analyze gyroscopic motion.',
      'videoPage': RotationalMotion(),
    },
    {
      'title': 'Thermal Physics',
      'imagePath': 'images/thermal_physics.jpg',
      'description':
          'Study of heat, temperature, and thermodynamic laws. Calculate heat capacity, analyze phase changes, understand entropy, and solve problems involving thermodynamic cycles and efficiency.',
      'videoPage': ThermalPhysics(),
    },
    {
      'title': 'Other Physics Topics',
      'imagePath': 'images/other.jpg',
      'description':
          'Additional physics topics including mathematical methods, measurement techniques, nuclear physics, astrophysics, and the relationship between physics and society',
      'videoPage': Other(),
    },
  ];

  List<String> sortBy = <String>[
    'Relevance',
    'Alphabetical (A-Z)',
    'Alphabetical (Z-A)',
  ];
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    String _currentSortOption = sortBy[0];
    globals.courseTitle = '';
    int buttonColorShift = 10;
    bool phy_11_hovered = false;
    if (!globals.isLoggedIn) {
      return NotLoggedIn();
    }
    void _sortCourseList(String sortOption) {
      setState(() {
        switch (sortOption) {
          case 'Alphabetical (A-Z)':
            courseList.sort(
              (a, b) => (a['title'] as String).compareTo(b['title'] as String),
            );
            break;
          case 'Alphabetical (Z-A)':
            courseList.sort(
              (a, b) => (b['title'] as String).compareTo(a['title'] as String),
            );
            break;
          case 'Relevance':
            courseList = [
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
                    'Motion analysis, explore concepts such as displacement, velocity, acceleration, and time, and how to apply kinematic equations to describe motion in one and two dimensions.',
                'videoPage': Kinematics(),
              },

              {
                'title': 'Forces and Dynamics',
                'imagePath': 'images/dynamics.jpg',
                'description':
                    "Examine how forces influence motion through Newton's laws of motion. Concepts such as mass, weight, friction, tension, and normal force, learn how to analyze interactions between objects, use Free Body Diagrams",
                'videoPage': Dynamics(),
              },

              {
                'title': 'Work and Energy',
                'imagePath': 'images/work_and_energy.jpg',
                'description':
                    'Calculate work done by forces, analyze kinetic and potential energy transformations, and apply conservation of energy to solve complex physics problems',
                'videoPage': WorkAndEnergy(),
              },
              {
                'title': 'Electricity and Magnetism',
                'imagePath': 'images/electricity.jpg',
                'description':
                    'Principles of electric and magnetic phenomena, right hand rule, exploring concepts such as electric charge, electric fields, potential difference, current, resistance, and circuits. Extend this understanding to magnetic fields, electromagnetic induction, and the relationship between electricity and magnetism',
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
                'title': 'Optics',
                'imagePath': 'images/optics.png',
                'description':
                    'Mirror and lens equations, analyze optical instruments, understand diffraction patterns and interference phenomena. Calculate critical angles for total internal reflection and solve problems involving polarization.',
                'videoPage': Optics(),
              },
              {
                'title': 'Fluids',
                'imagePath': 'images/fluids.png',
                'description':
                    'Hydrostatic pressure at different depths, analyze buoyant forces using Archimedes\' principle, apply Bernoulli\'s equation to fluid flow problems, and understand viscosity effects in real-world applications like blood flow and aerodynamics.',
                'videoPage': Fluids(),
              },
              {
                'title': 'Harmonics',
                'imagePath': 'images/harmonics.jpg',
                'description':
                    'Analyze simple harmonic motion equations, calculate periods of pendulums and spring systems, understand resonance conditions, solve damped oscillation problems, and model coupled oscillators in mechanical and electrical systems.',
                'videoPage': Harmonics(),
              },
              {
                'title': 'Electrostatics',
                'imagePath': 'images/electrostatics.png',
                'description':
                    'Electric fields and forces using Coulomb\'s law, analyze charge distributions, determine electric potential and energy, solve capacitor problems, and understand electric field mapping through equipotential surfaces.',
                'videoPage': Electrostatics(),
              },
              {
                'title': 'Quantum Mechanics',
                'imagePath': 'images/quantum_mechanics.jpg',
                'description':
                    'Photoelectric effect, calculate de Broglie wavelengths, apply Heisenberg\'s uncertainty principle, analyze quantum tunneling scenarios, and explore probability distributions in atomic models and wave functions.',
                'videoPage': QuantumMechanics(),
              },
              {
                'title': 'Rotational Motion',
                'imagePath': 'images/rotational_motion.jpg',
                'description':
                    'Angular velocity, torque calculations, moment of inertia for different shapes, angular momentum conservation, and rotational kinetic energy. Learn to solve problems with rotating objects and analyze gyroscopic motion.',
                'videoPage': RotationalMotion(),
              },
              {
                'title': 'Thermal Physics',
                'imagePath': 'images/thermal_physics.jpg',
                'description':
                    'Study of heat, temperature, and thermodynamic laws. Calculate heat capacity, analyze phase changes, understand entropy, and solve problems involving thermodynamic cycles and efficiency.',
                'videoPage': ThermalPhysics(),
              },
              {
                'title': 'Other Physics Topics',
                'imagePath': 'images/other.jpg',
                'description':
                    'Additional physics topics including mathematical methods, measurement techniques, nuclear physics, astrophysics, and the relationship between physics and society',
                'videoPage': Other(),
              },
            ];
            break;
        }
      });
    }

    return Scaffold(
      appBar: TimedAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              globals.isLight
                  ? Color.fromARGB(255, 146, 243, 198)
                  : Color.fromARGB(255, 146, 243, 198).withOpacity(0.08),
              // very light green tint
              globals.isLight
                  ? Color.fromARGB(200, 209, 250, 229)
                  : Color.fromARGB(255, 209, 250, 229).withOpacity(0.04),
            ],
          ),
        ),
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 16,
                            top: 16,
                            bottom: 20,
                          ),
                          child: Text(
                            'Physics Topics and Subfields',
                            style: GoogleFonts.mPlus1(
                              fontSize: 40,
                              color: globals.isLight
                                  ? Color.fromARGB(255, 7, 77, 53)
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 24),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color.fromARGB(255, 15, 48, 40),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                icon: Icon(
                                  Icons.sort,
                                  color: Color.fromARGB(255, 167, 198, 131),
                                ),
                                value: sortBy[0],
                                elevation: 16,
                                dropdownColor: Color.fromARGB(255, 15, 48, 40),
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                                underline: Container(
                                  height: 6,

                                  //color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String? value) {
                                  if (value == null) return;
                                  setState(() {
                                    _currentSortOption = value;
                                    _sortCourseList(value);
                                  });
                                },

                                items: sortBy.map<DropdownMenuItem<String>>((
                                  String value,
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(value),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(width: 30),
                        ],
                      ),
                    ],
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
