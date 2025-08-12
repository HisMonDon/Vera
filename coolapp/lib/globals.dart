library globals;

import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/electricity_and_magnetism.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/kinematics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/momentum_and_collisions.dart';
import 'package:coolapp/views/pages/videos/video_pages/courses_page.dart';
import 'package:flutter/widgets.dart';

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
    'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/testVideo.mp4';
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
  'Courses',
];
List<dynamic> redirectExplore = [
  Kinematics(),
  ElectricityAndMagnetism(), // change this later
  ElectricityAndMagnetism(),
  MomentumAndCollisions(),
  CoursePage(),
];
List<Map<String, dynamic>> videoOfTheDay = [
  {
    'videoLink':
        'https://raw.githubusercontent.com/HisMonDon/Vera_Videos/main/videos/intro_to_physics/vectors%20vs%20scalars.mp4',
    'videoTitle': 'Intro To Physics: Vectors and Scalars',
    'thumbnailColor': Color.fromARGB(255, 0, 0, 0),
  },
];
int videoOfTheDayIndex = 0;
