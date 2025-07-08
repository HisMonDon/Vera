//page that displays whenever someone isn't subscribed
import 'package:flutter/material.dart';

class LockedPage extends StatelessWidget {
  const LockedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Content Locked! Please get premium to access these videos.',
          style: TextStyle(
            fontSize: 50,
            color: const Color.fromARGB(255, 255, 255, 255),
            decoration: TextDecoration.none,
          ),
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
    );
  }
}
