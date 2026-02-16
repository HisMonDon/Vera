
class CurriculumTopicFilters {
  static const String modernPhysics = 'modern_physics';

  static final Map<String, Map<String, Set<String>>> _allowedUnitsByCourse = {
    'IB Physics SL': {
      modernPhysics: {'modern_intro', 'nuclear_decay', 'fission_fusion'},
    },
    'IB Physics HL': {
      modernPhysics: {
        'modern_intro',
        'quantized_energy',
        'photoelectric_effect',
        'matter_waves',
        'nuclear_decay',
        'fission_fusion',
      },
    },
    'AP Physics 1': {modernPhysics: {}},
    'AP Physics 2': {
      modernPhysics: {
        'modern_intro',
        'quantized_energy',
        'photoelectric_effect',
        'matter_waves',
        'nuclear_decay',
        'fission_fusion',
      },
    },
    'Grade 11 Physics': {modernPhysics: {}},
    'Grade 12 Physics': {
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
    final allowedKeys = _allowedUnitsByCourse[courseTitle]?[topicKey];
    if (allowedKeys == null) return units;
    if (allowedKeys.isEmpty) return const [];

    return units.where((unit) {
      final key = unit['curriculumKey'];
      return key is String && allowedKeys.contains(key);
    }).toList();
  }
}
