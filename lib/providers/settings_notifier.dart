// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

class SettingsState {
  List<String> scores;
  String userName;

  SettingsState({
    required this.scores,
    required this.userName,
  });

  SettingsState copyWith({
    List<String>? scores,
    String? userName,
  }) {
    return SettingsState(
      scores: scores ?? this.scores,
      userName: userName ?? this.userName,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  late PreferencesRepository _preferencesRepository;

  @override
  SettingsState build() {
    _preferencesRepository = ref.read(preferencesRepositoryProvider);
    return SettingsState(
      scores: _preferencesRepository.scores,
      userName: _preferencesRepository.userName,
    );
  }

  Future<void> setuserName(String name) async {
    await _preferencesRepository.setUserName(name);
    state = state.copyWith(userName: name);
  }

  Future<void> addScore(String folder) async {
    await _preferencesRepository.addScore(folder);
    state = state.copyWith(scores: _preferencesRepository.scores);
  }
}

final settingsNotifier =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
