import 'package:flutter/material.dart';
import 'package:widget_mask/widget_mask.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authService = AuthService();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await _loadAuthData();
    await _loadUserName();
  }

  Future<void> _loadAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      globals.userId = prefs.getString('userId') ?? '';
      globals.idToken = prefs.getString('auth_token') ?? '';
    });
  }

  Future<void> _loadUserName() async {
    try {
      final savedName = await _authService.getSavedUserName();
      if (savedName != null && savedName.isNotEmpty) {
        setState(() {
          globals.userName = savedName;
        });
        return;
      }

      final uid = globals.userId;
      final idToken = globals.idToken;
      if (uid.isNotEmpty && idToken.isNotEmpty) {
        final name = await _authService.getUserNameFromFirestore(uid, idToken);
        if (name != null) {
          setState(() {
            globals.userName = ', ' + name;
          });
          await _authService.saveUserName(name);
        }
      }
    } catch (e) {}
  }

  Future openDialog() => showDialog(
    context: context,
    builder: (dialogContext) {
      _nameController.text = globals.userName;
      return AlertDialog(
        title: Text('Please enter your name'),
        content: TextField(
          controller: _nameController,
          autofocus: true,
          decoration: InputDecoration(hintText: 'Enter your name'),
        ),
        actions: [
          TextButton(
            child: Text('SUBMIT'),
            onPressed: () async {
              final newName = _nameController.text.trim();
              setState(() {
                globals.userName = ", " + newName;
                print("saved forever!!");
              });
              await _authService.saveUserName(globals.userName);
              if (newName.isNotEmpty) {
                final uid = globals.userId;
                final idToken = globals.idToken;
                if (uid.isNotEmpty && idToken.isNotEmpty) {
                  await _authService.saveUserNameToFirestore(
                    uid,
                    newName,
                    idToken,
                  );
                }
              }
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      );
    },
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
                          onPressed: openDialog,
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
