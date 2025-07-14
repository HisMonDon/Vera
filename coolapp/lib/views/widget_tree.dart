import 'package:coolapp/views/pages/about_this_app/about_this_app_page.dart';
import 'package:coolapp/views/pages/help_page/help_page.dart';
import 'package:coolapp/views/pages/home/home_page.dart';
import 'package:coolapp/views/pages/videos/locked_page.dart';
import 'package:coolapp/views/pages/profile_page/profile_page.dart';
import 'package:coolapp/views/pages/videos/videos_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:coolapp/globals.dart' as globals;

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: globals.selectedIndex);

    // Listen to controller changes to update global index
    _controller.addListener(() {
      if (globals.selectedIndex != _controller.index) {
        setState(() {
          globals.selectedIndex = _controller.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Wrap each screen with a Scaffold that has the AppBar
  List<Widget> _buildScreens() {
    List<Widget> screens = [
      AboutThisAppPage(),
      ProfilePage(),
      HomePage(),
      VideosPage(),
      HelpPage(),
    ];

    // Wrap each screen with a Scaffold and AppBar
    return screens
        .map(
          (screen) => Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text("Vera"),
              backgroundColor: const Color.fromARGB(255, 15, 48, 40),
            ),
            body: screen,
          ),
        )
        .toList();
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.verified_user_rounded),
        title: "About",
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white,
        iconSize: 23,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person_rounded),
        title: "Profile",
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home_rounded),
        title: "Home",
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.ondemand_video_rounded),
        title: "Videos",
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.question_answer_rounded),
        title: "Help",
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      backgroundColor: const Color.fromARGB(255, 15, 48, 40),
      navBarStyle: NavBarStyle.style1,
    );
  }
}
