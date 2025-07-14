import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/globals.dart' as global;

class NotLoggedIn extends StatelessWidget {
  const NotLoggedIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 4, 34, 26),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AutoSizeText(
              'Content Locked!',
              style: GoogleFonts.montserrat(
                fontSize: 60,
                color: const Color.fromARGB(255, 255, 255, 255),
                decoration: TextDecoration.none,
              ),
              maxLines: 1,
            ),
            AutoSizeText(
              'Please create an account or log in to access these videos.',
              style: GoogleFonts.montserrat(
                fontSize: 30,
                color: const Color.fromARGB(255, 255, 255, 255),
                decoration: TextDecoration.none,
              ),
              maxLines: 1,
            ),
            SizedBox(height: 20),
            Icon(Icons.lock, size: 150),
            ElevatedButton(
              onPressed: () {
                // Update the selected index
                global.selectedIndex = 1;

                // Navigate to widget tree with profile tab selected
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamedAndRemoveUntil(
                  '/widgetTree',
                  (route) => false,
                  arguments: 1,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 28, 150, 109),
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Login or Sign Up',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
