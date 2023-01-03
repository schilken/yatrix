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
    state = state.copyWith(currentScore: newValue);
  }

  Future<void> setuserName(String name) async {
    await _preferencesRepository.setUserName(name);
    state = state.copyWith(userName: name);
  }

  Future<void> addScore(String score) async {
    await _preferencesRepository.addScore(score);
    state = state.copyWith(scores: _preferencesRepository.scores);
  }

  Future<void> addCurrentScore() async {
    await addScore(state.currentScore);
    state = state.copyWith(
      currentScore: '',
      scores: _preferencesRepository.scores,
    );
  }
}

final highScoreNotifier =
    NotifierProvider<HighScoreNotifier, HighScoreState>(HighScoreNotifier.new);
