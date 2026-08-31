import 'package:flutter/material.dart' show IconData, Icons, immutable;

import 'package:coolapp/views/pages/videos/physics_videos/curriculum_topic_filters.dart';

/// Single source of truth for how a topic is *presented*: its display name,
/// description, artwork and icon.
///
/// Identity lives in [CurriculumTopicFilters] (the stable `topicKey` strings,
/// which appear in URLs and must never change). This file owns everything a
/// student actually reads.
///
/// Before this existed, topic display names were hardcoded in seven places that
/// disagreed with each other — the Explore grid alone held two separate copies
/// of the list with a different name for the same topic in each — so a topic
/// could be called three different things depending on how you navigated to it.
/// Anything that needs to show a topic name must read it from here.
///
/// Deliberately depends only on the Flutter framework, never on the topic page
/// widgets. That keeps it importable from data-only code and from plain unit
/// tests. Widget lookup lives in `VideoCatalog.pageFor`.
@immutable
class TopicInfo {
  const TopicInfo({
    required this.key,
    required this.name,
    required this.shortDescription,
    required this.imageAsset,
    required this.icon,
    this.showInExplore = true,
    this.aliases = const <String>[],
  });

  /// Stable, URL-facing identifier. Always a [CurriculumTopicFilters] constant.
  final String key;

  /// The one canonical display name. Never write a topic name inline; read this.
  final String name;

  final String shortDescription;
  final String imageAsset;
  final IconData icon;

  /// Whether the topic appears in the Explore grid. Sample Videos is reachable
  /// by direct link only, so it is registered but hidden — an explicit flag
  /// rather than the silent omission the old hardcoded list relied on.
  final bool showInExplore;

  /// Names this topic used to be called, or that a student might search for.
  /// Kept so displaced variants stay greppable and a future search box can
  /// match them. Never rendered.
  final List<String> aliases;
}

class TopicRegistry {
  const TopicRegistry._();

  /// Every topic, in "Relevance" order — this list *is* the relevance ordering
  /// the Explore grid restores when sorting is reset.
  ///
  /// Must stay `const`: the Explore grid previously called `.sort()` directly on
  /// its topic list, which mutated it in place and permanently reordered the
  /// app. That is the reason a second copy of the list existed at all. Callers
  /// sort a copy (`List.of(TopicRegistry.all)`); a const list turns the old
  /// mistake into a compile error rather than a convention.
  static const List<TopicInfo> all = <TopicInfo>[
    TopicInfo(
      key: CurriculumTopicFilters.introToPhysics,
      name: 'Introduction to Physics',
      shortDescription:
          'Short topic explaining the introduction to physics, including '
          'vectors, velocity, and displacement',
      imageAsset: 'images/intro_to_physics.jpg',
      icon: Icons.show_chart,
      aliases: <String>['Intro to Physics'],
    ),
    TopicInfo(
      key: CurriculumTopicFilters.kinematics,
      name: 'Kinematics',
      shortDescription:
          'Motion analysis, explore concepts such as displacement, velocity, '
          'acceleration, and time, and how to apply kinematic equations to '
          'describe motion in one and two dimensions.',
      imageAsset: 'images/kinematics.jpg',
      icon: Icons.my_location,
      aliases: <String>['Motion'],
    ),
    TopicInfo(
      key: CurriculumTopicFilters.dynamics,
      name: 'Forces and Dynamics',
      shortDescription:
          "Examine how forces influence motion through Newton's laws of "
          'motion. Concepts such as mass, weight, friction, tension, and '
          'normal force, learn how to analyze interactions between objects, '
          'use Free Body Diagrams',
      imageAsset: 'images/dynamics.jpg',
      // Was Icons.rectangle — a copy-paste placeholder shared with Modern Physics.
      icon: Icons.open_with,
      aliases: <String>['Dynamics', 'Forces', 'Mechanics'],
    ),
    TopicInfo(
      key: CurriculumTopicFilters.workAndEnergy,
      name: 'Work and Energy',
      shortDescription:
          'Calculate work done by forces, analyze kinetic and potential energy '
          'transformations, and apply conservation of energy to solve complex '
          'physics problems',
      imageAsset: 'images/work_and_energy.jpg',
      icon: Icons.bolt_outlined,
      aliases: <String>['Energy', 'Energy and Society'],
    ),
    TopicInfo(
      key: CurriculumTopicFilters.electricity,
      name: 'Circuits and Electricity',
      // Leads with "Circuits" so it is distinguishable from Electrostatics at a
      // glance — students could not previously tell which topic held circuits.
      shortDescription:
          'Current, resistance, and potential difference in circuits. Build and '
          "analyze series and parallel circuits, apply Ohm's and Kirchhoff's "
          'laws, and work with capacitance.',
      imageAsset: 'images/electricity.jpg',
      icon: Icons.flash_on,
      aliases: <String>['Electricity', 'Electricity and Circuits', 'Circuits'],
    ),
    TopicInfo(
      key: CurriculumTopicFilters.momentumAndCollisions,
      name: 'Momentum and Collisions',
      shortDescription:
          'Momentum, elastic and non-elastic collisions, and impulse',
      imageAsset: 'images/momentum.jpg',
      icon: Icons.train,
      aliases: <String>['Momentum', 'Collisions', 'Impulse'],
    ),
    TopicInfo(
      key: CurriculumTopicFilters.magnetism,
      name: 'Magnetism',
      shortDescription:
          'Principles of magnetic phenomena, exploring concepts such as '
          'magnetic fields, forces on moving charges, electromagnetic '
          'induction, and applications of magnetism.',
      imageAsset: 'images/magnetism.jpg',
      // Was Icons.flash_on, identical to Circuits and Electricity.
      icon: Icons.explore,
      aliases: <String>['Magnetic Fields', 'Electromagnetism'],
    ),
    TopicInfo(
      key: CurriculumTopicFilters.optics,
      name: 'Optics',
      // Ray optics only. The previous description promised total internal
      // reflection and interference, both of which are lessons in Light — a
      // direct cause of students opening the wrong topic.
      shortDescription:
          'Ray optics: how mirrors and lenses form images. Ray diagrams, the '
          'lens equation, magnification, and optical instruments.',
      imageAsset: 'images/optics.png',
      // Was Icons.wb_sunny, identical to Light.
      icon: Icons.visibility,
      aliases: <String>['Lenses', 'Mirrors', 'Geometric Optics', 'Ray Optics'],
    ),
    TopicInfo(
      key: CurriculumTopicFilters.light,
      name: 'Light',
      shortDescription:
          'Light as a wave: refraction, total internal reflection, and '
          "interference in Young's double-slit experiment.",
      imageAsset: 'images/light.png',
      icon: Icons.wb_sunny,
      aliases: <String>[
        'Wave Optics',
        'Total Internal Reflection',
        'Interference',
        'Diffraction',
      ],
    ),
    TopicInfo(
      key: CurriculumTopicFilters.fluids,
      name: 'Fluids',
      shortDescription:
          'Hydrostatic pressure at different depths, analyze buoyant forces '
          "using Archimedes' principle, apply Bernoulli's equation to fluid "
          'flow problems, and understand viscosity effects in real-world '
          'applications like blood flow and aerodynamics.',
      imageAsset: 'images/fluids.png',
      icon: Icons.water_drop,
      aliases: <String>['Fluid Mechanics', 'Buoyancy', 'Hydrostatics'],
    ),
    TopicInfo(
      key: CurriculumTopicFilters.harmonics,
      name: 'Harmonics',
      shortDescription:
          'Analyze simple harmonic motion equations, calculate periods of '
          'pendulums and spring systems, understand resonance conditions, '
          'solve damped oscillation problems, and model coupled oscillators in '
          'mechanical and electrical systems.',
      imageAsset: 'images/harmonics.jpg',
      icon: Icons.waves,
      // The lessons here are pendulums and springs — simple harmonic motion.
      // The name is kept by product decision; these aliases carry the terms
      // students are more likely to search for.
      aliases: <String>[
        'Oscillations',
        'Simple Harmonic Motion',
        'SHM',
        'Waves and Oscillations',
        'Springs',
        'Pendulums',
      ],
    ),
    TopicInfo(
      key: CurriculumTopicFilters.electrostatics,
      name: 'Electrostatics',
      shortDescription:
          "Electric fields and forces using Coulomb's law, analyze charge "
          'distributions, determine electric potential and energy, solve '
          'capacitor problems, and understand electric field mapping through '
          'equipotential surfaces.',
      imageAsset: 'images/electrostatics.png',
      icon: Icons.bolt,
      aliases: <String>["Coulomb's Law", 'Electric Fields', 'Charges'],
    ),
    TopicInfo(
      key: CurriculumTopicFilters.rotationalMotion,
      name: 'Rotational Motion',
      shortDescription:
          'Angular velocity, torque calculations, moment of inertia for '
          'different shapes, angular momentum conservation, and rotational '
          'kinetic energy. Learn to solve problems with rotating objects and '
          'analyze gyroscopic motion.',
      imageAsset: 'images/rotational_motion.jpg',
      icon: Icons.rotate_right,
      aliases: <String>[
        'Torque',
        'Circular Motion',
        'Circular Motion and Gravitation',
        'Angular Momentum',
      ],
    ),
    TopicInfo(
      key: CurriculumTopicFilters.thermalPhysics,
      name: 'Thermal Physics',
      shortDescription:
          'Study of heat, temperature, and thermodynamic laws. Calculate heat '
          'capacity, analyze phase changes, understand entropy, and solve '
          'problems involving thermodynamic cycles and efficiency.',
      imageAsset: 'images/thermal_physics.jpg',
      icon: Icons.thermostat,
      aliases: <String>['Thermodynamics', 'Thermal Energy', 'Heat'],
    ),
    TopicInfo(
      key: CurriculumTopicFilters.modernPhysics,
      name: 'Modern Physics',
      shortDescription:
          'Principles of modern physics, including special relativity, quantum '
          'mechanics, atomic structure, and nuclear physics. Understand '
          'wave-particle duality, the uncertainty principle, and applications '
          'of quantum theory in technology and research.',
      imageAsset: 'images/modern_physics.jpg',
      // Was Icons.rectangle — the same copy-paste placeholder as Dynamics.
      icon: Icons.blur_on,
      aliases: <String>[
        'Quantum Mechanics',
        'Nuclear Physics',
        'Modern Physics and Quantum Mechanics',
        'Nuclear and Modern Physics',
        'Relativity',
      ],
    ),
    TopicInfo(
      key: CurriculumTopicFilters.other,
      name: 'Other Physics Topics',
      // Not "Other": that name is meaningless once it appears on its own in a
      // breadcrumb, a page heading, or a browser tab.
      shortDescription:
          'Additional physics topics including mathematical methods, '
          'measurement techniques, nuclear physics, astrophysics, and the '
          'relationship between physics and society',
      imageAsset: 'images/other.jpg',
      icon: Icons.lightbulb,
      aliases: <String>['Other', 'Miscellaneous', 'Astrophysics'],
    ),
    TopicInfo(
      key: CurriculumTopicFilters.sampleVideos,
      name: 'Sample Videos',
      shortDescription:
          'A short preview of Vera lessons, free to watch without an account.',
      imageAsset: 'images/intro_to_physics.jpg',
      // Was Icons.lightbulb, identical to Other Physics Topics.
      icon: Icons.play_circle_outline,
      showInExplore: false,
      aliases: <String>['Samples', 'Preview', 'Free Videos'],
    ),
  ];

  /// Topics shown in the Explore grid, in relevance order.
  static List<TopicInfo> get exploreTopics =>
      all.where((TopicInfo t) => t.showInExplore).toList(growable: false);

  /// The five topics featured in the Home page Explore strip.
  ///
  /// Previously this was two parallel lists in `globals.dart` — one of names,
  /// one of page widgets — joined by array index, so adding a topic to one and
  /// not the other silently sent students to a different lesson than the one
  /// they tapped. A key resolves to both the name and the page, so the two
  /// cannot drift apart.
  static const List<String> exploreStripKeys = <String>[
    CurriculumTopicFilters.kinematics,
    CurriculumTopicFilters.workAndEnergy,
    CurriculumTopicFilters.harmonics,
    CurriculumTopicFilters.momentumAndCollisions,
    CurriculumTopicFilters.dynamics,
  ];

  static TopicInfo? byKey(String topicKey) {
    for (final TopicInfo topic in all) {
      if (topic.key == topicKey) return topic;
    }
    return null;
  }

  /// Canonical display name, or `''` if the key is unknown.
  ///
  /// Returning empty rather than throwing preserves the previous
  /// `VideoCatalog.topicTitle` contract, so a bad deep link degrades to a blank
  /// heading instead of a crash.
  static String nameOf(String topicKey) => byKey(topicKey)?.name ?? '';

  static String descriptionOf(String topicKey) =>
      byKey(topicKey)?.shortDescription ?? '';
}
