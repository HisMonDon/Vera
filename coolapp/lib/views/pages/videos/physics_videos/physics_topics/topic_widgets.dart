import 'package:auto_size_text/auto_size_text.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/electricity_and_magnetism.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/intro_to_physics.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/views/pages/videos/video_player.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/kinematics.dart';

class CourseWidgets {
  /* Widgets:
  - buildVideo button (can lowk get from any of the course pages)
  - buildCourseHeader(will take parameter globals.courseTitle, might check later if i need to reset in the main page)
  - buildBackButton (back button that returns.)
    =======================================================================
  - buildVideo parameters (everything from before)
   */
  static Widget _buildVideoButton({
    required String title,
    required String description,
    required int index,
    required Widget videoPage,
    required List<Map<String, dynamic>> videosList,
    required String videoLink,
    required BuildContext context,
    required Map<int, bool> hoveredStates,
    required Function(int index, bool isHovered) onHoverChanged, //setState
    //String imagePath,
  }) {
    bool isCompleted = false; //later will implement completion tracking
    bool isHovered = hoveredStates[index] ?? false;

    return MouseRegion(
      onEnter: (_) => onHoverChanged(index, true),
      onExit: (_) => onHoverChanged(index, true),
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
}

Widget _buildBackButton({required BuildContext context}) {
  return Center(
    child: ElevatedButton.icon(
      icon: Icon(Icons.arrow_back),
      label: Text("Return to Topics"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 167, 198, 131),
        foregroundColor: const Color.fromARGB(255, 15, 48, 40),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {
        globals.courseTitle = '';
        Navigator.of(context).pop();
      },
    ),
  );
}
