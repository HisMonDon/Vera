import 'package:flutter/material.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:coolapp/globals.dart' as globals;
//import 'package:video_thumbnail/video_thumbnail.dart'; perchance use this for later purposes if current extractvideoimage still doesnt support ios or android in future?
//import 'package:media_kit_video/media_kit_video.dart';
//import 'dart:io';

//import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class AboutThisAppPage extends StatelessWidget {
  AboutThisAppPage({super.key});
  final List<Map<String, String>> instructorList = [
    {
      'name': 'Chenyu Lu',
      'title': 'Founder, CEO, Lead Developer & Physics Instructor',
      'image': 'images/chenyuluPFP.png',
      'achievements':
          '• St. Robert Physics Club Executive Trainer\n• 3rd Place in the Canadian Young Physics Tournament\n• 5 On AP Physics 1, AP Chemistry, and AP Computer Science A',
    },
    {
      'name': 'Person 1',
      'title': 'Grade 11 IB Student at St.Robert CHS',
      'image': 'images/PLACEHOLDER',
      'achievements': '• a\n• b\n• c\n• d\n• e',
    },
    {
      'name': 'Person 2',
      'title': 'Grade 11 IB Student at St.Robert CHS',
      'image': 'images/PLACEHOLDER',
      'achievements': '• a\n• b\n• c\n• d\n• e',
    },
    {
      'name': 'Person 3',
      'title': 'Grade x IB Student at school PS',
      'image': 'images/PLACEHOLDER',
      'achievements': '• a\n• b\n• c\n• d\n• e',
    },
    {
      'name': 'Person 4',
      'title': 'Grade x IB Student at school name PS',
      'image': 'images/PLACEHOLDER',
      'achievements': '• a\n• b\n• c\n• d\n• e',
    },
    {
      'name': 'Person 5',
      'title': 'Grade x IB Student at school name PS',
      'image': 'images/PLACEHOLDER',
      'achievements': '• a\n• b\n• c\n• d\n• e',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TimedAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              if (kIsWeb)
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        'Vera',
                        style: GoogleFonts.mPlus1(
                          fontSize: 48.0,
                          fontWeight: FontWeight.bold,
                          color: globals.isLight
                              ? Color.fromARGB(255, 15, 48, 40)
                              : Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: globals.isLight
                              ? Color.fromARGB(255, 15, 48, 40)
                              : Color.fromARGB(255, 167, 198, 131),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Web',
                          style: GoogleFonts.montserrat(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: globals.isLight
                                ? Colors.white
                                : Color.fromARGB(255, 15, 48, 40),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              _buildChenyuLu(),
              const SizedBox(height: 48),

              _buildWhatIsVeraSection(context),
              const SizedBox(height: 48),

              _buildInstructorsSection(),
              const SizedBox(height: 48),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    globals.selectedIndex = 1;
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pushNamedAndRemoveUntil(
                      '/',
                      (route) => false,
                      arguments: 1,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 18, 59, 49),
                          Color.fromARGB(214, 10, 97, 80),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 0, 0, 0),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.person_add_alt_1,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Click here to create a FREE account!',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "2025 Chenyu Studios",
                    style: TextStyle(
                      fontSize: 10,
                      color: globals.isLight
                          ? const Color.fromARGB(255, 0, 0, 0)
                          : const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  const SizedBox(width: 3),
                  Icon(
                    Icons.copyright_sharp,
                    size: 15,
                    color: globals.isLight
                        ? const Color.fromARGB(255, 0, 0, 0)
                        : const Color.fromARGB(255, 255, 255, 255),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChenyuLu() {
    final ceo = instructorList[0];
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(73, 0, 0, 0),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 60, backgroundImage: AssetImage(ceo['image']!)),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Chenyu Lu",
                  style: GoogleFonts.mPlus1(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  ceo['title']!,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 195, 215, 181),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  ceo['achievements']!,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: const Color.fromARGB(
                      255,
                      246,
                      248,
                      247,
                    ).withOpacity(0.9),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatIsVeraSection(BuildContext context) {
    return Column(
      children: [
        Text(
          "What is Vera?",
          style: GoogleFonts.mPlus1(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: globals.isLight
                ? const Color.fromARGB(255, 7, 77, 53)
                : const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        const SizedBox(height: 1),
        Text(
          "Vera is a revolutionary video platform made with Flutter and Dart dedicated to making learning physics accessible and easy for everyone. From high school curricula to advanced AP topics, our student-led video lessons break down physics concepts into easy-to-understand modules, with many tips and tricks to help you score well in your school physics courses. Join us for free to unlock your potential and master physics!",
          textAlign: TextAlign.center,
          style: GoogleFonts.mPlus1(
            fontSize: 20,
            color: globals.isLight
                ? const Color.fromARGB(221, 0, 0, 0)
                : const Color.fromARGB(221, 255, 255, 255),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 400,
              height: 200,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 18, 59, 49),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: const Center(child: Text('Image 1')),
            ),
            const SizedBox(width: 16),
            Container(
              width: 400,
              height: 200,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 18, 59, 49),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: const Center(child: Text('Image 2')),
            ),
            const SizedBox(width: 16),
            Container(
              width: 400,
              height: 200,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 18, 59, 49),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: const Center(child: Text('Image 3')),
            ),
            const SizedBox(width: 16),
            /*Container(
              width: 400,
              height: 200,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 18, 59, 49),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: const Center(child: Text('Image 4')),
            ),*/
          ],
        ),
      ],
    );
  }

  Widget _buildInstructorsSection() {
    return Column(
      children: [
        Text(
          "Meet the Instructors",
          style: GoogleFonts.mPlus1(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: globals.isLight
                ? const Color.fromARGB(255, 7, 77, 53)
                : Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 24,
          runSpacing: 24,
          alignment: WrapAlignment.center,
          children: instructorList.skip(1).map((instructor) {
            return _buildInstructorCard(instructor);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInstructorCard(Map<String, String> instructor) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: globals.isLight
            ? Colors.white
            : const Color.fromARGB(255, 15, 48, 40),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            //backgroundImage: AssetImage(instructor['image']!),
            backgroundColor: Color.fromARGB(255, 195, 215, 181),
          ),
          const SizedBox(height: 16),
          Text(
            instructor['name']!,
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: globals.isLight
                  ? const Color.fromARGB(255, 7, 77, 53)
                  : Colors.white,
            ),
          ),
          Text(
            instructor['title']!,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: globals.isLight ? Colors.grey[600] : Colors.grey[400],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            instructor['achievements']!,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: globals.isLight ? Colors.black54 : Colors.white60,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
