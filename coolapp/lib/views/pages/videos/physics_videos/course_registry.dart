import 'package:flutter/material.dart' show immutable;

/// Single source of truth for course identity and presentation.
///
/// The important part is [CourseInfo.key]. The curriculum filter table used to
/// be keyed by the course's *display name* (`'AP Physics 1'`), and a lookup miss
/// falls through to "allow every unit". So renaming a course — a pure copy
/// change — silently unfiltered it, showing students videos their course does
/// not cover, with no error anywhere. Keys are stable and never rendered;
/// [CourseInfo.name] is the only thing students see.
@immutable
class CourseInfo {
  const CourseInfo({
    required this.key,
    required this.name,
    required this.imageAsset,
    required this.description,
  });

  /// Stable identifier. Safe to rename [name] without changing behaviour.
  final String key;
  final String name;
  final String imageAsset;
  final String description;
}

class CourseRegistry {
  const CourseRegistry._();

  static const String ibPhysicsHl = 'ib_physics_hl';
  static const String ibPhysicsSl = 'ib_physics_sl';
  static const String apPhysics1 = 'ap_physics_1';
  static const String apPhysics2 = 'ap_physics_2';
  static const String grade11Physics = 'grade_11_physics';
  static const String grade12Physics = 'grade_12_physics';

  /// Every course, in the order the Courses page lists them.
  static const List<CourseInfo> all = <CourseInfo>[
    CourseInfo(
      key: ibPhysicsHl,
      name: 'IB Physics HL',
      imageAsset: 'images/ib_physics_hl.jpg',
      description:
          'Complete International Baccalaureate Higher Level physics '
          'curriculum with focus on experimental skills and data analysis.',
    ),
    CourseInfo(
      key: ibPhysicsSl,
      name: 'IB Physics SL',
      imageAsset: 'images/physicssl.png',
      description:
          'Core International Baccalaureate Standard Level physics curriculum, '
          'building a strong foundation in key physics principles.',
    ),
    CourseInfo(
      key: apPhysics1,
      name: 'AP Physics 1',
      imageAsset: 'images/ap_courses.jpg',
      description:
          "Preparation videos for the AP Physics 1 exam covering kinematics, "
          "Newton's laws, circular motion, and simple harmonic oscillators.",
    ),
    CourseInfo(
      key: apPhysics2,
      name: 'AP Physics 2',
      imageAsset: 'images/ap_physics_2.png',
      description:
          'Algebra-based physics covering fluid mechanics, thermodynamics, '
          'electricity, magnetism, optics, and quantum phenomena',
    ),
    CourseInfo(
      key: grade11Physics,
      name: 'Grade 11 Physics',
      imageAsset: 'images/physics_11.jpg',
      description:
          'Videos and tutorials for the Grade 11 Physics Ontario curriculum.',
    ),
    CourseInfo(
      key: grade12Physics,
      name: 'Grade 12 Physics',
      imageAsset: 'images/physics_12.jpg',
      description:
          'Videos and tutorials for the Grade 12 Physics Ontario curriculum.',
    ),
  ];

  static const Set<String> allKeys = <String>{
    ibPhysicsHl,
    ibPhysicsSl,
    apPhysics1,
    apPhysics2,
    grade11Physics,
    grade12Physics,
  };

  static CourseInfo? byKey(String courseKey) {
    for (final CourseInfo course in all) {
      if (course.key == courseKey) return course;
    }
    return null;
  }

  /// Display name, or `''` when not inside a course (browsing topics directly).
  static String nameOf(String courseKey) => byKey(courseKey)?.name ?? '';
}
