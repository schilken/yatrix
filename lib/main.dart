import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helpers/custom_theme.dart';
import 'pages/game_page.dart';
import 'providers/providers.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final pubspec = Pubspec.parse(await rootBundle.loadString('pubspec.yaml'));
  final version = pubspec.version;
  print('version from pubspec.yaml: $version');
  sharedPreferences.setString('appVersion', version.toString());

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          darkTheme: CustomTheme.darkTheme,
          themeMode: ThemeMode.dark,
          home: SafeArea(
            child: Builder(
              builder: (context) {
                return GamePage();
              },
            ),
          ),
          builder: BotToastInit(),
          navigatorObservers: [BotToastNavigatorObserver()],
        );
        },
      ),
    ),
  );
}
