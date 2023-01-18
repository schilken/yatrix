import 'package:flutter/material.dart';

class CustomPalette {
  static const Color almostBlack = Color(0xff040B13);
  static const Color red100 = Color(0xfffce5e8);
  static const Color red200 = Color(0xfff7b2ba);
  static const Color red300 = Color(0xfff27f8d);
  static const Color red400 = Color(0xffec4b5f);
  static const Color red500 = Color(0xffE82139);
  static const Color red600 = Color(0xffb41326);
  static const Color red700 = Color(0xff800d1b);
  static const Color red800 = Color(0xff4d0810);
  static const Color red900 = Color(0xff1a0305);
}

class CustomTheme {
  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,
      primarySwatch: MaterialColor(
        CustomPalette.red500.value,
        const {
          100: CustomPalette.red100,
          200: CustomPalette.red200,
          300: CustomPalette.red300,
          400: CustomPalette.red400,
          500: CustomPalette.red500,
          600: CustomPalette.red600,
          700: CustomPalette.red700,
          800: CustomPalette.red800,
          900: CustomPalette.red900,
        },
      ),
      accentColor: CustomPalette.red500,
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
        fontSize: 32,
        color: Colors.white60,
      ),
      headline5: TextStyle(
        fontSize: 24,
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
        backgroundColor: CustomPalette.red500,
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
