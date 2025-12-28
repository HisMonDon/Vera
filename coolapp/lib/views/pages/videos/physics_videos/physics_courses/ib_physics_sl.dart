import 'package:auto_size_text/auto_size_text.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/dynamics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/electricity_and_magnetism.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/harmonics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/intro_to_physics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/kinematics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/momentum_and_collisions.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/thermal_physics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/work_and_energy.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';

class IbPhysicsSl extends StatefulWidget {
  const IbPhysicsSl({super.key});

  @override
  State<IbPhysicsSl> createState() => _IbPhysicsSlState();
}

class _IbPhysicsSlState extends State<IbPhysicsSl> {
  final List<Map<String, dynamic>> videosList = [
    {
      'title': 'Unit 1: Intro to Physics',
      'description':
          'Core concepts, measurements, uncertainties, vectors, and scalars.',
      'videoPage': const IntroToPhysics(),
    },
    {
      'title': 'Unit 2: Kinematics',
      'description': 'The study of motion in one and two dimensions.',
      'videoPage': const Kinematics(),
    },
    {
      'title': 'Unit 3: Dynamics',
      'description': 'Forces, Newton\'s laws, and their application to motion.',
      'videoPage': const Dynamics(),
    },
    {
      'title': 'Unit 4: Work and Energy',
      'description':
          'Energy conservation, work, power, and efficiency in physical systems.',
      'videoPage': const WorkAndEnergy(),
    },
    {
      'title': 'Unit 5: Momentum and Collisions',
      'description':
          'Impulse, momentum conservation, and analyzing different types of collisions.',
      'videoPage': const MomentumAndCollisions(),
    },
    {
      'title': 'Unit 6: Harmonics and Waves',
      'description':
          'Oscillations, waves, and the principles of simple harmonic motion.',
      'videoPage': const Harmonics(),
    },
    {
      'title': 'Unit 7: Thermal Physics',
      'description':
          'Heat, temperature, thermodynamics, and the behavior of gases.',
      'videoPage': const ThermalPhysics(),
    },
    {
      'title': 'Unit 8: Electricity and Magnetism',
      'description':
          'Electric circuits, magnetic fields, and electromagnetic induction.',
      'videoPage': const ElectricityAndMagnetism(),
    },
  ];

  Map<int, bool> hoveredStates = {};

  @override
  Widget build(BuildContext context) {
    globals.courseTitle = 'IB Physics SL';
    return Scaffold(
      appBar: const TimedAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCourseHeader(),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: videosList.length,
                itemBuilder: (context, index) {
                  final video = videosList[index];
                  return _buildTopicButton(
                    title: video['title'] ?? '',
                    description: video['description'] ?? '',
                    index: index,
                    videoPage: video['videoPage']!,
                  );
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Return to Courses"),
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 167, 198, 131),
                    foregroundColor: const Color.fromARGB(255, 15, 48, 40),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 18, 59, 49),
            Color.fromARGB(214, 10, 97, 80),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Icon(Icons.school, color: Colors.white, size: 40),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  globals.courseTitle,
                  style: GoogleFonts.mPlus1(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'A comprehensive study of core physics for the International Baccalaureate SL program.',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicButton({
    required String title,
    required String description,
    required int index,
    required Widget videoPage,
  }) {
    bool isHovered = hoveredStates[index] ?? false;

    return MouseRegion(
      onEnter: (_) => setState(() => hoveredStates[index] = true),
      onExit: (_) => setState(() => hoveredStates[index] = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => videoPage),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isHovered
                  ? const Color.fromARGB(255, 8, 77, 63)
                  : const Color.fromARGB(255, 8, 83, 68),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isHovered
                    ? const Color.fromARGB(255, 167, 198, 131)
                    : Colors.transparent,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isHovered ? 0.2 : 0.1),
                  blurRadius: isHovered ? 8 : 4,
                  offset: isHovered ? const Offset(0, 4) : const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        title,
                        style: GoogleFonts.montserrat(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 204, 247, 227),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
