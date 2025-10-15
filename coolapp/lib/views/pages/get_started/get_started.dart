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
  final List<Map<String, String>> instructorList = [
    {
      'name': 'Chenyu Lu',
      'title': 'Founder, CEO, Lead Developer & Physics Instructor',
      'image': 'images/PLACEHOLDER',
      'achievements':
          '• Creator of Vera\n• St.Robert Physics Executive Trainer\n• Placed Third Nationally for the Canadian Young Physics Tournament\n• 5 On AP Physics 1, AP Chemistry, and AP Computer Science A\n• Grade 11 IB Student at St.Robert CHS',
    },
    {
      'name': 'Person 1',
      'title': 'Grade 11 IB Student at St.Robert CHS',
      'image': 'images/PLACEHOLDER',
      'achievements': '• a\n• b\n• c\n• d\n• e',
    },
    {
      'name': 'Person 2',
      'title': 'Grade 11 IB Student at St.Robert CHS',
      'image': 'images/PLACEHOLDER',
      'achievements': '• a\n• b\n• c\n• d\n• e',
    },
    {
      'name': 'Person 3',
      'title': 'Grade 11 IB Student at St.Robert CHS',
      'image': 'images/PLACEHOLDER',
      'achievements': '• a\n• b\n• c\n• d\n• e',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TimedAppBar(),
      //body:
    ); //rememrber appbar
  }

  Widget _buildChenyuLu() {
    final ceo = instructorList[0];
    return FadeInDown(
      duration: const Duration(milliseconds: 500),
      child: Container(padding: EdgeInsets.all(20)),
    );
  }
}
