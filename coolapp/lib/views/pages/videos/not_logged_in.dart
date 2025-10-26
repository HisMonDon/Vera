import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/globals.dart' as global;
import 'package:widget_mask/widget_mask.dart';

class NotLoggedIn extends StatelessWidget {
  const NotLoggedIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TimedAppBar(),
      backgroundColor: Color.fromARGB(255, 4, 34, 26),
      body: Stack(
        children: [
          Image.asset(
            'images/locked_screen_blurred.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 500,
                  width: 1500,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 27, 88, 73),
                        Color.fromARGB(255, 3, 54, 44),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      'Content Locked!',
                      style: GoogleFonts.mPlus1(
                        fontSize: 80,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        decoration: TextDecoration.none,
                      ),
                      maxLines: 1,
                    ),
                    WidgetMask(
                      blendMode: BlendMode.srcATop,
                      childSaveLayer: true,
                      mask: Image(
                        image: AssetImage('images/text_background.jpg'),
                        fit: BoxFit.cover,
                      ),
                      child: AutoSizeText(
                        'Please create a FREE account or log in to access UNLIMITED free videos.',
                        style: GoogleFonts.mPlus1(
                          fontSize: 40,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          decoration: TextDecoration.none,
                        ),
                        maxLines: 1,
                      ),
                    ),

                    SizedBox(height: 20),
                    Icon(Icons.lock, size: 150, color: Colors.white),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        global.selectedIndex = 1;

                        Navigator.of(
                          //basaiclly clears the stack very useful especially for home page
                          context,
                          rootNavigator: true,
                        ).pushNamedAndRemoveUntil(
                          '/',
                          (route) => false,
                          arguments: 1,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Color.fromARGB(255, 117, 184, 115),
                        foregroundColor: Colors.white,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 5),
                          Text(
                            'Login or Sign Up',
                            style: GoogleFonts.mPlus1(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
