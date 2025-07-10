import 'package:coolapp/views/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeAuthState();

  runApp(MyApp());
}

//global debugging
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      ),
      home: WidgetTree(),
    );
  }
}
