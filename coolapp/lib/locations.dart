import 'package:beamer/beamer.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/views/pages/videos/lesson_summary_content.dart';
import 'package:coolapp/views/pages/videos/physics_videos/topic_registry.dart';
import 'package:coolapp/views/pages/videos/physics_videos/video_catalog.dart';
import 'package:coolapp/views/pages/videos/summary_page.dart';
import 'package:coolapp/views/pages/videos/video_player.dart';
import 'package:coolapp/views/widget_tree.dart';
import 'package:flutter/material.dart';

class HomeLocation extends BeamLocation<BeamState> {
  HomeLocation([super.routeInformation]);

  @override
  List<String> get pathPatterns => [
        '/',
        '/:pageName',
        '/videos/watch/:topicKey/:curriculumKey',
        '/videos/play/:topicKey/:curriculumKey',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final topicKey = state.pathParameters['topicKey'];
    final curriculumKey = state.pathParameters['curriculumKey'];
    final isPlayerRoute = state.uri.pathSegments.contains('play');
    final videosRootPage = BeamPage(
      key: const ValueKey('videos'),
      title: 'Vera',
      child: const WidgetTree(pageName: 'videos'),
    );
    if (topicKey != null && curriculumKey != null) {
      return [
        videosRootPage,
        _buildVideoPage(
          topicKey,
          curriculumKey,
          showPlayer: isPlayerRoute,
        ),
      ];
    }

    final pageName = state.pathParameters['pageName'];
    final current = (pageName == null || pageName.isEmpty) ? 'home' : pageName;

    return [
      BeamPage(
        key: ValueKey(current),
        title: 'Vera',
        child: WidgetTree(pageName: current),
      ),
    ];
  }

  BeamPage _buildVideoPage(
    String topicKey,
    String curriculumKey, {
    required bool showPlayer,
  }) {
    Map<String, dynamic>? entry;
    String topicTitle;
    Map<String, dynamic>? nextEntry;

    if (topicKey == 'video_of_the_day') {
      for (final video in globals.videoOfTheDay) {
        if (video['curriculumKey'] == curriculumKey) {
          entry = video;
          break;
        }
      }
      // Was `entry['videoUnit']`, a free-text field that drifted from every
      // other surface (it read 'Oscillations', a name used nowhere else).
      topicTitle = TopicRegistry.nameOf(
        (entry?['topicKey'] as String?) ?? '',
      );
    } else {
      entry = VideoCatalog.resolve(topicKey, curriculumKey);
      topicTitle = VideoCatalog.topicTitle(topicKey);
      nextEntry = VideoCatalog.next(topicKey, curriculumKey);
    }

    if (entry == null) {
      return BeamPage(
        key: ValueKey('video-not-found-$topicKey-$curriculumKey'),
        title: 'Video not found',
        child: _VideoNotFoundPage(),
      );
    }
    final videoEntry = entry;

    // The featured-video list uses its own curriculum keys, so resolve the real
    // lesson through the shared video URL to find that lesson's captions.
    String captionTopicKey = topicKey;
    String captionCurriculumKey = curriculumKey;
    if (topicKey == 'video_of_the_day') {
      final located =
          VideoCatalog.locate((videoEntry['videoLink'] as String?) ?? '');
      captionTopicKey = located?.topicKey ?? '';
      captionCurriculumKey = located?.curriculumKey ?? '';
    }

    globals.videoLink = (videoEntry['videoLink'] as String?) ?? '';
    globals.unitTitle = (videoEntry['title'] as String?) ??
        (videoEntry['videoTitle'] as String?) ??
        '';
    globals.topicTitle = topicTitle;
    globals.exitCourse();
    globals.nextVideoTitle = (nextEntry?['title'] as String?) ?? 'last_one';
    final summary = LessonSummaryContent.fromVideo(
      topicKey: topicKey,
      video: videoEntry,
    );

    return BeamPage(
      key: ValueKey(
        '${showPlayer ? 'video-player' : 'video-summary'}-$topicKey-$curriculumKey',
      ),
      title: globals.unitTitle,
      child: showPlayer
          ? VideoPlayerScreen(
              topicKey: captionTopicKey,
              curriculumKey: captionCurriculumKey,
            )
          : Builder(
              builder: (context) => SummaryPage(
                lessonTitle: globals.unitTitle,
                topicTitle: topicTitle,
                covered: summary.covered,
                prerequisites: summary.prerequisites,
                onStartLesson: () {
                  context.beamToNamed(
                    '/videos/play/$topicKey/$curriculumKey',
                  );
                },
              ),
            ),
    );
  }
}

class _VideoNotFoundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Video not found'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.beamToNamed('/videos'),
              child: const Text('Back to Videos'),
            ),
          ],
        ),
      ),
    );
  }
}
