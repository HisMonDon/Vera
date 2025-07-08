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
          style: TextStyle(fontSize: 50),
        ),
        Text('All revenue from subscriptions go towards charity!'),
        Icon(Icons.lock),
      ],
    );
  }
}
