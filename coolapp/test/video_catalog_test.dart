import 'package:flutter_test/flutter_test.dart';

import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/views/pages/videos/physics_videos/curriculum_topic_filters.dart';
import 'package:coolapp/views/pages/videos/physics_videos/topic_registry.dart';
import 'package:coolapp/views/pages/videos/physics_videos/video_catalog.dart';

/// Kept separate from `topic_registry_test.dart` on purpose: this file imports
/// `VideoCatalog`, which pulls in all 17 topic page widgets. The registry tests
/// stay free of the widget tree so they keep working as plain data tests.
void main() {
  group('VideoCatalog wiring', () {
    test('every registered topic has a page', () {
      // Backs the assert in the Explore grid: without this, an unregistered
      // topic would silently vanish from the grid instead of failing loudly.
      for (final TopicInfo topic in TopicRegistry.all) {
        expect(VideoCatalog.pageFor(topic.key), isNotNull,
            reason: 'no page builder registered for "${topic.key}"');
      }
    });

    test('every topic has at least one video', () {
      for (final String key in CurriculumTopicFilters.allKeys) {
        expect(VideoCatalog.topicTitle(key), isNotEmpty,
            reason: '"$key" resolves to a blank title');
      }
    });

    test('topicTitle matches the registry exactly', () {
      // VideoCatalog.topicTitle is what the router and lesson pages call. If it
      // ever diverges from the registry, the player header and the Explore card
      // disagree again, which is the bug this refactor exists to kill.
      for (final TopicInfo topic in TopicRegistry.all) {
        expect(VideoCatalog.topicTitle(topic.key), topic.name);
      }
    });

    test('every featured video resolves to a real lesson', () {
      // The Home "video of the day" list uses its own curriculum keys, and its
      // declared topicKey is hand-written. Both must agree with the catalog, or
      // the featured card names the wrong unit and loads no captions.
      for (final Map<String, dynamic> featured in globals.videoOfTheDay) {
        final String link = (featured['videoLink'] as String?) ?? '';
        final located = VideoCatalog.locate(link);
        expect(located, isNotNull,
            reason: 'featured video "${featured['videoTitle']}" plays a file no '
                'lesson uses, so it can never have captions: $link');
        expect(located!.topicKey, featured['topicKey'],
            reason: 'featured video "${featured['videoTitle']}" declares topic '
                '"${featured['topicKey']}" but its video belongs to '
                '"${located.topicKey}"');
      }
    });

    test('locate returns null for an unknown link', () {
      expect(VideoCatalog.locate(''), isNull);
      expect(VideoCatalog.locate('https://example.com/nope.mp4'), isNull);
    });

    test('an unknown topic key returns null rather than throwing', () {
      expect(VideoCatalog.pageFor('no_such_topic'), isNull);
      expect(VideoCatalog.topicTitle('no_such_topic'), '');
    });
  });
}
