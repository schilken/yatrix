import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tetris/tetris_game.dart';
import 'pages/game_page.dart';
import 'providers/providers.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Builder(
            builder: (context) {
              return GamePage(
                game: TetrisGame(),
              );
            },
          ),
        ),
        ),
    ),
  );
}
