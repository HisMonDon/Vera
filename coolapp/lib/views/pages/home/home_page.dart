import 'package:flutter/material.dart';
import 'package:widget_mask/widget_mask.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String welcomeText = 'Welcome To Vera';
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              WidgetMask(
                blendMode: BlendMode.srcATop,
                childSaveLayer: true,
                mask: Image(
                  image: AssetImage('images/text_background.jpg'),
                  fit: BoxFit.cover,
                ),
                child: Text(
                  welcomeText,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 100,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
