library globals;

import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/dynamics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/electricity_and_magnetism.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/harmonics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/kinematics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/momentum_and_collisions.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/work_and_energy.dart';
//import 'package:coolapp/views/pages/videos/video_pages/courses_page.dart';
import 'package:flutter/widgets.dart';

//import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
//wow
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
var pastVideos = List<String>.filled(
  5,
  '',
  growable: true,
); // <-- FIX: Initialize with 5 empty strings
List<String> explore = [
  'Kinematics',
  'Work and Energy',
  'Harmonics',
  'Momentum',
  'Forces and Dynamics',
];
List<dynamic> redirectExplore = [
  Kinematics(),
  WorkAndEnergy(), // change this later
  Harmonics(),
  MomentumAndCollisions(),
  Dynamics(),
];
List<Map<String, dynamic>> videoOfTheDay = [
  {
    'videoLink':
        'https://pub-56767059a1844d06818006869a91df08.r2.dev/dynamics/free_body_diagrams.mp4',
    'videoTitle': 'Free Body Diagrams',
    'videoUnit': 'Dynamics',
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
  {
    'videoLink':
        'https://pub-56767059a1844d06818006869a91df08.r2.dev/momentum_and_collisions/Momentum%20in%202D.mp4',
    'videoTitle': 'Momentum in 2D',
    'videoUnit': 'Momentum and Collisions',
    'thumbnailColor': Color.fromARGB(
      255,
      24,
      78,
      65,
    ), //bc I will be generating thumbnail from my code
  },
  {
    'videoLink':
        'https://pub-56767059a1844d06818006869a91df08.r2.dev/oscillations/Unit%203%20Springs%20and%20Conservation%20of%20Energy.mp4',
    'videoTitle': 'Springs and Conservation of Energy',
    'videoUnit': 'Oscillations',
    'thumbnailColor': Color.fromARGB(
      255,
      24,
      78,
      65,
    ), //bc I will be generating thumbnail from my code
  },
  {
    'videoLink':
        'https://pub-56767059a1844d06818006869a91df08.r2.dev/2025%20AP%20Physics%201%20Solutions%20Free%20Response%20Q4%20(1080p).mp4',
    'videoTitle': '2025 AP Physics 1 Solutions Free Response Q4',
    'videoUnit': 'Fluids',
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
