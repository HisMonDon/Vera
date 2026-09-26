import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum VeraAnimation {
  idle,
  runningRight,
  runningLeft,
  waving,
  jumping,
  failed,
  waiting,
  working,
  review,
}

class _AnimationSpec {
  final int row;
  final int frames;

  const _AnimationSpec(this.row, this.frames);
}

const _veraAnimations = <VeraAnimation, _AnimationSpec>{
  VeraAnimation.idle: _AnimationSpec(0, 6),
  VeraAnimation.runningRight: _AnimationSpec(1, 8),
  VeraAnimation.runningLeft: _AnimationSpec(2, 8),
  VeraAnimation.waving: _AnimationSpec(3, 4),
  VeraAnimation.jumping: _AnimationSpec(4, 5),
  VeraAnimation.failed: _AnimationSpec(5, 8),
  VeraAnimation.waiting: _AnimationSpec(6, 6),
  VeraAnimation.working: _AnimationSpec(7, 6),
  VeraAnimation.review: _AnimationSpec(8, 6),
};

class VeraPet extends StatefulWidget {
  const VeraPet({
    super.key,
    this.animation = VeraAnimation.idle,
    this.width = 160,
    this.framesPerSecond = 8,
  });

  final VeraAnimation animation;
  final double width;
  final int framesPerSecond;

  @override
  State<VeraPet> createState() => _VeraPetState();
}

class _VeraPetState extends State<VeraPet> {
  ui.Image? _spritesheet;
  Timer? _timer;
  int _frame = 0;

  @override
  void initState() {
    super.initState();
    _loadSpritesheet();
    _startAnimation();
  }

  @override
  void didUpdateWidget(covariant VeraPet oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.animation != widget.animation ||
        oldWidget.framesPerSecond != widget.framesPerSecond) {
      _frame = 0;
      _startAnimation();
    }
  }

  Future<void> _loadSpritesheet() async {
    final data = await rootBundle.load(
      'pet/spritesheet.webp',
    );

    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
    );

    final frameInfo = await codec.getNextFrame();
    codec.dispose();

    if (!mounted) {
      frameInfo.image.dispose();
      return;
    }

    setState(() {
      _spritesheet = frameInfo.image;
    });
  }

  void _startAnimation() {
    _timer?.cancel();

    final fps = widget.framesPerSecond.clamp(1, 60);
    final interval = Duration(milliseconds: 1000 ~/ fps);

    _timer = Timer.periodic(interval, (_) {
      if (!mounted) return;

      final spec = _veraAnimations[widget.animation]!;

      setState(() {
        _frame = (_frame + 1) % spec.frames;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _spritesheet?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = _spritesheet;

    if (image == null) {
      return SizedBox(
        width: widget.width,
        height: widget.width * 208 / 192,
      );
    }

    final spec = _veraAnimations[widget.animation]!;
    final height = widget.width * 208 / 192;

    return Semantics(
      label: 'Vera animated pet',
      image: true,
      child: SizedBox(
        width: widget.width,
        height: height,
        child: CustomPaint(
          painter: _VeraSpritePainter(
            image: image,
            row: spec.row,
            frame: _frame,
          ),
        ),
      ),
    );
  }
}

class _VeraSpritePainter extends CustomPainter {
  const _VeraSpritePainter({
    required this.image,
    required this.row,
    required this.frame,
  });

  final ui.Image image;
  final int row;
  final int frame;

  static const double cellWidth = 192;
  static const double cellHeight = 208;

  @override
  void paint(Canvas canvas, Size size) {
    final source = Rect.fromLTWH(
      frame * cellWidth,
      row * cellHeight,
      cellWidth,
      cellHeight,
    );

    final destination = Offset.zero & size;

    canvas.drawImageRect(
      image,
      source,
      destination,
      Paint()..filterQuality = FilterQuality.high,
    );
  }

  @override
  bool shouldRepaint(covariant _VeraSpritePainter oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.row != row ||
        oldDelegate.frame != frame;
  }
}
