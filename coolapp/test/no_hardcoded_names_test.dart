import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:coolapp/views/pages/videos/physics_videos/course_registry.dart';
import 'package:coolapp/views/pages/videos/physics_videos/topic_registry.dart';

/// Scans the source for topic and course names written as string literals.
///
/// This is the only guard that actually stops the bug from coming back. Every
/// other test checks the registry is internally consistent; nothing else notices
/// when someone copy-pastes `'Momentum'` into a new page and it starts
/// disagreeing with Explore again.
///
/// Crude by design — a regex over file text, not real Dart parsing. It matches
/// only *exact* canonical names, never aliases: aliases legitimately appear as
/// lesson titles (harmonics.dart has a lesson called "Pendulums", which is an
/// alias of Harmonics), and banning those would be wrong.
void main() {
  // Presentation is defined in these two files; everywhere else must look it up.
  const Set<String> registrySources = <String>{
    'lib/views/pages/videos/physics_videos/topic_registry.dart',
    'lib/views/pages/videos/physics_videos/course_registry.dart',
  };

  late final Set<String> canonicalNames = <String>{
    ...TopicRegistry.all.map((TopicInfo t) => t.name),
    ...CourseRegistry.all.map((CourseInfo c) => c.name),
  };

  /// Matches single- and double-quoted single-line Dart string literals.
  final RegExp literal = RegExp(r"'([^'\n]*)'" r'|"([^"\n]*)"');

  test('no topic or course name is hardcoded outside the registries', () {
    final Directory lib = Directory('lib');
    expect(lib.existsSync(), isTrue,
        reason: 'run this from the package root (coolapp/)');

    final List<String> offences = <String>[];

    for (final FileSystemEntity entity in lib.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final String rel = entity.path.replaceAll(r'\', '/');
      if (registrySources.contains(rel)) continue;

      final String source = entity.readAsStringSync();
      for (final RegExpMatch m in literal.allMatches(source)) {
        final String value = m.group(1) ?? m.group(2) ?? '';
        if (!canonicalNames.contains(value)) continue;
        final int line = source.substring(0, m.start).split('\n').length;
        offences.add('$rel:$line  "$value"');
      }
    }

    expect(
      offences,
      isEmpty,
      reason: 'These are display names written inline instead of read from '
          'TopicRegistry/CourseRegistry. Use TopicRegistry.nameOf(key) or '
          'CourseRegistry.nameOf(key) so the name has exactly one '
          'definition:\n  ${offences.join('\n  ')}',
    );
  });

  test('the scanner actually works', () {
    // Guards against the check silently passing because the regex broke or the
    // registries came back empty — a green test that verifies nothing is worse
    // than no test.
    expect(canonicalNames, hasLength(greaterThanOrEqualTo(20)));
    expect(canonicalNames, contains('Momentum and Collisions'));
    expect(canonicalNames, contains('AP Physics 1'));

    final String registrySource =
        File('lib/views/pages/videos/physics_videos/topic_registry.dart')
            .readAsStringSync();
    final Iterable<String> found = literal
        .allMatches(registrySource)
        .map((RegExpMatch m) => m.group(1) ?? m.group(2) ?? '');
    expect(found, contains('Momentum and Collisions'),
        reason: 'the literal regex no longer matches Dart strings');
  });
}
