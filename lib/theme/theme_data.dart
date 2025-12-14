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
  );
}
