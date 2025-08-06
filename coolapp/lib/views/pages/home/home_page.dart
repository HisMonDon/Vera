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
  String _displayName = ''; // stores name without comma prefix
  bool _isLoading = true; // handles initial loading state

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await _loadAuthData();
    await _loadUserName();
    await _loadPastVideos(); // Add this to load past videos
    setState(() => _isLoading = false);
  }
  //**_________________________________________ */

  Future<void> _loadAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      globals.userId = prefs.getString('userId') ?? '';
      globals.idToken = prefs.getString('auth_token') ?? '';
    });
  }

  // Add this method to load past videos
  Future<void> _loadPastVideos() async {
    try {
      final recentVideos = await _authService.getPastVideos() ?? [];
      setState(() {
        globals.pastVideos = recentVideos;
      });
    } catch (e) {
      print("error loading past videos: $e");
    }
  }

  Future<void> _loadUserName() async {
    try {
      final savedName = await _authService.getSavedUserName() ?? '';

      if (savedName.isNotEmpty) {
        // handle existing comma prefix
        if (savedName[0] == ",") {
          setState(() {
            _displayName = savedName.substring(2);
            print("all good! removed comma prefix");
          });
        } else {
          setState(() {
            _displayName = savedName;
            print("no comma prefix found");
          });
        }
        return;
      }

      final uid = globals.userId;
      final idToken = globals.idToken;
      if (uid.isNotEmpty && idToken.isNotEmpty) {
        final name = await _authService.getUserNameFromFirestore(uid, idToken);
        if (name != null) {
          setState(() {
            // store raw name without comma
            _displayName = name.startsWith(", ") ? name.substring(2) : name;
          });
          await _authService.saveUserName(_displayName); // save without comma
        }
      }
    } catch (e) {
      print("error loading username: $e");
    }
  }

  Future openDialog() => showDialog(
    context: context,
    builder: (dialogContext) {
      _nameController.text = _displayName; // show raw name without comma
      return AlertDialog(
        title: Text('please enter your name'),
        content: TextField(
          controller: _nameController,
          autofocus: true,
          decoration: InputDecoration(hintText: 'enter your name'),
        ),
        actions: [
          TextButton(
            child: Text('SUBMIT'),
            onPressed: () async {
              final newName = _nameController.text.trim();
              setState(() {
                _displayName = newName; // store raw name
                print("saved forever!!");
              });
              // save raw name without comma
              await _authService.saveUserName(_displayName);
              if (newName.isNotEmpty) {
                final uid = globals.userId;
                final idToken = globals.idToken;
                if (uid.isNotEmpty && idToken.isNotEmpty) {
                  await _authService.saveUserNameToFirestore(
                    uid,
                    _displayName, // save raw name
                    idToken,
                  );
                }
              }
              if (mounted && Navigator.of(dialogContext).canPop()) {
                Navigator.of(dialogContext).pop();
              } else {
                print("error?? the popup has been closed");
              }
            },
          ),
        ],
      );
    },
  );

  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // add comma prefix only for display
    String displayName = _displayName.isNotEmpty ? ", " + _displayName : "";

    /* if (globals.userName != '') {
      if (globals.userName[0] == ",") {
        globals.userName = globals.userName;
        print("all good!");
      } else {
        globals.userName = ", " + globals.userName;
        print("added comma");
      }
    } else {
      print("userName is null.");
    }*/
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: WidgetMask(
                        blendMode: BlendMode.srcATop,
                        childSaveLayer: true,
                        mask: Image(
                          image: AssetImage('images/text_background.jpg'),
                          fit: BoxFit.cover,
                        ),
                        child: AutoSizeText(
                          globals.welcomeText + displayName, // add comma here
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 100,
                            color: const Color.fromARGB(255, 255, 255, 255),
                            decoration: TextDecoration.none,
                          ),
                          maxLines: 1,
                        ),
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

                SizedBox(height: 1),

                WidgetMask(
                  blendMode: BlendMode.srcATop,
                  childSaveLayer: true,
                  mask: Image(
                    image: AssetImage('images/text_background.jpg'),
                    fit: BoxFit.cover,
                  ),
                  child: AutoSizeText(
                    globals.motivationalMessage,
                    style: GoogleFonts.mPlus1(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      decoration: TextDecoration.none,
                    ),
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //FIRST
                    Column(
                      children: [
                        Text(
                          'Recent Videos Watched',
                          style: GoogleFonts.mPlus1(
                            fontSize:
                                ((MediaQuery.of(context).size.width) / 2 - 40) /
                                20,
                            color: const Color.fromARGB(255, 167, 198, 131),
                          ),
                        ),
                        SizedBox(
                          height: 300,
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Container(
                                width:
                                    (MediaQuery.of(context).size.width) / 2 -
                                    40,
                                height: 300,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 15, 48, 40),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: globals.pastVideos
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                          final index = entry.key;
                                          final video = entry.value;

                                          final backgroundColor =
                                              (index % 2 == 0)
                                              ? const Color.fromARGB(
                                                  255,
                                                  30,
                                                  60,
                                                  50,
                                                )
                                              : const Color.fromARGB(
                                                  255,
                                                  60,
                                                  90,
                                                  70,
                                                ); // color 2

                                          return Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: backgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),

                                            width:
                                                (MediaQuery.of(
                                                      context,
                                                    ).size.width) /
                                                    2 -
                                                70,
                                            height: 50,
                                            child: Text(
                                              video,
                                              style: GoogleFonts.montserrat(
                                                fontSize: 20,
                                                color: const Color.fromARGB(
                                                  255,
                                                  217,
                                                  225,
                                                  207,
                                                ),
                                              ),
                                            ),
                                          );
                                        })
                                        .toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        Text(
                          'Second box',
                          style: GoogleFonts.mPlus1(
                            fontSize:
                                ((MediaQuery.of(context).size.width) / 2 - 40) /
                                20,
                            color: const Color.fromARGB(255, 167, 198, 131),
                          ),
                        ),
                        SizedBox(
                          height: 300,
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Container(
                                width:
                                    (MediaQuery.of(context).size.width) / 2 -
                                    40,
                                height: 300,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 15, 48, 40),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: globals.pastVideos
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                          final index = entry.key;
                                          final video = entry.value;

                                          final backgroundColor =
                                              (index % 2 != 0)
                                              ? const Color.fromARGB(
                                                  255,
                                                  30,
                                                  60,
                                                  50,
                                                )
                                              : const Color.fromARGB(
                                                  255,
                                                  60,
                                                  90,
                                                  70,
                                                ); // color 2

                                          return Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: backgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),

                                            width:
                                                (MediaQuery.of(
                                                      context,
                                                    ).size.width) /
                                                    2 -
                                                70,
                                            height: 50,
                                            child: Text(
                                              video,
                                              style: GoogleFonts.montserrat(
                                                fontSize: 20,
                                                color: const Color.fromARGB(
                                                  255,
                                                  217,
                                                  225,
                                                  207,
                                                ),
                                              ),
                                            ),
                                          );
                                        })
                                        .toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
