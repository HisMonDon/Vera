import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TopicWidgets {
  /* Widgets:
  - buildVideo button (can lowk get from any of the course pages)
  - buildCourseHeader(will take parameter globals.courseTitle, might check later if i need to reset in the main page)
  - buildBackButton (back button that returns.)
    =======================================================================
  - buildVideo parameters (everything from before)
   */
  static Widget _buildBackButton({
    required String title,
    required BuildContext context,
    required String description,
    required IconData topIcon,
    //use globals.courseTitle for course Title
  }) {
    // to go to course, we just push it back instead of actually redirecting to new widget
    String previousTitle = globals.courseTitle;
    if (globals.courseTitle == '') {
      previousTitle = 'Courses';
    }
    return Container(
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
            child: Icon(topIcon, size: 40, color: Colors.white),
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
                  Row(
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            previousTitle,
                            style: GoogleFonts.montserrat(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.label_important, color: Colors.white),
                      SizedBox(width: 10),
                      MouseRegion(
                        cursor: SystemMouseCursors
                            .click, //does nothing but looks better
                        child: Text(
                          title,
                          style: GoogleFonts.montserrat(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
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
    ); /*Center(
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Text(
              previousTitle,
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 10),
          Icon(Icons.label_important, color: Colors.white),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );*/
  }

  static Widget buildVideoButton({
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
      onExit: (_) => onHoverChanged(index, false),
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
