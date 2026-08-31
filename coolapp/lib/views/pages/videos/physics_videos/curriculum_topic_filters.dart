import 'package:flutter/foundation.dart';

import 'package:coolapp/views/pages/videos/physics_videos/course_registry.dart';

/// Central place for curriculum-specific topic filtering.
///
/// Shared topic pages can expose only the videos that belong to the active
/// course curriculum.
class CurriculumTopicFilters {
  static const String introToPhysics = 'intro_to_physics';
  static const String kinematics = 'kinematics';
  static const String dynamics = 'dynamics';
  static const String workAndEnergy = 'work_and_energy';
  static const String momentumAndCollisions = 'momentum_and_collisions';
  static const String harmonics = 'harmonics';
  static const String thermalPhysics = 'thermal_physics';
  static const String electricity = 'electricity';
  static const String magnetism = 'magnetism';
  static const String electrostatics = 'electrostatics';
  static const String rotationalMotion = 'rotational_motion';
  static const String fluids = 'fluids';
  static const String optics = 'optics';
  static const String light = 'light';
  static const String modernPhysics = 'modern_physics';
  static const String other = 'other';
  static const String sampleVideos = 'sample_videos';

  /// Every topic key, for coverage assertions in tests.
  static const Set<String> allKeys = <String>{
    introToPhysics,
    kinematics,
    dynamics,
    workAndEnergy,
    momentumAndCollisions,
    harmonics,
    thermalPhysics,
    electricity,
    magnetism,
    electrostatics,
    rotationalMotion,
    fluids,
    optics,
    light,
    modernPhysics,
    other,
    sampleVideos,
  };

  static const String _allUnitsMarker = '__all_units__';
  static const Set<String> _allUnits = {_allUnitsMarker};

  /// Per-course topic configuration.
  ///
  /// - `_allUnits` means the whole topic is allowed as-is.
  /// - `{}` means the topic is hidden for that course.
  /// - A non-empty custom set means filter by `curriculumKey`.
  /// The per-course policy table, exposed for coverage assertions in tests.
  /// Every course must list every topic key; a missing key silently falls
  /// through to "allow all", which is how Grade 11 lost its thermal filter.
  @visibleForTesting
  static Map<String, Map<String, Set<String>>> get coursePolicy =>
      _allowedUnitsByCourse;

  static final Map<String, Map<String, Set<String>>> _allowedUnitsByCourse = {
    CourseRegistry.ibPhysicsSl: {
      introToPhysics: _allUnits,
      kinematics: _allUnits,
      dynamics: _allUnits,
      workAndEnergy: _allUnits,
      momentumAndCollisions: _allUnits,
      harmonics: {
        'pendulum',
        'springs_hookes',
        'springs_energy',
      },
      thermalPhysics: {
        'thermal_temperature',
        'thermal_latent_heat',
        'thermal_transfer',
        'thermal_gas_laws',
      },
      electricity: _allUnits,
      magnetism: _allUnits,
      electrostatics: {},
      rotationalMotion: {},
      fluids: {},
      optics: {},
      light: {},
      modernPhysics: {
        'modern_intro',
        'nuclear_decay',
        'fission_fusion',
      },
      other: {},
      sampleVideos: {},
    },
    CourseRegistry.ibPhysicsHl: {
      introToPhysics: _allUnits,
      kinematics: _allUnits,
      dynamics: _allUnits,
      workAndEnergy: _allUnits,
      momentumAndCollisions: _allUnits,
      harmonics: {
        'pendulum',
        'springs_hookes',
        'springs_energy',
      },
      thermalPhysics: {
        'thermal_temperature',
        'thermal_latent_heat',
        'thermal_transfer',
        'thermal_gas_laws',
      },
      electricity: _allUnits,
      magnetism: _allUnits,
      electrostatics: _allUnits,
      rotationalMotion: _allUnits,
      fluids: {},
      optics: {},
      light: _allUnits,
      modernPhysics: {
        'modern_intro',
        'quantized_energy',
        'photoelectric_effect',
        'matter_waves',
        'nuclear_decay',
        'fission_fusion',
      },
      other: {},
      sampleVideos: {},
    },
    CourseRegistry.apPhysics1: {
      introToPhysics: {},
      kinematics: _allUnits,
      dynamics: _allUnits,
      workAndEnergy: _allUnits,
      momentumAndCollisions: _allUnits,
      harmonics: _allUnits,
      thermalPhysics: {},
      electricity: {},
      magnetism: {},
      electrostatics: {},
      rotationalMotion: _allUnits,
      fluids: _allUnits,
      optics: {},
      light: {},
      modernPhysics: {},
      other: {},
      sampleVideos: {},
    },
    CourseRegistry.apPhysics2: {
      introToPhysics: {},
      kinematics: {},
      dynamics: {},
      workAndEnergy: {},
      momentumAndCollisions: {},
      harmonics: {},
      thermalPhysics: _allUnits,
      electricity: _allUnits,
      magnetism: _allUnits,
      electrostatics: _allUnits,
      rotationalMotion: {},
      fluids: _allUnits,
      optics: _allUnits,
      light: _allUnits,
      modernPhysics: {
        'modern_intro',
        'quantized_energy',
        'photoelectric_effect',
        'matter_waves',
        'nuclear_decay',
        'fission_fusion',
      },
      other: {},
      sampleVideos: {},
    },
    CourseRegistry.grade11Physics: {
      introToPhysics: _allUnits,
      kinematics: {
        'motion_1d',
        'motion_2d_part1',
        'motion_2d_part2',
        'motion_2d_part3',
        'motion_2d_examples',
        'motion_2d_harder',
      },
      dynamics: _allUnits,
      workAndEnergy: {
        'work_theorem',
        'energy_forms',
        'energy_conservation',
        'power_efficiency',
      },
      momentumAndCollisions: {},
      harmonics: {
        'pendulum',
        'springs_hookes',
        'springs_energy',
      },
      // Grade 11 was previously missing this key entirely. A missing key
      // falls through to "allow all", so thermal was unfiltered by accident.
      // Keeping every unit visible is the intended behaviour, stated
      // explicitly here so it reads as a decision, not an omission.
      thermalPhysics: _allUnits,
      electricity: _allUnits,
      magnetism: _allUnits,
      electrostatics: {},
      rotationalMotion: {},
      fluids: {},
      optics: {},
      light: {},
      modernPhysics: {},
      other: {},
      sampleVideos: {},
    },
    CourseRegistry.grade12Physics: {
      introToPhysics: _allUnits,
      kinematics: {
        'motion_1d',
        'motion_2d_part1',
        'motion_2d_part2',
        'motion_2d_part3',
        'motion_2d_examples',
        'motion_2d_harder',
      },
      dynamics: _allUnits,
      workAndEnergy: _allUnits,
      momentumAndCollisions: _allUnits,
      harmonics: {},
      thermalPhysics: {},
      electricity: {},
      magnetism: {},
      electrostatics: _allUnits,
      rotationalMotion: {},
      fluids: {},
      optics: {},
      light: _allUnits,
      modernPhysics: {
        'modern_intro',
        'quantized_energy',
        'nuclear_decay',
        'fission_fusion',
      },
      other: {},
      sampleVideos: {},
    },
  };

  /// Units of [topicKey] visible to [courseKey].
  ///
  /// [courseKey] is a [CourseRegistry] key, never a display name — see the note
  /// on [CourseInfo]. An empty [courseKey] means "not inside a course"
  /// (browsing topics directly), which is legitimately unfiltered.
  static List<Map<String, dynamic>> filterUnits({
    required String courseKey,
    required String topicKey,
    required List<Map<String, dynamic>> units,
  }) {
    // A missing entry falls through to "show everything", which is silent and
    // wrong. Fail loudly in debug and in tests; keep the permissive behaviour
    // in release so a bad key degrades rather than blanking the page.
    assert(
      courseKey.isEmpty || _allowedUnitsByCourse.containsKey(courseKey),
      'No unit policy for course "$courseKey". Add it to '
      '_allowedUnitsByCourse, or the course will show every video.',
    );
    final allowedKeys = _allowedUnitsByCourse[courseKey]?[topicKey];
    if (allowedKeys == null) {
      return units;
    }

    if (allowedKeys.isEmpty) {
      return const [];
    }

    if (allowedKeys.contains(_allUnitsMarker)) {
      return units;
    }

    return units.where((unit) {
      final key = unit['curriculumKey'];
      if (key is! String) {
        return false;
      }
      return allowedKeys.contains(key);
    }).toList();
  }
}
