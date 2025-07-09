//page that displays whenever someone isn't subscribed
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';

class LockedPage extends StatelessWidget {
  const LockedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Vera"),
        backgroundColor: const Color.fromARGB(255, 15, 48, 40),
      ),
      backgroundColor: Color.fromARGB(255, 4, 34, 26),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoSizeText(
            'Content Locked! Please purchase premium to access these videos.',
            style: GoogleFonts.montserrat(
              fontSize: 40,
              color: const Color.fromARGB(255, 255, 255, 255),
              decoration: TextDecoration.none,
            ), //starts at 50, will shrink to fit
            maxLines: 1,
          ),
          AutoSizeText(
            //change this when i get back from class
            'All revenue from subscriptions go towards charity!',
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
    );
  }
}
