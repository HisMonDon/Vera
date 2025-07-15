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

  void _checkAuthAndNavigate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
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

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    ); //loading
  }
}
