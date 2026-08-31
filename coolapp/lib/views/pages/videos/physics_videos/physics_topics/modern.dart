import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/views/pages/videos/physics_videos/curriculum_topic_filters.dart';
import 'package:coolapp/views/pages/videos/physics_videos/topic_registry.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/topic_widgets.dart';

class Modern extends StatefulWidget {
  const Modern({super.key});

  static const List<Map<String, dynamic>> videos = [
    {
      'curriculumKey': 'modern_intro',
      'title': "Foundations of Modern Physics",
      'description':
          "Limits of classical physics, key ideas that launched modern physics",
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/modern_physics/Unit%201%20Introduction%20To%20Modern%20Physics.mp4', //Completed 2026/2/10
    },
    {
      'curriculumKey': 'quantized_energy',
      'title': "Quantized Energy Levels and Formulae",
      'description':
          "Energy quantization, Planck's constant, and quantum formulas",
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/modern_physics/Unit%202%20Quantized%20Energy%20Levels%20and%20Formulae.mp4', //Completed 2026/2/10
    },
    {
      'curriculumKey': 'photoelectric_effect',
      'title': 'The Photoelectric Effect and Wave-Particle Duality',
      'description':
          'Photons, wave-particle duality, and the photoelectric effect',
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/modern_physics/Unit%203%20The%20Photoelectric%20Effect.mp4', //Completed 2026/2/10
    },
    {
      'curriculumKey': 'matter_waves',
      'title': 'Matter as Waves and Atomic Structure',
      'description':
          "Introduction to how matter can also behave as waves, atomic models, and quantum numbers",
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/modern_physics/Unit%204%20Wave-Particle%20Duality.mp4', //Completed 2026/2/10
    },
    {
      'curriculumKey': 'nuclear_decay',
      'title': 'Nuclear Decay',
      'description': "Radioactivity, half-life, and decay processes",
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/modern_physics/Unit%205%20Types%20of%20Decay.mp4', //Completed 2026/2/10
    },
    {
      'curriculumKey': 'fission_fusion',
      'title': 'Fission and Fusion',
      'description': "Nuclear reactions, fission, fusion, and their applications",
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/modern_physics/Unit%206%20Fission%20and%20Fusion%20Reactions.mp4', //Completed 2026/2/10
    },
  ];

  @override
  State<Modern> createState() => _ModernState();
}

class _ModernState extends State<Modern> {
  /// This page's topic. All display copy is looked up from it, so the
  /// name here cannot disagree with Explore, the lesson page or the player.
  static const String _topicKey = CurriculumTopicFilters.modernPhysics;

  Map<int, bool> hoveredStates = {};
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.topicTitle = TopicRegistry.nameOf(_topicKey);
    //print("topic title: Momentum and collisions, unit title reset");
    final visibleVideos = CurriculumTopicFilters.filterUnits(
      courseKey: globals.courseKey,
      topicKey: CurriculumTopicFilters.modernPhysics,
      units: Modern.videos,
    );

    return Scaffold(
      appBar: TimedAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(width: 2, height: 10),
              TopicWidgets.buildTopLayout(
                title: TopicRegistry.nameOf(_topicKey),
                context: context,
                description: TopicRegistry.descriptionOf(_topicKey),
                topIcon: TopicRegistry.byKey(_topicKey)!.icon,
              ),
              SizedBox(width: 2, height: 20),
              if (visibleVideos.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 8, 83, 68),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'No Modern Physics videos are available for this course curriculum.',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )
              else
                Column(
                  children: List.generate(visibleVideos.length, (index) {
                    final video = visibleVideos[index];
                    return TopicWidgets.buildVideoButton(
                      title: video['title'] ?? '',
                      description: video['description'] ?? '',
                      index: index,
                      topicKey: CurriculumTopicFilters.modernPhysics,
                      videosList: visibleVideos,
                      context: context,
                      hoveredStates: hoveredStates,
                      onHoverChanged: (index, isHovered) {
                        setState(() {
                          hoveredStates[index] = isHovered;
                        });
                      },
                    );
                  }),
                ),
              TopicWidgets.buildBackButton(context: context),
            ],
          ),
        ),
      ),
    );
  }
}
