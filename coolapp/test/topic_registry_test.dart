import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:coolapp/views/pages/videos/physics_videos/course_registry.dart';
import 'package:coolapp/views/pages/videos/physics_videos/curriculum_topic_filters.dart';
import 'package:coolapp/views/pages/videos/physics_videos/topic_registry.dart';

/// Guards the invariant this whole refactor exists to establish: a topic key
/// resolves to exactly one display name, everywhere, forever.
///
/// User testing found students opening the wrong lesson because the same topic
/// was called different things on Home, Explore, the topic page and the player.
/// These are pure Dart tests (no `pumpWidget`), so they stay fast and do not
/// need the font-loading setup that widget tests require.
void main() {
  group('TopicRegistry identity', () {
    test('keys are unique', () {
      final List<String> keys =
          TopicRegistry.all.map((TopicInfo t) => t.key).toList();
      expect(keys.toSet().length, keys.length,
          reason: 'a topic key is registered twice: $keys');
    });

    test('registry covers exactly the curriculum topic keys', () {
      final Set<String> registryKeys =
          TopicRegistry.all.map((TopicInfo t) => t.key).toSet();

      expect(
        registryKeys.difference(CurriculumTopicFilters.allKeys),
        isEmpty,
        reason: 'registry has topics that are not real curriculum keys',
      );
      expect(
        CurriculumTopicFilters.allKeys.difference(registryKeys),
        isEmpty,
        reason: 'a curriculum topic has no registry entry, so it would render '
            'with a blank name',
      );
    });

    test('display names are unique', () {
      final List<String> names =
          TopicRegistry.all.map((TopicInfo t) => t.name).toList();
      final Set<String> seen = <String>{};
      final List<String> dupes = <String>[];
      for (final String name in names) {
        if (!seen.add(name)) dupes.add(name);
      }
      expect(dupes, isEmpty,
          reason: 'two topics share a display name, so students cannot tell '
              'them apart: $dupes');
    });

    test('the registry cannot be sorted or mutated in place', () {
      // This is the structural fix for the original bug. The Explore grid used
      // to call .sort() straight on its topic list, which reordered the shared
      // list permanently — and the only way back to "Relevance" was a second
      // hardcoded copy, which then drifted and gave the same topic two
      // different names depending on whether you had touched the dropdown.
      //
      // `TopicRegistry.all` is a const list, so that mistake is now a runtime
      // error rather than silent corruption. Callers sort `List.of(...)`.
      expect(
        () => TopicRegistry.all.sort((TopicInfo a, TopicInfo b) => 0),
        throwsUnsupportedError,
      );
      expect(() => TopicRegistry.all.removeLast(), throwsUnsupportedError);
      expect(
        () => TopicRegistry.all[0] = TopicRegistry.all[1],
        throwsUnsupportedError,
      );
    });

    test('sorting a copy leaves the registry order intact', () {
      final List<String> before =
          TopicRegistry.all.map((TopicInfo t) => t.key).toList();
      final List<TopicInfo> copy = List<TopicInfo>.of(TopicRegistry.all)
        ..sort((TopicInfo a, TopicInfo b) => a.name.compareTo(b.name));

      expect(copy.map((TopicInfo t) => t.name).toList(),
          equals(copy.map((TopicInfo t) => t.name).toList()..sort()));
      expect(TopicRegistry.all.map((TopicInfo t) => t.key).toList(), before,
          reason: 'sorting a copy changed the registry');
    });

    test('every key resolves and nameOf round-trips', () {
      for (final TopicInfo topic in TopicRegistry.all) {
        expect(TopicRegistry.byKey(topic.key), same(topic));
        expect(TopicRegistry.nameOf(topic.key), topic.name);
      }
    });

    test('an unknown key degrades to empty, not an exception', () {
      // Preserves the old VideoCatalog.topicTitle contract: a stale deep link
      // shows a blank heading rather than crashing the page.
      expect(TopicRegistry.byKey('no_such_topic'), isNull);
      expect(TopicRegistry.nameOf('no_such_topic'), '');
      expect(TopicRegistry.descriptionOf('no_such_topic'), '');
    });
  });

  group('TopicRegistry content quality', () {
    test('no field is empty or padded', () {
      for (final TopicInfo t in TopicRegistry.all) {
        expect(t.name.trim(), isNotEmpty, reason: '${t.key} has no name');
        expect(t.name, t.name.trim(),
            reason: '${t.key} name has leading/trailing whitespace');
        expect(t.name.contains('  '), isFalse,
            reason: '${t.key} name has a double space');
        expect(t.shortDescription.trim(), isNotEmpty,
            reason: '${t.key} has no description');
        expect(t.shortDescription, t.shortDescription.trim(),
            reason: '${t.key} description has leading/trailing whitespace');
        expect(t.imageAsset.trim(), isNotEmpty,
            reason: '${t.key} has no image');
      }
    });

    test('no placeholder or context-free names', () {
      // "Other" alone is meaningless in a breadcrumb, a page heading or a
      // browser tab, which is exactly where these names get rendered.
      const List<String> banned = <String>['Other', 'TODO', 'TBD', 'Untitled'];
      for (final TopicInfo t in TopicRegistry.all) {
        expect(banned.contains(t.name), isFalse,
            reason: '${t.key} uses the placeholder name "${t.name}"');
      }
    });

    test('aliases never collide with a canonical name', () {
      final Map<String, String> canonical = <String, String>{
        for (final TopicInfo t in TopicRegistry.all) t.name: t.key,
      };
      for (final TopicInfo t in TopicRegistry.all) {
        for (final String alias in t.aliases) {
          final String? owner = canonical[alias];
          expect(owner, isNull,
              reason: '${t.key} claims alias "$alias", which is the canonical '
                  'name of $owner');
        }
      }
    });

    test('no alias is claimed by two topics', () {
      final Map<String, String> owners = <String, String>{};
      for (final TopicInfo t in TopicRegistry.all) {
        for (final String alias in t.aliases) {
          expect(owners.containsKey(alias), isFalse,
              reason: 'alias "$alias" is claimed by both ${owners[alias]} and '
                  '${t.key}, so a search for it is ambiguous');
          owners[alias] = t.key;
        }
      }
    });

    test('image assets exist on disk', () {
      // Catches a typo that would otherwise surface only as a grey box in the
      // Explore grid. `flutter test` runs from the package root.
      for (final TopicInfo t in TopicRegistry.all) {
        expect(File(t.imageAsset).existsSync(), isTrue,
            reason: '${t.key} points at missing asset ${t.imageAsset}');
      }
    });
  });

  group('Explore surfaces', () {
    test('explore grid is non-empty and hides only Sample Videos', () {
      final List<TopicInfo> shown = TopicRegistry.exploreTopics;
      expect(shown, isNotEmpty);
      final Set<String> hidden = TopicRegistry.all
          .where((TopicInfo t) => !t.showInExplore)
          .map((TopicInfo t) => t.key)
          .toSet();
      expect(hidden, <String>{CurriculumTopicFilters.sampleVideos});
    });

    test('home explore strip keys all resolve', () {
      // These used to be two parallel arrays joined by index, so a mismatch
      // sent students to a different lesson than the one they tapped.
      for (final String key in TopicRegistry.exploreStripKeys) {
        expect(TopicRegistry.byKey(key), isNotNull,
            reason: 'explore strip references unknown topic "$key"');
      }
      expect(TopicRegistry.exploreStripKeys.toSet().length,
          TopicRegistry.exploreStripKeys.length,
          reason: 'the explore strip lists the same topic twice');
    });
  });

  group('CourseRegistry', () {
    test('keys are unique and match allKeys', () {
      final List<String> keys =
          CourseRegistry.all.map((CourseInfo c) => c.key).toList();
      expect(keys.toSet().length, keys.length, reason: 'duplicate course key');
      expect(keys.toSet(), CourseRegistry.allKeys);
    });

    test('display names are unique and non-empty', () {
      final List<String> names =
          CourseRegistry.all.map((CourseInfo c) => c.name).toList();
      expect(names.toSet().length, names.length);
      for (final CourseInfo c in CourseRegistry.all) {
        expect(c.name.trim(), isNotEmpty);
        expect(c.description.trim(), isNotEmpty);
      }
    });

    test('course images exist on disk', () {
      for (final CourseInfo c in CourseRegistry.all) {
        expect(File(c.imageAsset).existsSync(), isTrue,
            reason: '${c.key} points at missing asset ${c.imageAsset}');
      }
    });

    test('not being in a course resolves to an empty name', () {
      expect(CourseRegistry.nameOf(''), '');
      expect(CourseRegistry.byKey('no_such_course'), isNull);
    });
  });

  group('Course policy coverage', () {
    test('every course lists every topic key', () {
      // A missing key falls through to "allow all units", which is silent and
      // wrong: it shows students videos their course does not cover. Grade 11
      // was missing thermalPhysics this way.
      final Map<String, Map<String, Set<String>>> policy =
          CurriculumTopicFilters.coursePolicy;
      expect(policy, isNotEmpty);

      // The table is keyed by stable course keys, never display names. If it
      // were keyed by name, renaming a course would silently unfilter it.
      expect(policy.keys.toSet(), CourseRegistry.allKeys,
          reason: 'course policy keys have drifted from CourseRegistry');

      policy.forEach((String course, Map<String, Set<String>> topics) {
        final Set<String> missing =
            CurriculumTopicFilters.allKeys.difference(topics.keys.toSet());
        expect(missing, isEmpty,
            reason: '"$course" is missing topic keys $missing, so those topics '
                'are unfiltered by accident');

        final Set<String> unknown =
            topics.keys.toSet().difference(CurriculumTopicFilters.allKeys);
        expect(unknown, isEmpty,
            reason: '"$course" references unknown topic keys $unknown');
      });
    });
  });
}
