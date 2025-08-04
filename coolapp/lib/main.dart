import 'package:coolapp/views/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/services/auth_service.dart';
import 'package:coolapp/views/pages/videos/not_logged_in.dart';
import 'package:media_kit/media_kit.dart';

// color pallette
/*Name	Hex	RGB	Use Case
Olive Green	#A7C683	(167, 198, 131)	Primary highlight (you're using it)
Sage	#C3D7B5	(195, 215, 181)	Alternate to Olive Green
Soft Mint	#D9E1C7	(217, 225, 199)	Softer alternate or background
Deep Forest	#0F3028	(15, 48, 40)	Background or card container
Khaki Gray	#9CA88E	(156, 168, 142)	Text or neutral divider color
Pale Fern	#BFD8B8	(191, 216, 184)	Even lighter alternating block
Faded Moss	#CBDDC4	(203, 221, 196)	Use sparingly as soft alt fill
*/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await _initializeAuthState();

  runApp(const MyApp());
}

Future<void> _initializeAuthState() async {
  try {
    final authService = AuthService();
    globals.isLoggedIn = await authService.isLoggedIn();
    print('App initialized with isLoggedIn: ${globals.isLoggedIn}');
  } catch (e) {
    print('Error initializing auth state: $e');
    globals.isLoggedIn = false;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/widgetTree',
      routes: {
        '/widgetTree': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          int initialIndex = 2;
          if (args != null && args is int) {
            initialIndex = args;
          }
          return WidgetTree(initialIndex: initialIndex);
        },
        '/notLoggedIn': (context) => NotLoggedIn(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      ),
    );
  }
}
