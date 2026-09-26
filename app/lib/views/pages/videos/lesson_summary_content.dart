/// Copy shown on the lesson overview page.
class LessonSummaryContent {
  const LessonSummaryContent({
    required this.covered,
    required this.prerequisites,
  });

  final String covered;
  final String prerequisites;

  static const _defaultCovered =
      'Review the key ideas and problem-solving methods introduced in this lesson.';
  static const _defaultPrerequisites =
      'Bring a calculator, something to take notes with, and a willingness to learn.';

  /// Topic-level prerequisites keep every lesson informative while authors can
  /// override a specific video by adding `prerequisites` to its catalog entry.
  static const Map<String, String> _prerequisitesByTopic = {
    'intro_to_physics':
        'No prior physics knowledge is needed. Be comfortable with basic arithmetic and reading simple graphs.',
    'kinematics':
        'Be comfortable with basic algebra, rearranging equations, and interpreting position-time graphs.',
    'dynamics':
        'Review vectors, free-body diagrams, and basic algebra before beginning.',
    'work_and_energy':
        'Know how to work with forces, displacement, and basic algebraic equations.',
    'momentum_and_collisions':
        'Review vectors, velocity, mass, and the difference between scalar and vector quantities.',
    'harmonics':
        'Be comfortable with forces, energy, and basic trigonometry or graph reading.',
    'thermal_physics':
        'Review energy conservation, unit conversions, and algebraic rearrangement.',
    'electricity':
        'Know basic algebra and be ready to read and label simple circuit diagrams.',
    'magnetism':
        'Review vectors, right-hand-rule notation, and the basics of current and charge.',
    'electrostatics':
        'Know the ideas of charge, force, energy, and basic vector direction.',
    'rotational_motion':
        'Review Newton’s laws, vectors, and the connection between linear force and motion.',
    'fluids':
        'Be comfortable with density, pressure, forces, and rearranging formulas.',
    'optics':
        'No special background is required; basic algebra and careful ray-diagram reading will help.',
    'light':
        'Review wave vocabulary, basic algebra, and how to interpret diagrams.',
    'modern_physics':
        'Be comfortable with energy, waves, and scientific notation.',
    'other':
        'Read the lesson title and have a calculator and notes ready for the examples.',
    'sample_videos':
        'Review the relevant unit notes before working through this example.',
    'video_of_the_day':
        'Have a calculator and your notes ready. Review the related topic if the example feels unfamiliar.',
  };

  /// Builds summary text for every catalog video. Add `covered` or
  /// `prerequisites` fields to an individual video map to customize it.
  factory LessonSummaryContent.fromVideo({
    required String topicKey,
    required Map<String, dynamic> video,
  }) {
    final covered = _read(video['covered']) ??
        _read(video['description']) ??
        _defaultCovered;
    final prerequisites = _read(video['prerequisites']) ??
        _prerequisitesByTopic[topicKey] ??
        _defaultPrerequisites;

    return LessonSummaryContent(
      covered: covered,
      prerequisites: prerequisites,
    );
  }

  static String? _read(dynamic value) {
    if (value is! String) return null;
    final text = value.trim();
    return text.isEmpty ? null : text;
  }
}
