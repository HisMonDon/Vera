import 'package:beamer/beamer.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({
    super.key,
    required this.lessonTitle,
    required this.covered,
    required this.prerequisites,
    required this.onStartLesson,
    this.topicTitle = '',
  });

  final String lessonTitle;
  final String topicTitle;
  final String covered;
  final String prerequisites;
  final VoidCallback onStartLesson;

  static const _darkGreen = Color(0xFF0F3028);
  static const _midGreen = Color(0xFF08634F);
  static const _accentGreen = Color(0xFFA7C683);
  static const _lightText = Color(0xFFCCF7E3);

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final pageBackground =
        isLight ? const Color(0xFFC4DDCF) : const Color(0xFF04221A);
    final cardBackground = isLight
        ? Colors.white.withValues(alpha: 0.78)
        : const Color(0xFF0A3027);
    final primaryText = isLight ? _darkGreen : Colors.white;
    final secondaryText =
        isLight ? const Color(0xFF365B50) : const Color(0xFFC7DED6);

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: TimedAppBar(),
      bottomNavigationBar: _buildBottomNavBar(context),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 48),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(children: [
                    TextButton.icon(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back_rounded, size: 20),
                      label: const Text('Back to lessons'),
                      style: TextButton.styleFrom(
                        alignment: Alignment.centerLeft,
                        foregroundColor: primaryText,
                        padding: EdgeInsets.fromLTRB(8, 5, 10, 5),
                      ),
                    ),
                    Spacer()
                  ]),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: _midGreen,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final compact = constraints.maxWidth < 620;
                        final icon = Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            color: _accentGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.play_lesson_rounded,
                            color: _darkGreen,
                            size: 38,
                          ),
                        );
                        final heading = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              topicTitle.isEmpty
                                  ? 'LESSON OVERVIEW'
                                  : topicTitle.toUpperCase(),
                              style: GoogleFonts.montserrat(
                                color: _accentGreen,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              lessonTitle,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: compact ? 28 : 36,
                                height: 1.15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        );

                        if (compact) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              icon,
                              const SizedBox(height: 24),
                              heading,
                            ],
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            icon,
                            const SizedBox(width: 24),
                            Expanded(child: heading),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  _SummaryCard(
                    icon: Icons.lightbulb_outline_rounded,
                    title: "What you'll learn",
                    text: covered,
                    backgroundColor: cardBackground,
                    titleColor: primaryText,
                    textColor: secondaryText,
                  ),
                  const SizedBox(height: 16),
                  _SummaryCard(
                    icon: Icons.fact_check_outlined,
                    title: 'Before you begin',
                    text: prerequisites,
                    backgroundColor: cardBackground,
                    titleColor: primaryText,
                    textColor: secondaryText,
                  ),
                  const SizedBox(height: 28),
                  Align(
                    alignment: Alignment.center,
                    child: FilledButton.icon(
                      onPressed: onStartLesson,
                      icon: const Icon(Icons.play_arrow_rounded, size: 26),
                      label: const Text('Start lesson'),
                      style: FilledButton.styleFrom(
                        backgroundColor: _accentGreen,
                        foregroundColor: _darkGreen,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 14,
                        ),
                        textStyle: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static const _navPageKeys = ['about', 'profile', 'home', 'videos', 'settings'];

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color.fromARGB(255, 15, 48, 40),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      currentIndex: _navPageKeys.indexOf('videos'),
      onTap: (index) {
        final key = _navPageKeys[index];
        if (key == 'videos') return;
        final path = key == 'home' ? '/' : '/$key';
        context.beamToNamed(path);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.question_mark),
          label: 'Get Started',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.ondemand_video_rounded),
          label: 'Videos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.text,
    required this.backgroundColor,
    required this.titleColor,
    required this.textColor,
  });

  final IconData icon;
  final String title;
  final String text;
  final Color backgroundColor;
  final Color titleColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: SummaryPage._accentGreen.withValues(alpha: 0.32),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: SummaryPage._accentGreen.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: SummaryPage._accentGreen, size: 24),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    color: titleColor,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  text,
                  style: GoogleFonts.roboto(
                    color: textColor,
                    fontSize: 16,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
