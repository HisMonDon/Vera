import 'package:coolapp/views/pages/about_this_app/about_this_app_page.dart';
import 'package:coolapp/views/pages/help_page/help_page.dart';
import 'package:coolapp/views/pages/home/home_page.dart';
import 'package:coolapp/views/pages/profile_page/profile_page.dart';
import 'package:coolapp/views/pages/videos/not_logged_in.dart';
import 'package:coolapp/views/pages/videos/paid_videos.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/views/pages/videos/videos_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:coolapp/globals.dart' as globals;

class WidgetTree extends StatefulWidget {
  final int initialIndex;
  const WidgetTree({super.key, this.initialIndex = 0});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  late PersistentTabController _controller;
  late VoidCallback _tabListener;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: widget.initialIndex);
    globals.selectedIndex =
        widget.initialIndex; // Sync global state with initialIndex

    _tabListener = () {
      if (mounted && globals.selectedIndex != _controller.index) {
        setState(() {
          globals.selectedIndex = _controller.index;
        });
      }
    };
    _controller.addListener(_tabListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_tabListener);
    super.dispose();
  }

  // Wrap each screen with a Scaffold that has the AppBar
  List<Widget> _buildScreens() {
    // Use appropriate video page based on login statusR
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
      // Rebuild the screens when the login status changes
      onItemSelected: (index) {
        if (index == 3) {
          // Videos tab
          setState(() {
            // This forces the screen to be rebuilt with the current login status
          });
        }
      },
    );
  }
}
