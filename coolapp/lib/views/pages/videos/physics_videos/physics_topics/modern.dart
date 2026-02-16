import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/views/pages/videos/physics_videos/curriculum_topic_filters.dart';
import 'package:coolapp/views/pages/videos/video_player.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/topic_widgets.dart';

class Modern extends StatefulWidget {
  const Modern({super.key});

  @override
  State<Modern> createState() => _ModernState();
}

class _ModernState extends State<Modern> {
  Map<int, bool> hoveredStates = {};
  final List<Map<String, dynamic>> videosList = [
    {
      'curriculumKey': 'modern_intro',
      'title': "Unit 1: Foundations of Modern Physics",
      'description':
          "Limits of classical physics, key ideas that launched modern physics",
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/modern_physics/Unit%201%20Introduction%20To%20Modern%20Physics.mp4', //Completed 2026/2/10
    },
    {
      'curriculumKey': 'quantized_energy',
      'title': "Unit 2: Quantized Energy Levels and Formulae",
      'description':
          "Energy quantization, Planck's constant, and quantum formulas",
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/modern_physics/Unit%202%20Quantized%20Energy%20Levels%20and%20Formulae.mp4', //Completed 2026/2/10
    },
    {
      'curriculumKey': 'photoelectric_effect',
      'title': 'Unit 3: The Photoelectric Effect and Wave-Particle Duality',
      'description':
          'Photons, wave-particle duality, and the photoelectric effect',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/modern_physics/Unit%203%20The%20Photoelectric%20Effect.mp4', //Completed 2026/2/10
    },
    {
      'curriculumKey': 'matter_waves',
      'title': 'Unit 4: Matter as Waves and Atomic Structure',
      'description':
          "Introduction to how matter can also behave as waves, atomic models, and quantum numbers",
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/modern_physics/Unit%204%20Wave-Particle%20Duality.mp4', //Completed 2026/2/10
    },
    {
      'curriculumKey': 'nuclear_decay',
      'title': 'Unit 5: Nuclear Decay',
      'description': "Radioactivity, half-life, and decay processes",
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/modern_physics/Unit%205%20Types%20of%20Decay.mp4', //Completed 2026/2/10
    },
    {
      'curriculumKey': 'fission_fusion',
      'title': 'Unit 6: Fission and Fusion',
      'description': "Nuclear reactions, fission, fusion, and their applications",
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/modern_physics/Unit%206%20Fission%20and%20Fusion%20Reactions.mp4', //Completed 2026/2/10
    },
  ];
  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.topicTitle = 'Modern Physics';
    //print("topic title: Momentum and collisions, unit title reset");
    final visibleVideos = CurriculumTopicFilters.filterUnits(
      courseTitle: globals.courseTitle,
      topicKey: CurriculumTopicFilters.modernPhysics,
      units: videosList,
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
                title: globals.topicTitle,
                context: context,
                description:
                  "Explore the ideas that reshaped physics, including relativity, quantum theory, atomic models, and nuclear phenomena. Learn how modern physics explains light, matter, and energy at extreme scales.",
                topIcon: Icons.rectangle,
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
                      videoPage: video['videoPage']!,
                      videosList: visibleVideos,
                      videoLink: video['videoLink'],
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
