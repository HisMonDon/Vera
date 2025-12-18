import 'package:flutter/material.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:url_launcher/url_launcher.dart';

class AboutThisAppPage extends StatelessWidget {
  AboutThisAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TimedAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              _buildTitleHeader(context),
              const SizedBox(height: 48),
              _buildChenyuLuSection(context),
              const SizedBox(height: 48),
              _buildWhatIsVeraSection(context),
              const SizedBox(height: 48),
              _buildBottomCopyright(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleHeader(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          'Vera',
          style: GoogleFonts.mPlus1(
            fontSize: 48.0,
            fontWeight: FontWeight.bold,
            color: globals.isLight
                ? const Color.fromARGB(255, 15, 48, 40)
                : Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: globals.isLight
                ? const Color.fromARGB(255, 15, 48, 40)
                : const Color.fromARGB(255, 167, 198, 131),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Web',
            style: GoogleFonts.montserrat(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: globals.isLight
                  ? Colors.white
                  : const Color.fromARGB(255, 15, 48, 40),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChenyuLuSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 18, 59, 49),
            Color.fromARGB(214, 10, 97, 80),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(73, 0, 0, 0),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage('images/chenyuluPFP.png'),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Chenyu Lu",
                  style: GoogleFonts.mPlus1(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Founder, CEO, Lead Developer & Physics Instructor",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 195, 215, 181),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "• St. Robert Physics Club Executive Trainer\n• 3rd Place in the Canadian Young Physics Tournament\n• 5 On AP Physics 1, AP Chemistry, and AP Computer Science A",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: const Color.fromARGB(
                      255,
                      246,
                      248,
                      247,
                    ).withOpacity(0.9),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    launchUrl(Uri.parse("https://www.chenyulu.dev"));
                  },
                  icon: const Icon(Icons.web),
                  label: const Text("Visit My Website"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 167, 198, 131),
                    foregroundColor: const Color.fromARGB(255, 15, 48, 40),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatIsVeraSection(BuildContext context) {
    return Column(
      children: [
        Text(
          "What is Vera?",
          style: GoogleFonts.mPlus1(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: globals.isLight
                ? const Color.fromARGB(255, 7, 77, 53)
                : const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Vera is a video platform made with Flutter and Dart dedicated to making learning physics accessible and easy for everyone. From high school IB curricula to advanced AP topics, our student-led video lessons break down physics concepts into easy-to-understand modules, with many tips and tricks to help you score well in your school physics courses. Join us for free to unlock your potential and master physics!",
          textAlign: TextAlign.center,
          style: GoogleFonts.mPlus1(
            fontSize: 20,
            color: globals.isLight
                ? const Color.fromARGB(221, 0, 0, 0)
                : const Color.fromARGB(221, 255, 255, 255),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 32),
        _buildSampleImagesRow(),
      ],
    );
  }

  Widget _buildSampleImagesRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 18, 59, 49),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
            ),
            child: Center(child: Text('Image ${index + 1}')),
          ),
        );
      }),
    );
  }

  Widget _buildBottomCopyright() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "2025 Chenyu Studios",
          style: TextStyle(
            fontSize: 10,
            color: globals.isLight
                ? const Color.fromARGB(255, 0, 0, 0)
                : const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        const SizedBox(width: 3),
        Icon(
          Icons.copyright_sharp,
          size: 15,
          color: globals.isLight
              ? const Color.fromARGB(255, 0, 0, 0)
              : const Color.fromARGB(255, 255, 255, 255),
        ),
      ],
    );
  }

  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
