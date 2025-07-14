library globals;

import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

bool isPremium = false;
bool isLoggedIn = false;
bool isAdmin = false;
int selectedIndex = 2;
bool isNavbarShowing = false;
PersistentTabController globalTabController = PersistentTabController(
  initialIndex: 2, //solves duplicate bug problem
);
