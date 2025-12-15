import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0x1EA095)),
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "Roboto",
    appBarTheme: AppBarThemeData(
      backgroundColor: Colors.white,
      elevation: 4,
      shadowColor: Colors.black,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: "Roboto Bold",
        fontSize: 22,
        color: Colors.black,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      elevation: 4,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      unselectedIconTheme: IconThemeData(
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 1,
            offset: Offset(1, 1),
          ),
        ],
      ),
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      showUnselectedLabels: false,
    ),
  );
}
