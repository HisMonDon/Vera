library globals;

import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/dynamics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/electricity_and_magnetism.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/kinematics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/momentum_and_collisions.dart';
//import 'package:coolapp/views/pages/videos/video_pages/courses_page.dart';
import 'package:flutter/widgets.dart';

//import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

bool isPremium = false;
bool isLoggedIn = false;
bool isAdmin = false;
int selectedIndex = 2;
bool isNavbarShowing = false;
int videosPageNumber = 1;
String userName = '';
String welcomeText = 'Welcome!';
String userId = '';
String idToken = '';
String motivationalMessage = '';
String videoLink =
    'https://pub-56767059a1844d06818006869a91df08.r2.dev/Holder%20Video%20(Video%20not%20Released%20Yet).mp4';
String topicTitle = ''; //stack on each other, start from course (ykwim)
String unitTitle = '';
String courseTitle = '';
String nextVideoTitle =
    'last_one'; //check if it is named "last_one", if it is, then there will be no next video
dynamic nextVideoPage;
var pastVideos = List<String>.filled(5, '');
List<String> explore = [
  'Kinematics',
  'Electricity',
  'Magnetism',
  'Momentum',
  'Forces and Dynamics',
];
List<dynamic> redirectExplore = [
  Kinematics(),
  ElectricityAndMagnetism(), // change this later
  ElectricityAndMagnetism(),
  MomentumAndCollisions(),
  Dynamics(),
];
List<Map<String, dynamic>> videoOfTheDay = [
  {
    'videoLink':
        'https://pub-56767059a1844d06818006869a91df08.r2.dev/vectors%20vs%20scalars.mp4',
    'videoTitle': 'Vectors and Scalars',
    'videoUnit': 'Intro To Physics',
    'thumbnailColor': Color.fromARGB(
      255,
      0,
      0,
      0,
    ), //bc I will be generating thumbnail from my code
  },
  {
    'videoLink':
        'https://pub-56767059a1844d06818006869a91df08.r2.dev/Kinematics%202D%20Part%202.mp4',
    'videoTitle': 'Kinematics Formulae',
    'videoUnit': 'Kinematics',
    'thumbnailColor': Color.fromARGB(
      255,
      0,
      0,
      0,
    ), //bc I will be generating thumbnail from my code
  },

  {
    'videoLink':
        'https://pub-56767059a1844d06818006869a91df08.r2.dev/Kinematics%202D%20Part%203.mp4',
    'videoTitle': 'Application of Kinematics',
    'videoUnit': 'Kinematics',
    'thumbnailColor': Color.fromARGB(
      255,
      24,
      78,
      65,
    ), //bc I will be generating thumbnail from my code
  },
];
int videoOfTheDayIndex = 0;
bool isLight = false;
String errorMessage = '';
