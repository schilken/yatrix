import 'package:flutter/material.dart';

class CustomPalette {
  static const Color almostBlack = Color(0xff040B13);
}

class CustomTheme {
  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,

    ),
    scaffoldBackgroundColor: CustomPalette.almostBlack,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      color: CustomPalette.almostBlack,
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 48,
        color: Color(0xFFC8FFF5),
        fontWeight: FontWeight.w800,
      ),
      headline4: TextStyle(
        fontSize: 28,
        color: Colors.white60,
      ),
      headline5: TextStyle(
        fontSize: 20,
        color: Colors.white60,
      ),
      headline6: TextStyle(
        fontSize: 16,
        color: Colors.white60,
      ),
      bodyText1: TextStyle(
        fontSize: 14,
        color: Colors.white60,
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: Colors.white70,
      inactiveTrackColor: Colors.grey.shade800,
      thumbColor: Colors.white54,
      valueIndicatorColor: Colors.grey.shade800,
      inactiveTickMarkColor: Colors.transparent,
      activeTickMarkColor: Colors.transparent,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: CustomPalette.almostBlack,
      ),
    ),
    // outlinedButtonTheme: OutlinedButtonThemeData(
    //   style: ButtonStyle(
    //     foregroundColor: Colors.white60,
    //     side: BorderSide(color: Colors.white60),
    //   ),
    // ),
  );
}
