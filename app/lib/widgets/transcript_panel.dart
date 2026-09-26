import 'package:chewie/chewie.dart' show Subtitle, Subtitles;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

/// A collapsible, seekable transcript shown under the player.
///
/// Captions help a student follow along live; a transcript helps them re-read a
/// sentence they did not catch without scrubbing the timeline hunting for it.
/// Testers reported the narration being hard to follow, which is a
/// "let me read that again" problem more than a "show me the words now" one.
///
/// Collapsed by default so it never pushes the video off screen.
class TranscriptPanel extends StatefulWidget {
  const TranscriptPanel({
    super.key,
    required this.captions,
    required this.controller,
    this.isLight = false,
  });

  /// Null when the lesson has no caption file; the panel then renders nothing.
  final Subtitles? captions;
  final VideoPlayerController controller;
  final bool isLight;

  @override
  State<TranscriptPanel> createState() => _TranscriptPanelState();
}

class _TranscriptPanelState extends State<TranscriptPanel> {
  static const Color _darkGreen = Color(0xFF0F3028);
  static const Color _accentGreen = Color(0xFFA7C683);
  static const Color _lightText = Color(0xFFCCF7E3);

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final List<Subtitle?>? lines = widget.captions?.subtitle;
    // No transcript for this lesson yet — show nothing rather than an empty box.
    if (lines == null || lines.isEmpty) return const SizedBox.shrink();

    final Color primaryText = widget.isLight ? _darkGreen : Colors.white;
    final Color bodyText =
        widget.isLight ? const Color(0xFF365B50) : _lightText;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 920),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isLight
                ? Colors.white.withValues(alpha: 0.7)
                : const Color(0xFF0A3027),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _accentGreen.withValues(alpha: 0.3)),
          ),
          child: Theme(
            // The default ExpansionTile divider fights the card border.
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: false,
              onExpansionChanged: (bool value) =>
                  setState(() => _expanded = value),
              tilePadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: Icon(Icons.subject_rounded, color: _accentGreen),
              title: Text(
                'Transcript',
                style: GoogleFonts.montserrat(
                  color: primaryText,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                _expanded
                    ? 'Tap any line to jump there'
                    : '${lines.length} lines',
                style: GoogleFonts.roboto(color: bodyText, fontSize: 13),
              ),
              children: <Widget>[
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 320),
                  child: _TranscriptList(
                    lines: lines.whereType<Subtitle>().toList(growable: false),
                    controller: widget.controller,
                    bodyText: bodyText,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TranscriptList extends StatelessWidget {
  const _TranscriptList({
    required this.lines,
    required this.controller,
    required this.bodyText,
  });

  final List<Subtitle> lines;
  final VideoPlayerController controller;
  final Color bodyText;

  @override
  Widget build(BuildContext context) {
    // Rebuilds as playback advances so the current line stays highlighted,
    // without the parent page rebuilding on every frame.
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (BuildContext context, VideoPlayerValue value, Widget? _) {
        final Duration position = value.position;
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: lines.length,
          itemBuilder: (BuildContext context, int index) {
            final Subtitle line = lines[index];
            final bool isCurrent =
                position >= line.start && position <= line.end;
            return InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => controller.seekTo(line.start),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? const Color(0xFFA7C683).withValues(alpha: 0.22)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 52,
                      child: Text(
                        _stamp(line.start),
                        style: GoogleFonts.robotoMono(
                          color: bodyText.withValues(alpha: 0.75),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        line.text is String
                            ? line.text as String
                            : line.text.toString(),
                        style: GoogleFonts.roboto(
                          color: bodyText,
                          fontSize: 15,
                          height: 1.45,
                          fontWeight:
                              isCurrent ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static String _stamp(Duration d) {
    final int minutes = d.inMinutes;
    final int seconds = d.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
