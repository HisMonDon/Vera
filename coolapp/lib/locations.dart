import 'package:beamer/beamer.dart';
import 'package:coolapp/views/widget_tree.dart';
import 'package:flutter/material.dart';

class HomeLocation extends BeamLocation<BeamState> {
  HomeLocation([super.routeInformation]);

  @override
  List<String> get pathPatterns => ['/:pageName'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pageName = state.pathParameters['pageName'];
    final initialPath =
        (pageName == null || pageName.isEmpty) ? 'home' : pageName;

    return [
      BeamPage(
        key: ValueKey(initialPath),
        title: _titleForPage(initialPath),
        child: WidgetTree(pageName: initialPath),
      ),
    ];
  }

  String _titleForPage(String pageName) {
    switch (pageName) {
      case 'get-started':
        return 'Get Started';
      case 'profile':
        return 'Profile';
      case 'videos':
        return 'Videos';
      case 'settings':
        return 'Settings';
      case 'home':
      default:
        return 'Home';
    }
  }
}
