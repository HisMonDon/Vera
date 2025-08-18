import 'dart:typed_data';
import 'package:coolapp/views/pages/videos/not_logged_in.dart';
import 'package:coolapp/views/pages/videos/video_player.dart';
import 'package:coolapp/widgets/timed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:widget_mask/widget_mask.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coolapp/globals.dart' as globals;
import 'package:coolapp/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:video_thumbnail/video_thumbnail.dart'; perchance use this for later purposes if current extractvideoimage still doesnt support ios or android in future?
import 'package:media_kit/media_kit.dart';
import 'package:extract_video_frame/extract_video_frame.dart';
import 'dart:ui' as ui;
//import 'package:media_kit_video/media_kit_video.dart';
//import 'dart:io';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// FOR TOMMORWO MAKE A COVER POPUP TO BLOCK EVERYTHIGN IF NOT LOGGED IN (MENTION FREE)
class HomePage extends StatefulWidget {
  HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
  final String videoUrl =
      globals.videoOfTheDay[globals.videoOfTheDayIndex]['videoLink'] ?? '';
}

class _HomePageState extends State<HomePage> {
  final _authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  String _displayName = ''; // stores name without comma prefix
  bool _isLoading = true; // handles initial loading state
  final player = Player();
  final String videoUrl =
      globals.videoOfTheDay[globals.videoOfTheDayIndex]['videoLink'] ?? '';
  final String featuredTitle =
      globals.videoOfTheDay[globals.videoOfTheDayIndex]['videoTitle'] ?? '';
  final Color thumbnailColor =
      globals.videoOfTheDay[globals.videoOfTheDayIndex]['thumbnailColor']!;
  final String featuredUnit =
      globals.videoOfTheDay[globals.videoOfTheDayIndex]['videoUnit'] ?? '';
  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await _loadAuthData();
    await _loadUserName();
    await _loadPastVideos();
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

  Future<void> getFrame() async {
    final ui.Image frame = await extractVideoFrameAt(
      videoFilePath: videoUrl,
      positionInSeconds: 3.5,
    );
  }

  //Add this method to load past videos
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
  //

  Future<void> _loadUserName() async {
    try {
      final savedName = await _authService.getSavedUserName() ?? '';

      if (savedName.isNotEmpty) {
        globals.userName = savedName;
        setState(() {
          _displayName = savedName;
        });
        return;
      }

      final uid = globals.userId;
      final idToken = globals.idToken;
      if (uid.isNotEmpty && idToken.isNotEmpty) {
        final name = await _authService.getUserNameFromFirestore(uid, idToken);
        if (name != null) {
          globals.userName = name;
          setState(() {
            _displayName = name;
          });
          await _authService.saveUserName(name);
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
        title: Text('Edit Name'),
        content: TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Enter new name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
        ),
        actions: [
          TextButton(
            child: Text('CANCEL'),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            child: Text('SUBMIT'),
            onPressed: () async {
              final newName = _nameController.text.trim();
              setState(() {
                _displayName = newName; // store raw name
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
              print("User Name: " + globals.userName);
              Navigator.of(dialogContext).pop();
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
      appBar: TimedAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: openDialog,
                              child: Icon(Icons.settings),
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
                                    ((MediaQuery.of(context).size.width) / 3 +
                                        100) /
                                    30,
                                color: const Color.fromARGB(255, 167, 198, 131),
                              ),
                            ),
                            SizedBox(height: 10),
                            Stack(
                              children: [
                                SizedBox(
                                  height: 300,
                                  child: Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Container(
                                        width:
                                            (MediaQuery.of(
                                              context,
                                            ).size.width) -
                                            ((MediaQuery.of(
                                                      context,
                                                    ).size.width) /
                                                    4 -
                                                40) -
                                            100, //replace brackets with whatever explore size is
                                        height: 300,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                            255,
                                            15,
                                            48,
                                            40,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
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
                                                          BorderRadius.circular(
                                                            5,
                                                          ),
                                                    ),

                                                    width:
                                                        (MediaQuery.of(
                                                          context,
                                                        ).size.width) -
                                                        ((MediaQuery.of(
                                                                  context,
                                                                ).size.width) /
                                                                4 -
                                                            40) -
                                                        100, //replace brackets with whatever explore size is
                                                    height: 50,
                                                    child: AutoSizeText(
                                                      video,
                                                      style: GoogleFonts.montserrat(
                                                        fontSize: 20,
                                                        color:
                                                            const Color.fromARGB(
                                                              255,
                                                              217,
                                                              225,
                                                              207,
                                                            ),
                                                      ),
                                                      maxLines: 1,
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
                                if (!globals.isLoggedIn)
                                  Container(
                                    width:
                                        (MediaQuery.of(context).size.width) -
                                        ((MediaQuery.of(context).size.width) /
                                                4 -
                                            40) -
                                        100, //replace brackets with whatever explore size is,
                                    height: 300,

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: const Color.fromARGB(
                                        176,
                                        255,
                                        255,
                                        255,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Please log in!',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(width: 20),

                        //SECOND
                        //________________________________
                        Column(
                          children: [
                            Text(
                              'Explore',
                              style: GoogleFonts.mPlus1(
                                fontSize:
                                    ((MediaQuery.of(context).size.width) / 3 +
                                        100) /
                                    30,
                                color: const Color.fromARGB(255, 167, 198, 131),
                              ),
                            ),

                            SizedBox(height: 10),
                            SizedBox(
                              height: 300,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Container(
                                    width:
                                        (MediaQuery.of(context).size.width) /
                                            4 -
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
                                        children: globals.explore.asMap().entries.map((
                                          entry,
                                        ) {
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
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (!globals.isLoggedIn) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          NotLoggedIn(),
                                                    ),
                                                  );
                                                } else {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => globals
                                                          .redirectExplore[index],
                                                    ),
                                                  );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.transparent,
                                                shadowColor: Colors.transparent,
                                              ),
                                              child: AutoSizeText(
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

                                                maxLines: 1,
                                              ),
                                            ),
                                          );
                                        }).toList(),
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
                SizedBox(height: 20),
                //====================================================================//
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Text(
                      'Featured Video of the Day',
                      style: GoogleFonts.mPlus1(
                        fontSize:
                            ((MediaQuery.of(context).size.width) / 3 + 100) /
                            30,
                        color: const Color.fromARGB(255, 167, 198, 131),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 600,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            width: (MediaQuery.of(context).size.width) - 80,
                            height: 600,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 15, 48, 40),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),

                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  foregroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(),
                                ),
                                onPressed: () {
                                  globals.videoLink = videoUrl;
                                  globals.unitTitle = featuredTitle;
                                  globals.topicTitle = featuredUnit;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VideoPlayerScreen(),
                                    ),
                                  );
                                },
                                child: Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    Container(
                                      height: 560,
                                      width:
                                          (MediaQuery.of(context).size.width) -
                                          120,
                                      alignment: Alignment.topCenter,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: thumbnailColor,
                                      ),

                                      child: SizedBox(
                                        height: 560,
                                        width:
                                            (MediaQuery.of(
                                              context,
                                            ).size.width) -
                                            120,
                                        child: Image(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                            'images/featured_video_background.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(height: 60),
                                        Container(
                                          width:
                                              (MediaQuery.of(
                                                context,
                                              ).size.width) -
                                              120,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Color.fromARGB(
                                              255,
                                              15,
                                              48,
                                              40,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 60),
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              featuredUnit +
                                                  ": " +
                                                  featuredTitle,
                                              style: GoogleFonts.bebasNeue(
                                                fontSize: 60,
                                                color: const Color.fromARGB(
                                                  255,
                                                  217,
                                                  225,
                                                  199,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            Icon(
                                              MdiIcons.atom,
                                              color: Color.fromARGB(
                                                255,
                                                217,
                                                225,
                                                199,
                                              ),
                                              size: 70,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.play_circle_fill_rounded,
                                          size: 80,
                                          color: Color.fromARGB(
                                            255,
                                            217,
                                            225,
                                            199,
                                          ),
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
