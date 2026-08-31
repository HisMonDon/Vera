import 'package:flutter/widgets.dart';

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
import 'package:coolapp/views/pages/videos/physics_videos/topic_registry.dart';

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

  /// Topic key -> the page widget for that topic.
  ///
  /// Lives here because this is already the one file that imports all 17 topic
  /// pages. Callers that only need names/descriptions use `TopicRegistry`
  /// instead and stay free of the widget tree.
  static const Map<String, Widget Function()> _pageBuilders =
      <String, Widget Function()>{
    CurriculumTopicFilters.introToPhysics: IntroToPhysics.new,
    CurriculumTopicFilters.kinematics: Kinematics.new,
    CurriculumTopicFilters.dynamics: Dynamics.new,
    CurriculumTopicFilters.workAndEnergy: WorkAndEnergy.new,
    CurriculumTopicFilters.momentumAndCollisions: MomentumAndCollisions.new,
    CurriculumTopicFilters.harmonics: Harmonics.new,
    CurriculumTopicFilters.thermalPhysics: ThermalPhysics.new,
    CurriculumTopicFilters.electricity: Electricity.new,
    CurriculumTopicFilters.magnetism: Magnetism.new,
    CurriculumTopicFilters.electrostatics: Electrostatics.new,
    CurriculumTopicFilters.rotationalMotion: RotationalMotion.new,
    CurriculumTopicFilters.fluids: Fluids.new,
    CurriculumTopicFilters.optics: Optics.new,
    CurriculumTopicFilters.light: Light.new,
    CurriculumTopicFilters.modernPhysics: Modern.new,
    CurriculumTopicFilters.other: Other.new,
    CurriculumTopicFilters.sampleVideos: SampleVideos.new,
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

  /// Canonical display name for a topic.
  ///
  /// Delegates to [TopicRegistry] so a name cannot be defined in two places.
  /// Kept as a method on VideoCatalog because the router already calls it.
  static String topicTitle(String topicKey) => TopicRegistry.nameOf(topicKey);

  /// Finds the lesson that plays [videoLink], as a `(topicKey, curriculumKey)`
  /// pair, or `null` if no lesson uses that file.
  ///
  /// Needed because the Home "video of the day" list identifies the same videos
  /// by its own curriculum keys (`free_body_diagrams` where the catalog says
  /// `fbd`). Resolving through the shared video URL means captions and lesson
  /// data are found without maintaining a second mapping that could drift.
  static ({String topicKey, String curriculumKey})? locate(String videoLink) {
    if (videoLink.isEmpty) return null;
    for (final MapEntry<String, List<Map<String, dynamic>>> topic
        in _byTopic.entries) {
      for (final Map<String, dynamic> video in topic.value) {
        if (video['videoLink'] == videoLink) {
          return (
            topicKey: topic.key,
            curriculumKey: video['curriculumKey'] as String,
          );
        }
      }
    }
    return null;
  }

  /// Builder for a topic's page, or `null` if the key is unknown.
  static Widget Function()? pageFor(String topicKey) =>
      _pageBuilders[topicKey];
}
