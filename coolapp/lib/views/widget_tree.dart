import 'package:coolapp/views/pages/about_this_app_page.dart';
import 'package:coolapp/views/pages/help_page.dart';
import 'package:coolapp/views/pages/home_page.dart';
import 'package:coolapp/views/pages/locked_page.dart';
import 'package:coolapp/views/pages/profile_page.dart';
import 'package:coolapp/views/pages/videos_page.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  int _selectedIndex = 1;
  static final List<Widget> _pages = <Widget>[
    AboutThisAppPage(),
    ProfilePage(),
    HomePage(),
    VideosPage(),
    HelpPage(),
    LockedPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _pages[_selectedIndex]),

      appBar: AppBar(
        centerTitle: true,
        title: Text("Vera"),
        backgroundColor: const Color.fromARGB(255, 15, 48, 40),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.verified_user),
            label: 'About this App',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(
            icon: Icon(Icons.home, size: 35),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.ondemand_video),
            label: 'Videos',
          ),
          NavigationDestination(
            icon: Icon(Icons.question_answer),
            label: 'Help',
          ),
        ],
      ),
    );
  }
}
