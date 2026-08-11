import 'package:coolapp/views/pages/videos/summary_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('summary page displays lesson input and starts the lesson', (
    WidgetTester tester,
  ) async {
    var lessonStarted = false;

    await tester.pumpWidget(
      MaterialApp(
        home: SummaryPage(
          lessonTitle: 'Motion in one dimension',
          topicTitle: 'Kinematics',
          covered: 'Displacement, velocity, and acceleration.',
          prerequisites: 'Basic algebra and graph reading.',
          onStartLesson: () => lessonStarted = true,
        ),
      ),
    );

    expect(find.text('Motion in one dimension'), findsOneWidget);
    expect(
      find.text('Displacement, velocity, and acceleration.'),
      findsOneWidget,
    );
    expect(find.text('Basic algebra and graph reading.'), findsOneWidget);

    await tester.ensureVisible(find.text('Start lesson'));
    await tester.tap(find.text('Start lesson'));
    await tester.pump();
    expect(lessonStarted, isTrue);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
