// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

class SettingsState {
  double musicVolume;
  double soundEffectsVolume;
  bool showFps;

  SettingsState({
    required this.musicVolume,
    required this.soundEffectsVolume,
    required this.showFps,
  });

  SettingsState copyWith({
    double? musicVolume,
    double? soundEffectsVolume,
    bool? showFps,
  }) {
    return SettingsState(
      musicVolume: musicVolume ?? this.musicVolume,
      soundEffectsVolume: soundEffectsVolume ?? this.soundEffectsVolume,
      showFps: showFps ?? this.showFps,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  late PreferencesRepository _preferencesRepository;

  @override
  SettingsState build() {
    _preferencesRepository = ref.read(preferencesRepositoryProvider);
    return SettingsState(
      showFps: _preferencesRepository.showFps,
      musicVolume: _preferencesRepository.musicVolume,
      soundEffectsVolume: _preferencesRepository.soundEffectsVolume,
    );
  }

  Future<void> setMusicVolume(double volume) async {
    await _preferencesRepository.setMusicVolume(volume);
    state = state.copyWith(musicVolume: volume);
  }

  Future<void> setSoundEffectsVolume(double volume) async {
    await _preferencesRepository.setSoundEffectsVolume(volume);
    state = state.copyWith(soundEffectsVolume: volume);
  }

  Future<void> setShowFps(bool show) async {
    await _preferencesRepository.setShowFps(show);
    state = state.copyWith(showFps: show);
  }

}

final settingsNotifier =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
