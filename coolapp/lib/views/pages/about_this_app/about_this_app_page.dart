import 'package:flutter/material.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:coolapp/globals.dart' as globals;
//import 'package:video_thumbnail/video_thumbnail.dart'; perchance use this for later purposes if current extractvideoimage still doesnt support ios or android in future?
import 'dart:ui' as ui;
//import 'package:media_kit_video/media_kit_video.dart';
//import 'dart:io';

import 'package:animate_do/animate_do.dart';

class AboutThisAppPage extends StatelessWidget {
  AboutThisAppPage({super.key});
  final List<dynamic> tutorialList = [
    {Image(image: AssetImage('images_tutorial/vera_tutorial_one.jpg'))},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TimedAppBar(),
      body: ListView.builder(
        itemCount: tutorialList.length,
        itemBuilder: (context, index) {
          if (index.isEven) {
            return FadeInLeft(
              delay: Duration(milliseconds: 100 * index),
              duration: Duration(milliseconds: 500),
              child: buildListItem(index),
            );
          } else {
            return FadeInRight(
              delay: Duration(milliseconds: 100 * index),
              duration: Duration(milliseconds: 500),
              child: buildListItem(index),
            );
          }
        },
      ),
    ); //rememrber appbar
  }

  Widget buildListItem(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4.0,
        child: ListTile(
          title: Text('box'),
          subtitle: tutorialList[index],
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }
}
