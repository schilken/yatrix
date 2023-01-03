// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

class HighScoreState {
  String currentScore;
  List<String> scores;
  String userName;

  HighScoreState({
    required this.currentScore,
    required this.scores,
    required this.userName,
  });

  HighScoreState copyWith({
    String? currentScore,
    List<String>? scores,
    String? userName,
  }) {
    return HighScoreState(
      currentScore: currentScore ?? this.currentScore,
      scores: scores ?? this.scores,
      userName: userName ?? this.userName,
    );
  }
}

class HighScoreNotifier extends Notifier<HighScoreState> {
  late PreferencesRepository _preferencesRepository;

  @override
  HighScoreState build() {
    _preferencesRepository = ref.read(preferencesRepositoryProvider);
    return HighScoreState(
      currentScore: '',
      scores: _preferencesRepository.scores,
      userName: _preferencesRepository.userName,
    );
  }

  void setCurrentScore(String newValue) {
    print('HighScoreNotifier newValue: $newValue');
    state = state.copyWith(currentScore: newValue);
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

final highScoreNotifier =
    NotifierProvider<HighScoreNotifier, HighScoreState>(HighScoreNotifier.new);
