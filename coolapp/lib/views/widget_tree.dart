import 'package:beamer/beamer.dart';
import 'package:coolapp/views/pages/get_started/get_started.dart';
import 'package:coolapp/views/pages/home/home_page.dart';
import 'package:coolapp/views/pages/profile_page/profile_page.dart';
import 'package:coolapp/views/pages/settings_page/settings_page.dart';
import 'package:coolapp/views/pages/videos/video_pages/courses_page.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:coolapp/globals.dart' as globals;
import 'dart:async';

//change main theme colors and navbar stuff here
class WidgetTree extends StatefulWidget {
  final String pageName;
  const WidgetTree({super.key, required this.pageName});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  late PersistentTabController _controller;
  TimeOfDay _currentTime = TimeOfDay.now();

  Timer? _timer;

  final List<String> _pageKeys = [
    'get-started',
    'profile',
    'home',
    'videos',
    'settings'
  ];

  @override
  void initState() {
    super.initState();
    final initialIndex = _pageKeys.indexOf(widget.pageName);
    _controller = PersistentTabController(
        initialIndex: initialIndex < 0 ? 2 : initialIndex);
    globals.selectedIndex = _controller.index;

    _currentTime = TimeOfDay.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (mounted) {
        setState(() {
          _currentTime = TimeOfDay.now();
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant WidgetTree oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageName != widget.pageName) {
      final newIndex = _pageKeys.indexOf(widget.pageName);
      if (newIndex >= 0 && _controller.index != newIndex) {
        setState(() {
          _controller.index = newIndex;
          globals.selectedIndex = newIndex;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  List<Widget> _buildScreens() {
    return [
      AboutThisAppPage(),
      ProfilePage(),
      HomePage(),
      const CoursePage(),
      const HelpPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.question_mark),
        title: "Get Started",
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
        icon: const Icon(Icons.settings),
        title: "Settings",
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white,
      ),
    ];
  }

  void _onItemSelected(int index) {
    if (globals.selectedIndex != index) {
      final path = _pageKeys[index] == 'home' ? '/' : '/${_pageKeys[index]}';
      context.beamToNamed(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Update welcome messages
    if (_currentTime.hour < 12) {
      globals.welcomeText = "Good Morning, ${globals.userName}";
    } else if (_currentTime.hour < 17) {
      globals.welcomeText = "Good Afternoon, ${globals.userName}";
    } else {
      globals.welcomeText = "Good Evening, ${globals.userName}";
    }
    if (_currentTime.hour < 5) {
      globals.welcomeText = "Midnight lesson?";
    }
    if (_currentTime.hour < 12) {
      globals.motivationalMessage = "Start off your day with fresh knowledge.";
    } else if (_currentTime.hour < 17) {
      globals.motivationalMessage = "Let's make this afternoon productive.";
    } else if (_currentTime.hour < 20) {
      globals.motivationalMessage = "What will you learn today?";
    } else {
      globals.motivationalMessage = "One more video before you sleep?";
    }

    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      backgroundColor: const Color.fromARGB(255, 15, 48, 40),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      navBarStyle: NavBarStyle.style1,
      onItemSelected: _onItemSelected,
    );
  }
}
