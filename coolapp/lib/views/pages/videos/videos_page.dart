import 'package:coolapp/views/pages/videos/free_videos.dart';
import 'package:coolapp/views/pages/videos/locked_page.dart';
import 'package:coolapp/views/pages/videos/not_logged_in.dart';
import 'package:coolapp/views/pages/videos/paid_videos.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  //put this in checkAuthAndNavigate if not working
  /*
if mounted:
if (globals.isLoggedIn) {
          if (globals.isPremium || globals.isAdmin) {
            //careful abt the isadmin part ill add this for now
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PaidVideos()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => FreeVideos()),
            );
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NotLoggedIn()),
          );
        }
      }
    });
  }
  */
  void _checkAuthAndNavigate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (!globals.isLoggedIn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NotLoggedIn()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                    borderRadius: BorderRadius.circular(12), //12 pixels
                  ),
                ),
                SizedBox(width: 2, height: 20),
              ],
            ),
          ),
          Positioned(
            bottom:
                28, //bottom should be the sizedbox height + container height/8
            right: MediaQuery.of(context).size.width / 2 + 8,
            child: ElevatedButton(
              onPressed: () {
                print("Pressed!");
              },
              child: Icon(Icons.arrow_back),
            ),
          ),
          Positioned(
            bottom:
                28, //bottom should be the sizedbox height + container height/8
            left: MediaQuery.of(context).size.width / 2 + 8,
            child: ElevatedButton(
              onPressed: () {
                print("Pressed!");
              },
              child: Icon(Icons.arrow_forward),
            ),
          ),
        ],
      ),
    ); //loading
  }
}
