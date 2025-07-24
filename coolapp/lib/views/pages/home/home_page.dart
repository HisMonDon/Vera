import 'package:flutter/material.dart';
import 'package:widget_mask/widget_mask.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/globals.dart' as globals;

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future openDialog() => showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('Please enter your name'),
      content: TextField(
        autofocus: true,
        decoration: InputDecoration(hintText: 'Enter your name'),
        onChanged: (value) {
          globals.userName = ", " + value;
        },
      ),
      actions: [
        TextButton(
          child: Text('SUBMIT'),
          onPressed: () {
            if (globals.userName == ', ') {
              globals.userName = '';
            }
            Navigator.of(dialogContext).pop();
          },
        ),
      ],
    ),
  );

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 120,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    WidgetMask(
                      blendMode: BlendMode.srcATop,
                      childSaveLayer: true,
                      mask: Image(
                        image: AssetImage('images/text_background.jpg'),
                        fit: BoxFit.cover,
                      ),
                      child: AutoSizeText(
                        globals.welcomeText,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 100,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          decoration: TextDecoration.none,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            openDialog();
                          },
                          child: Icon(Icons.edit_rounded),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            iconSize: 20,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
