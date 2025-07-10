//page that displays whenever someone isn't subscribed
import 'package:coolapp/main.dart';
import 'package:coolapp/views/pages/profile_page/profile_page.dart';
import 'package:coolapp/views/pages/videos/free_videos.dart';
import 'package:coolapp/views/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';

class NotLoggedIn extends StatelessWidget {
  const NotLoggedIn({super.key});

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
            'Content Locked! Please create an account or log in to access these videos.',
            style: GoogleFonts.montserrat(
              fontSize: 40,
              color: const Color.fromARGB(255, 255, 255, 255),
              decoration: TextDecoration.none,
            ), //starts at 50, will shrink to fit
            maxLines: 1,
          ),
          SizedBox(height: 20),
          Icon(Icons.lock, size: 150),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            child: Text(
              'Login or Sign Up',
              style: GoogleFonts.montserrat(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
