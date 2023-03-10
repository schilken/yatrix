import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers.dart';

class PreferencesRepository {
  final SharedPreferences _prefs;

  PreferencesRepository(this._prefs);

  String get appVersion => _prefs.getString('appVersion') ?? '?';


  Future<void> setMusicVolume(double volume) async {
    await _prefs.setDouble('musicVolume', volume);
  }

  double get musicVolume => _prefs.getDouble('musicVolume') ?? 0.0;

  Future<void> setSoundEffectsVolume(double volume) async {
    await _prefs.setDouble('soundEffectsVolume', volume);
  }

  double get soundEffectsVolume =>
      _prefs.getDouble('soundEffectsVolume') ?? 0.0;


  Future<void> setUserName(String name) async {
    await _prefs.setString('userName', name);
  }

  String get userName {
    return _prefs.getString('userName') ?? 'User 1';
  }

  Future<void> setShowFps(bool show) async {
    await _prefs.setBool('showFps', show);
  }

  bool get showFps {
    return _prefs.getBool('showFps') ?? true;
  }

  List<String> get scores {
    final scores = _prefs.getStringList('scores') ?? [];
    return scores;
  }

  Future<void> addScore(String folder) async {
    final scores = _prefs.getStringList('scores') ?? [];
    scores.add(folder);
    await _prefs.setStringList('scores', scores);
  }

  String get remotePeerId => _prefs.getString('remotePeerId') ?? '55555';

  Future<void> setRemotePeerId(String remotePeerId) async {
    await _prefs.setString('remotePeerId', remotePeerId);
  }

  String get localPeerId => _prefs.getString('localPeerId') ?? '';

  Future<void> setlocalPeerId(String localPeerId) async {
    await _prefs.setString('localPeerId', localPeerId);
  }

  int get velocity => _prefs.getInt('velocity') ?? 100;

  Future<void> setvelocity(int velocity) async {
    await _prefs.setInt('velocity', velocity);
  }

}

final preferencesRepositoryProvider = Provider<PreferencesRepository>(
  (ref) => PreferencesRepository(
    ref.read(sharedPreferencesProvider),
  ),
);
