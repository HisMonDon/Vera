import 'package:beamer/beamer.dart';
import 'package:coolapp/views/widget_tree.dart';
import 'package:flutter/material.dart';

class HomeLocation extends BeamLocation<BeamState> {
  HomeLocation([super.routeInformation]);

  @override
  List<String> get pathPatterns => ['/', '/:pageName'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
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
}
