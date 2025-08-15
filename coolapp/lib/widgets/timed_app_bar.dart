import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimedAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final List<Widget>? additionalActions;

  const TimedAppBar({
    this.title = "Vera", //optional change
    this.backgroundColor = const Color.fromARGB(255, 15, 48, 40),
    this.additionalActions,
    Key? key,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight),
       super(key: key);

  @override
  final Size preferredSize;

  @override
  State<TimedAppBar> createState() => _TimedAppBarState();
}

class _TimedAppBarState extends State<TimedAppBar> {
  TimeOfDay _currentTime = TimeOfDay.now();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = TimeOfDay.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(widget.title, style: GoogleFonts.mPlus1()),
      backgroundColor: widget.backgroundColor,
      actions: [
        ...(widget.additionalActions ?? []),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Center(
            child: Text(
              "${_currentTime.hour}:${_currentTime.minute.toString().padLeft(2, '0')}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
