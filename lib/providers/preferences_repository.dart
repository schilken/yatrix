import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers.dart';

class PreferencesRepository {
  final SharedPreferences _prefs;

  PreferencesRepository(this._prefs);

  Future<void> setMusicVolume(double volume) async {
    await _prefs.setDouble('musicVolume', volume);
  }

  double get musicVolume => _prefs.getDouble('musicVolume') ?? 0.25;

  Future<void> setSoundEffectsVolume(double volume) async {
    await _prefs.setDouble('soundEffectsVolume', volume);
  }

  double get soundEffectsVolume =>
      _prefs.getDouble('soundEffectsVolume') ?? 0.25;


  Future<void> setUserName(String name) async {
    await _prefs.setString('userName', name);
  }

  String get userName {
    return _prefs.getString('userName') ?? 'User 1';
  }

  List<String> get scores {
    final scores = _prefs.getStringList('scores') ?? ['User 0 - 0 Points'];
    return scores;
  }

  Future<void> addScore(String folder) async {
    final scores = _prefs.getStringList('scores') ?? [];
    scores.add(folder);
    await _prefs.setStringList('scores', scores);
  }

}

final preferencesRepositoryProvider = Provider<PreferencesRepository>(
  (ref) => PreferencesRepository(
    ref.read(sharedPreferencesProvider),
  ),
);
