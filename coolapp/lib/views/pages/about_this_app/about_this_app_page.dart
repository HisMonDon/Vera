import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart';
import 'dart:typed_data';
import 'package:coolapp/views/pages/profile_page/profile_page.dart';
import 'package:coolapp/views/pages/videos/not_logged_in.dart';
import 'package:coolapp/views/pages/videos/video_player.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:widget_mask/widget_mask.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:video_thumbnail/video_thumbnail.dart'; perchance use this for later purposes if current extractvideoimage still doesnt support ios or android in future?
import 'package:media_kit/media_kit.dart';
import 'package:extract_video_frame/extract_video_frame.dart';
import 'dart:ui' as ui;
//import 'package:media_kit_video/media_kit_video.dart';
//import 'dart:io';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AboutThisAppPage extends StatelessWidget {
  const AboutThisAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TimedAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(child: Column()),
        ),
      ),
    ); //rememrber appbar
  }
}
