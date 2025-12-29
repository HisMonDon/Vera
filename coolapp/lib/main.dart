import 'package:beamer/beamer.dart';
import 'package:coolapp/locations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/services/auth_service.dart';
import 'package:media_kit/media_kit.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

int dailyRandom(int max) {
  final now = DateTime.now();
  final dateString = "${now.year}-${now.month}-${now.day}";
  final bytes = utf8.encode(dateString);
  final hash = sha256.convert(bytes).toString();
  final num = int.parse(hash.substring(0, 8), radix: 16) % max + 1;
  return num;
}

void main() async {
  globals.videoOfTheDayIndex = dailyRandom(3) -
      1; //change the number inside daily random everytime you change the global videoOfTheDays
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  globals.isLight = prefs.getBool('isLightTheme') ?? false;

  await _initializeAuthState();
  runApp(MyApp());
}

Future _initializeAuthState() async {
  try {
    final authService = AuthService();
    globals.isLoggedIn = await authService.isLoggedIn();
    print('App initialized with isLoggedIn: ${globals.isLoggedIn}');
    print('App initialized with isLight: ${globals.isLight}');
  } catch (e) {
    print('Error initializing auth state: $e');
    globals.isLoggedIn = false;
  }
}

class MyApp extends StatefulWidget {
  MyApp({super.key});
  static final ValueNotifier themeNotifier = ValueNotifier(
    globals.isLight,
  );

  static void updateTheme(bool isLight) {
    globals.isLight = isLight;
    themeNotifier.value = isLight;
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final routerDelegate = BeamerDelegate(
    initialPath: '/',
    locationBuilder: BeamerLocationBuilder(
      beamLocations: [
        HomeLocation(),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: MyApp.themeNotifier,
      builder: (context, isLight, child) {
        return MaterialApp.router(
          routerDelegate: routerDelegate,
          routeInformationParser: BeamerParser(),
          backButtonDispatcher:
              BeamerBackButtonDispatcher(delegate: routerDelegate),
          title: 'Vera',
          debugShowCheckedModeBanner: false,
          theme: globals.isLight
              ? ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color.fromARGB(255, 0, 34, 20),
                  ),
                  textTheme: GoogleFonts.interTextTheme(
                    ThemeData.dark().textTheme,
                  ),
                  useMaterial3: false,
                  scaffoldBackgroundColor: const Color.fromARGB(
                    73,
                    19,
                    168,
                    106,
                  ),
                )
              : ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.teal,
                    brightness: Brightness.dark,
                  ),
                  textTheme: GoogleFonts.interTextTheme(
                    ThemeData.dark().textTheme,
                  ),
                ),
        );
      },
    );
  }
}
