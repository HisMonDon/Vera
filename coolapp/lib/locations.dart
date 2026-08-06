import 'package:beamer/beamer.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/views/pages/videos/physics_videos/video_catalog.dart';
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
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final topicKey = state.pathParameters['topicKey'];
    final curriculumKey = state.pathParameters['curriculumKey'];
    if (topicKey != null && curriculumKey != null) {
      return [_buildVideoPage(topicKey, curriculumKey)];
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

  BeamPage _buildVideoPage(String topicKey, String curriculumKey) {
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
      topicTitle = '';
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

    globals.videoLink = (entry['videoLink'] as String?) ?? '';
    globals.unitTitle =
        (entry['title'] as String?) ?? (entry['videoTitle'] as String?) ?? '';
    globals.topicTitle = topicTitle;
    globals.courseTitle = '';
    globals.nextVideoTitle =
        (nextEntry?['title'] as String?) ?? 'last_one';

    return BeamPage(
      key: ValueKey('video-$topicKey-$curriculumKey'),
      title: globals.unitTitle,
      child: const VideoPlayerScreen(),
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
