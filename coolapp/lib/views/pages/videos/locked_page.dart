//page that displays whenever someone isn't subscribed
import 'package:coolapp/main.dart';
import 'package:coolapp/views/pages/videos/free_videos.dart';
import 'package:coolapp/views/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:widget_mask/widget_mask.dart';

class LockedPage extends StatelessWidget {
  const LockedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 4, 34, 26),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FreeVideos()),
          );
        },
        child: Icon(Icons.arrow_back),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            WidgetMask(
              blendMode: BlendMode.srcATop,
              childSaveLayer: true,
              mask: Image(
                image: AssetImage('images/text_background.jpg'),
                fit: BoxFit.cover,
              ),
              child: AutoSizeText(
                'Content Locked! Please purchase premium to access these videos.',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 100,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  decoration: TextDecoration.none,
                ),
                maxLines: 1,
              ),
            ),

            AutoSizeText(
              //change this when i get back from class
              'All revenue from subscriptions go towards the SickKids Foundation!',
              style: GoogleFonts.openSans(
                fontSize: 30,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
              maxLines: 1,
            ),
            SizedBox(height: 20),
            Icon(Icons.lock, size: 150),
          ],
        ),
      ),
    );
  }
}
