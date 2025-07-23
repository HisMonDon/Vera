import 'package:flutter/material.dart';
import 'package:coolapp/globals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;
import 'dart:async';

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
              MaskedImage(
                image: AssetImage('images/text_background.jpg'),
                child: Text(
                  welcomeText,
                  style: GoogleFonts.mPlus1(
                    fontSize: 30,
                    color: Colors.transparent,
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

class MaskedImage extends StatelessWidget {
  final ImageProvider image;
  final Widget child;
  const MaskedImage({required this.image, required this.child});
  @override
  Widget build(BuildContext context) => FutureBuilder<ui.Image>(
    future: loadImage(),
    builder: (context, snap) => snap.hasData
        ? ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) => ImageShader(
              snap.data!,
              TileMode.clamp,
              TileMode.clamp,
              Matrix4.identity().storage,
            ),
            child: child,
          )
        : Center(child: CircularProgressIndicator()),
  );
  Future<ui.Image> loadImage() async {
    final completer = Completer<ui.Image>();
    final stream = image.resolve(ImageConfiguration());
    stream.addListener(
      ImageStreamListener((info, _) => completer.complete(info.image)),
    );
    return completer.future;
  }
}
