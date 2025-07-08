import 'package:coolapp/views/pages/home_page.dart';
import 'package:coolapp/views/pages/profile_page.dart';
import 'package:coolapp/views/pages/videos_page.dart';
import 'package:flutter/material.dart';
import 'package:coolapp/widgets/navbar_widget.dart';

List<Widget> pages = [HomePage(), ProfilePage(), VideosPage()]; //update pages

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vera'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      /*drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 2, 78, 72),
        child: Column(
          children: [
            const DrawerHeader(child: Text('Options')),
            const ListTile(title: Text('Login')),
          ],
        ),
      ),*/
      body: pages.elementAt(1),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
