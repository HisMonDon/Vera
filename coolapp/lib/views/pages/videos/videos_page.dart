import 'package:coolapp/services/auth_service.dart';
import 'package:coolapp/views/pages/videos/free_videos.dart';
import 'package:coolapp/views/pages/videos/locked_page.dart';
import 'package:coolapp/views/pages/videos/not_logged_in.dart';
import 'package:coolapp/views/pages/videos/paid_videos.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  bool _checkedAuth = false;

  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  // check auth status when dependencies change
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAuthAndNavigate();
  }

  //detect if it became active
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAuthAndNavigate();
    }
  }

  void _checkAuthAndNavigate() {
    if (!mounted) return;

    // prevent multiple navigation attempts in the same build cycle
    if (_checkedAuth) return;
    _checkedAuth = true;

    // reset the flag after the current build cycle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkedAuth = false;

      if (!globals.isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NotLoggedIn()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    if (!globals.isLoggedIn && !_checkedAuth) {
      _checkAuthAndNavigate();
    }
    int buttonColorShift = 10;
    bool phy_11_hovered = false;
    double _width = 400;
    double _height = 500;
    return Scaffold(
      body:
          /* Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 180,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 18, 90, 72),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          Positioned(
            bottom: 28,
            right: MediaQuery.of(context).size.width / 2 + 8,
            child: ElevatedButton(
              onPressed: () {
                print("Pressed!");
              },
              child: Icon(Icons.arrow_back),
            ),
          ),
          Positioned(
            bottom: 28,
            left: MediaQuery.of(context).size.width / 2 + 8,
            child: ElevatedButton(
              onPressed: () {
                print("Pressed!");
              },
              child: Icon(Icons.arrow_forward),
            ),
          ),
        ],
      ),*/
          Stack(
            children: [
              Positioned(
                left: 40,
                top: 40,
                child: MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _width = 500;
                      _height = 600;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _width = 400;
                      _height = 500;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: _width,
                    height: _height,
                    child: SizedBox(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            10,
                            73,
                            59,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          print("Phy 1!");
                        },
                        /*onHover: (value) {
                              buttonColorShift += 10;
                              phy_11_hovered = true;
                              print("wow"!);
                            },*/
                        child: Column(
                          children: [
                            const SizedBox(width: 1, height: 30),
                            Text(
                              'Grade 11 Physics',
                              maxLines: 1,
                              style: GoogleFonts.montserrat(
                                fontSize: 30,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            const SizedBox(width: 1, height: 10),
                            Image(image: AssetImage('images/physics_11.jpg')),
                            const SizedBox(width: 1, height: 20),
                            Text(
                              "Videos and tutorials for the Grade 11 Physics Ontario curriculum.\n\nCovers introduction to Phyics as well.",
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                color: const Color.fromARGB(255, 199, 252, 221),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
