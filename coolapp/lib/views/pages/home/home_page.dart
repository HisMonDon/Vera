import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:widget_mask/widget_mask.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String welcomeText = 'Hello!';
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              WidgetMask(
                mask: Image(
                  image: AssetImage('text_background.jpg'),
                  fit: BoxFit.cover,
                ),
                child: Text(welcomeText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
