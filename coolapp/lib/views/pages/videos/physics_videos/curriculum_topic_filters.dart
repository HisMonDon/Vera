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

  static const String _allUnitsMarker = '__all_units__';
  static const Set<String> _allUnits = {_allUnitsMarker};

  /// Per-course topic configuration.
  ///
  /// - `_allUnits` means the whole topic is allowed as-is.
  /// - `{}` means the topic is hidden for that course.
  /// - A non-empty custom set means filter by `curriculumKey`.
  static final Map<String, Map<String, Set<String>>> _allowedUnitsByCourse = {
    'IB Physics SL': {
      introToPhysics: _allUnits,
      kinematics: _allUnits,
      dynamics: _allUnits,
      workAndEnergy: _allUnits,
      momentumAndCollisions: _allUnits,
      harmonics: _allUnits,
      thermalPhysics: _allUnits,
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
    'IB Physics HL': {
      introToPhysics: _allUnits,
      kinematics: _allUnits,
      dynamics: _allUnits,
      workAndEnergy: _allUnits,
      momentumAndCollisions: _allUnits,
      harmonics: _allUnits,
      thermalPhysics: _allUnits,
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
    'AP Physics 1': {
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
    'AP Physics 2': {
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
    'Grade 11 Physics': {
      introToPhysics: _allUnits,
      kinematics: _allUnits,
      dynamics: _allUnits,
      workAndEnergy: _allUnits,
      momentumAndCollisions: {},
      harmonics: _allUnits,
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
    'Grade 12 Physics': {
      introToPhysics: _allUnits,
      kinematics: _allUnits,
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

  static List<Map<String, dynamic>> filterUnits({
    required String courseTitle,
    required String topicKey,
    required List<Map<String, dynamic>> units,
  }) {
    final allowedKeys = _allowedUnitsByCourse[courseTitle]?[topicKey];
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
