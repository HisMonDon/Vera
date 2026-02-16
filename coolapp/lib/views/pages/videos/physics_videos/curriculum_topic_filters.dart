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

  /// Topic availability by course.
  /// If a topic key is not listed for a course, that topic is hidden.
  static final Map<String, Set<String>> _allowedTopicsByCourse = {
    'IB Physics SL': {
      introToPhysics,
      kinematics,
      dynamics,
      workAndEnergy,
      momentumAndCollisions,
      harmonics,
      thermalPhysics,
      electricity,
      magnetism,
      modernPhysics,
    },
    'IB Physics HL': {
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
      light,
      modernPhysics,
    },
    'AP Physics 1': {
      kinematics,
      dynamics,
      workAndEnergy,
      momentumAndCollisions,
      rotationalMotion,
      harmonics,
      fluids,
    },
    'AP Physics 2': {
      fluids,
      thermalPhysics,
      electricity,
      magnetism,
      electrostatics,
      optics,
      light,
      modernPhysics,
    },
    'Grade 11 Physics': {
      introToPhysics,
      kinematics,
      dynamics,
      workAndEnergy,
      thermalPhysics,
      harmonics,
      electricity,
      magnetism,
    },
    'Grade 12 Physics': {
      introToPhysics,
      kinematics,
      dynamics,
      momentumAndCollisions,
      workAndEnergy,
      electrostatics,
      light,
      modernPhysics,
    },
  };

  /// Optional per-topic video-unit filtering.
  /// If a topic has no entry, all units in that topic are shown.
  static final Map<String, Map<String, Set<String>>> _allowedUnitsByCourse = {
    'IB Physics SL': {
      // SL excludes HL-only quantum depth (photoelectric, matter waves, etc.).
      modernPhysics: {
        'modern_intro',
        'nuclear_decay',
        'fission_fusion',
      },
    },
    'IB Physics HL': {
      // HL includes full modern/quantum coverage.
      modernPhysics: {
        'modern_intro',
        'quantized_energy',
        'photoelectric_effect',
        'matter_waves',
        'nuclear_decay',
        'fission_fusion',
      },
    },
    'AP Physics 1': {
      // AP Physics 1 has no modern physics unit.
      modernPhysics: {},
    },
    'AP Physics 2': {
      // AP Physics 2 includes modern physics.
      modernPhysics: {
        'modern_intro',
        'quantized_energy',
        'photoelectric_effect',
        'matter_waves',
        'nuclear_decay',
        'fission_fusion',
      },
    },
    'Grade 11 Physics': {
      // Ontario SPH3U does not include modern physics.
      modernPhysics: {},
    },
    'Grade 12 Physics': {
      // Ontario SPH4U includes modern + nuclear fundamentals.
      modernPhysics: {
        'modern_intro',
        'quantized_energy',
        'nuclear_decay',
        'fission_fusion',
      },
    },
  };

  static List<Map<String, dynamic>> filterUnits({
    required String courseTitle,
    required String topicKey,
    required List<Map<String, dynamic>> units,
  }) {
    final allowedTopics = _allowedTopicsByCourse[courseTitle];
    if (allowedTopics != null && !allowedTopics.contains(topicKey)) {
      return const [];
    }

    final allowedKeys = _allowedUnitsByCourse[courseTitle]?[topicKey];

    // No course-specific per-unit config => show full topic list.
    if (allowedKeys == null) {
      return units;
    }

    // Explicit empty set => no units for this topic.
    if (allowedKeys.isEmpty) {
      return const [];
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
