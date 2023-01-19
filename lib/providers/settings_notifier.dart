// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

class SettingsState {
  double musicVolume;
  double soundEffectsVolume;
  bool showFps;
  bool activatePeerServer;
  String localPeerId;
  String remotePeerId;

  SettingsState({
    required this.musicVolume,
    required this.soundEffectsVolume,
    required this.showFps,
    required this.activatePeerServer,
    required this.localPeerId,
    required this.remotePeerId,
  });

  SettingsState copyWith({
    double? musicVolume,
    double? soundEffectsVolume,
    bool? showFps,
    bool? activatePeerServer,
    String? localPeerId,
    String? remotePeerId,
  }) {
    return SettingsState(
      musicVolume: musicVolume ?? this.musicVolume,
      soundEffectsVolume: soundEffectsVolume ?? this.soundEffectsVolume,
      showFps: showFps ?? this.showFps,
      activatePeerServer: activatePeerServer ?? this.activatePeerServer,
      localPeerId: localPeerId ?? this.localPeerId,
      remotePeerId: remotePeerId ?? this.remotePeerId,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  late PreferencesRepository _preferencesRepository;

  bool _activatePeerServer = false;
  String _remotePeerId = '';

  @override
  SettingsState build() {
    _preferencesRepository = ref.read(preferencesRepositoryProvider);
    return SettingsState(
      showFps: _preferencesRepository.showFps,
      musicVolume: _preferencesRepository.musicVolume,
      soundEffectsVolume: _preferencesRepository.soundEffectsVolume,
      activatePeerServer: _activatePeerServer,
      localPeerId: '141414',
      remotePeerId: _remotePeerId,
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

  Future<void> setActivatePeerServer(bool activate) async {
    _activatePeerServer = activate;
    state = state.copyWith(activatePeerServer: activate);
  }

  Future<void> setLocalPeerId(String id) async {
    state = state.copyWith(localPeerId: id);
  }

  void connect({required String remotePeerId}) {
    _remotePeerId = remotePeerId;
    state = state.copyWith(remotePeerId: remotePeerId);
    print('connect → $remotePeerId');
  }

}

final settingsNotifier =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
