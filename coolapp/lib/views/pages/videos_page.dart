import 'package:coolapp/views/pages/locked_page.dart';
import 'package:coolapp/views/pages/paid_videos.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart';

class VideosPage extends StatelessWidget {
  const VideosPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (loggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PaidVideos()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LockedPage()),
        );
      }
    });

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
