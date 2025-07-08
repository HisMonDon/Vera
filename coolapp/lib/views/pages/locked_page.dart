//page that displays whenever someone isn't subscribed
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class LockedPage extends StatelessWidget {
  const LockedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 15, 48, 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoSizeText(
            'Content Locked! Please get premium to access these videos.',
            style: TextStyle(
              fontSize: 50,
              color: const Color.fromARGB(255, 255, 255, 255),
              decoration: TextDecoration.none,
            ), //starts at 50, will shrink to fit
            maxLines: 1,
          ),
          Text(
            'All revenue from subscriptions go towards charity!',
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 20),
          Icon(Icons.lock, size: 150),
        ],
      ),
    );
  }
}
