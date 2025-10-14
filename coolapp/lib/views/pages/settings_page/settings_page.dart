import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/main.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      globals.isLight = prefs.getBool('isLightTheme') ?? true;
    });
  }

  Future<void> _toggleTheme(bool isLight) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLightTheme', isLight);

    globals.isLight = isLight;

    setState(() {
      globals.isLight = isLight;
    });
    MyApp.updateTheme(isLight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TimedAppBar(),
      body: Column(
        children: [
          if (kIsWeb)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'Vera',
                    style: GoogleFonts.mPlus1(
                      fontSize: 48.0,
                      fontWeight: FontWeight.bold,
                      color: globals.isLight
                          ? Color.fromARGB(255, 15, 48, 40)
                          : Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: globals.isLight
                          ? Color.fromARGB(255, 15, 48, 40)
                          : Color.fromARGB(255, 167, 198, 131),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Web',
                      style: GoogleFonts.montserrat(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: globals.isLight
                            ? Colors.white
                            : Color.fromARGB(255, 15, 48, 40),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: GoogleFonts.mPlus1(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: globals.isLight
                          ? const Color.fromARGB(255, 15, 48, 40)
                          : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildSettingsCard(
                    title: 'Appearance',
                    children: [_buildThemeToggle()],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: globals.isLight
            ? const Color.fromARGB(255, 168, 230, 207)
            : const Color.fromARGB(255, 8, 77, 63),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: globals.isLight
                    ? const Color.fromARGB(255, 15, 48, 40)
                    : Colors.white,
              ),
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildThemeToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                globals.isLight ? Icons.light_mode : Icons.dark_mode,
                color: globals.isLight
                    ? const Color.fromARGB(255, 15, 48, 40)
                    : Colors.white,
              ),
              const SizedBox(width: 12),
              Text(
                'Light Mode',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: globals.isLight
                      ? const Color.fromARGB(255, 15, 48, 40)
                      : Colors.white,
                ),
              ),
            ],
          ),
          Switch(
            value: globals.isLight,
            onChanged: _toggleTheme,
            activeColor: const Color.fromARGB(255, 167, 198, 131),
            activeTrackColor: const Color.fromARGB(255, 15, 48, 40),
          ),
        ],
      ),
    );
  }
}
