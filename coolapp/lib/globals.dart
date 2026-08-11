library;

import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/dynamics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/harmonics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/kinematics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/momentum_and_collisions.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/work_and_energy.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
//import 'package:coolapp/views/pages/videos/video_pages/courses_page.dart';
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
    'curriculumKey': 'free_body_diagrams',
    'videoLink':
        'https://pub-56767059a1844d06818006869a91df08.r2.dev/dynamics/free_body_diagrams.mp4',
    'videoTitle': 'Free Body Diagrams',
    'videoUnit': 'Dynamics',
    'covered':
        'How to identify forces, choose an object of interest, and draw clear free-body diagrams for motion problems.',
    'prerequisites':
        'Review Newton’s laws, force units, and basic vector directions.',
    'thumbnailColor': Color.fromARGB(
      255,
      0,
      0,
      0,
    ), //bc I will be generating thumbnail from my code
  },
  {
    'curriculumKey': 'kinematics_formulae',
    'videoLink':
        'https://pub-56767059a1844d06818006869a91df08.r2.dev/Kinematics%202D%20Part%202.mp4',
    'videoTitle': 'Kinematics Formulae',
    'videoUnit': 'Kinematics',
    'covered':
        'The kinematic equations, when each one applies, and how to select known and unknown quantities in two-dimensional motion.',
    'prerequisites':
        'Be comfortable with displacement, velocity, acceleration, and rearranging algebraic equations.',
    'thumbnailColor': Color.fromARGB(
      255,
      0,
      0,
      0,
    ), //bc I will be generating thumbnail from my code
  },
  {
    'curriculumKey': 'application_of_kinematics',
    'videoLink':
        'https://pub-56767059a1844d06818006869a91df08.r2.dev/Kinematics%202D%20Part%203.mp4',
    'videoTitle': 'Application of Kinematics',
    'videoUnit': 'Kinematics',
    'covered':
        'A worked kinematics problem using vectors, components, and the appropriate motion equations.',
    'prerequisites':
        'Review the kinematic equations, vector components, and basic trigonometry.',
    'thumbnailColor': Color.fromARGB(
      255,
      24,
      78,
      65,
    ), //bc I will be generating thumbnail from my code
  },
  {
    'curriculumKey': 'momentum_in_2d',
    'videoLink':
        'https://pub-56767059a1844d06818006869a91df08.r2.dev/momentum_and_collisions/Momentum%20in%202D.mp4',
    'videoTitle': 'Momentum in 2D',
    'videoUnit': 'Momentum and Collisions',
    'covered':
        'How to apply conservation of momentum in two dimensions by resolving momentum into horizontal and vertical components.',
    'prerequisites':
        'Know momentum, vector components, and basic trigonometry.',
    'thumbnailColor': Color.fromARGB(
      255,
      24,
      78,
      65,
    ), //bc I will be generating thumbnail from my code
  },
  {
    'curriculumKey': 'springs_and_conservation_of_energy',
    'videoLink':
        'https://pub-56767059a1844d06818006869a91df08.r2.dev/oscillations/Unit%203%20Springs%20and%20Conservation%20of%20Energy.mp4',
    'videoTitle': 'Springs and Conservation of Energy',
    'videoUnit': 'Oscillations',
    'covered':
        'Energy storage in springs and how kinetic, elastic potential, and gravitational potential energy are conserved in mass-spring systems.',
    'prerequisites':
        'Review Hooke’s law, kinetic energy, gravitational potential energy, and algebra.',
    'thumbnailColor': Color.fromARGB(
      255,
      24,
      78,
      65,
    ), //bc I will be generating thumbnail from my code
  },
  {
    'curriculumKey': 'ap_physics_1_frq_2025_q4',
    'videoLink':
        'https://pub-56767059a1844d06818006869a91df08.r2.dev/2025%20AP%20Physics%201%20Solutions%20Free%20Response%20Q4%20(1080p).mp4',
    'videoTitle': '2025 AP Physics 1 Solutions Free Response Q4',
    'videoUnit': 'Fluids',
    'covered':
        'A complete AP Physics 1 free-response solution involving fluid statics, buoyancy, and clear exam-style reasoning.',
    'prerequisites':
        'Review density, pressure, buoyant force, and free-body diagrams.',
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
