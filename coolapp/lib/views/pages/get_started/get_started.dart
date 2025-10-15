import 'package:flutter/material.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:coolapp/globals.dart' as globals;
//import 'package:video_thumbnail/video_thumbnail.dart'; perchance use this for later purposes if current extractvideoimage still doesnt support ios or android in future?
//import 'package:media_kit_video/media_kit_video.dart';
//import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutThisAppPage extends StatelessWidget {
  AboutThisAppPage({super.key});
  final List<Map<String, String>> instructorList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TimedAppBar(),
      //body:
    ); //rememrber appbar
  }
}
