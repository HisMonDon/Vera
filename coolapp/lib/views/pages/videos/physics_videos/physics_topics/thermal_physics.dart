import 'package:coolapp/views/pages/videos/video_player.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/views/pages/videos/physics_videos/curriculum_topic_filters.dart';
import 'package:coolapp/views/pages/videos/physics_videos/physics_topics/topic_widgets.dart';

class ThermalPhysics extends StatefulWidget {
  const ThermalPhysics({super.key});

  @override
  State<ThermalPhysics> createState() => _ThermalPhysicsState();
}

class _ThermalPhysicsState extends State<ThermalPhysics> {
  final double _width = 400;
  final double _height = 200;
  Map<int, bool> hoveredStates = {};
  final List<Map<String, dynamic>> videosList = [
    {
      'curriculumKey': 'thermal_temperature',
      'title': 'Temperature, Heat, and Thermal Energy',
      'description':
          'Temperature vs. heat, thermal equilibrium (zeroth law), specific heat and calorimetry basics, and an overview of conduction, convection, and radiation',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/thermal_physics/Unit%201%20Temperature%2C%20Heat%2C%20and%20Thermal%20Energy.mp4',
    },
    {
      'curriculumKey': 'thermal_latent_heat',
      'title': 'Heat and Latent Heat',
      'description':
          'Phase changes and latent heat, heating/cooling curves, calorimetry with phase transitions, and mixing problems using energy conservation',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/thermal_physics/Unit%202%20Heat%20and%20Latent%20Heat.mp4',
    },
    {
      'curriculumKey': 'thermal_transfer',
      'title': 'Heat Transfer Examples',
      'description':
          'Worked examples using conduction, convection, and radiation; thermal resistance ideas; rate of heat flow; and common AP-style applications',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/thermal_physics/Unit%203%20Heat%20Transfer%20Examples.mp4',
    },
    {
      'curriculumKey': 'thermal_gas_laws',
      'title': 'Gas Laws (Ideal, Combined, Avagadros)',
      'description':
          'Boyle’s, Charles’s, Gay-Lussac’s, Avogadro’s, and the combined gas law; ideal gas law PV = nRT; and conceptual/graph relationships',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/thermal_physics/Unit%204%20Gas%20Laws%20(Ideal%2C%20Combined%2C%20Avagadros).mp4',
    },
    {
      'curriculumKey': 'thermal_first_law',
      'title': 'The First Law of Thermodynamics',
      'description':
          'First law (ΔU = Q − W), sign conventions, PV work, and applying the law to isothermal, isobaric, isochoric, and adiabatic processes',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/thermal_physics/Unit%205%20The%20First%20Law%20of%20Thermodynamics.mp4',
    },
    {
      'curriculumKey': 'thermal_ap_example',
      'title': 'AP Physics 2 Thermodynamics Example',
      'description':
          'Full AP Physics 2–style thermodynamics walkthrough: interpreting a process/path, tracking Q, W, and ΔU, and solving with PV diagrams and the first law',
      'videoPage': VideoPlayerScreen(key: UniqueKey()),
      'videoLink':
          'https://pub-56767059a1844d06818006869a91df08.r2.dev/thermal_physics/AP%20Physics%202%20Thermodynamics%20Example.mp4',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // add an immediate check in build method
    globals.topicTitle = 'Thermal Physics';
    final visibleVideos = CurriculumTopicFilters.filterUnits(
      courseTitle: globals.courseTitle,
      topicKey: CurriculumTopicFilters.thermalPhysics,
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
                    'Study of heat, temperature, and energy transfer processes, including thermodynamics laws, kinetic theory, entropy, and the behavior of thermal systems',
                topIcon: Icons.thermostat,
              ),
              SizedBox(width: 2, height: 20),
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
