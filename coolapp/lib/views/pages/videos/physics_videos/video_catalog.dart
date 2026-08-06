import 'package:coolapp/views/pages/videos/physics_videos/curriculum_topic_filters.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/dynamics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/electricity.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/electrostatics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/fluids.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/harmonics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/intro_to_physics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/kinematics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/light.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/magnetism.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/modern.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/momentum_and_collisions.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/optics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/other.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/rotational_motion.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/sample_videos.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/thermal_physics.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/work_and_energy.dart';

/// Single source of truth for looking up a video by its URL-facing
/// `topicKey`/`curriculumKey` pair, without having to build the topic
/// widget tree first (needed so a direct/deep-linked `/videos/watch/...`
/// URL can be resolved by the router alone).
class VideoCatalog {
  static const Map<String, List<Map<String, dynamic>>> _byTopic = {
    CurriculumTopicFilters.introToPhysics: IntroToPhysics.videos,
    CurriculumTopicFilters.kinematics: Kinematics.videos,
    CurriculumTopicFilters.dynamics: Dynamics.videos,
    CurriculumTopicFilters.workAndEnergy: WorkAndEnergy.videos,
    CurriculumTopicFilters.momentumAndCollisions:
        MomentumAndCollisions.videos,
    CurriculumTopicFilters.harmonics: Harmonics.videos,
    CurriculumTopicFilters.thermalPhysics: ThermalPhysics.videos,
    CurriculumTopicFilters.electricity: Electricity.videos,
    CurriculumTopicFilters.magnetism: Magnetism.videos,
    CurriculumTopicFilters.electrostatics: Electrostatics.videos,
    CurriculumTopicFilters.rotationalMotion: RotationalMotion.videos,
    CurriculumTopicFilters.fluids: Fluids.videos,
    CurriculumTopicFilters.optics: Optics.videos,
    CurriculumTopicFilters.light: Light.videos,
    CurriculumTopicFilters.modernPhysics: Modern.videos,
    CurriculumTopicFilters.other: Other.videos,
    CurriculumTopicFilters.sampleVideos: SampleVideos.videos,
  };

  static const Map<String, String> _topicTitles = {
    CurriculumTopicFilters.introToPhysics: 'Introduction to Physics',
    CurriculumTopicFilters.kinematics: 'Kinematics',
    CurriculumTopicFilters.dynamics: 'Forces and Dynamics',
    CurriculumTopicFilters.workAndEnergy: 'Work and Energy',
    CurriculumTopicFilters.momentumAndCollisions: 'Momentum and Collisions',
    CurriculumTopicFilters.harmonics: 'Harmonics',
    CurriculumTopicFilters.thermalPhysics: 'Thermal Physics',
    CurriculumTopicFilters.electricity: 'Electricity',
    CurriculumTopicFilters.magnetism: 'Magnetism',
    CurriculumTopicFilters.electrostatics: 'Electrostatics',
    CurriculumTopicFilters.rotationalMotion: 'Rotational Motion',
    CurriculumTopicFilters.fluids: 'Fluids',
    CurriculumTopicFilters.optics: 'Optics',
    CurriculumTopicFilters.light: 'Light',
    CurriculumTopicFilters.modernPhysics: 'Modern Physics',
    CurriculumTopicFilters.other: 'Other',
    CurriculumTopicFilters.sampleVideos: 'Sample Videos',
  };

  static Map<String, dynamic>? resolve(String topicKey, String curriculumKey) {
    final list = _byTopic[topicKey];
    if (list == null) return null;
    for (final video in list) {
      if (video['curriculumKey'] == curriculumKey) return video;
    }
    return null;
  }

  static Map<String, dynamic>? next(String topicKey, String curriculumKey) {
    final list = _byTopic[topicKey];
    if (list == null) return null;
    final index = list.indexWhere(
      (video) => video['curriculumKey'] == curriculumKey,
    );
    if (index == -1 || index == list.length - 1) return null;
    return list[index + 1];
  }

  static String topicTitle(String topicKey) => _topicTitles[topicKey] ?? '';
}
