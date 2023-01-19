// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

class DialogState {
  String data;
  bool isCommitted;

  DialogState({
    required this.data,
    required this.isCommitted,
  });

  DialogState copyWith({
    String? data,
    bool? isCommitted,
  }) {
    return DialogState(
      data: data ?? this.data,
      isCommitted: isCommitted ?? this.isCommitted,
    );
  }
}

class DialogNotifier extends Notifier<DialogState> {
  late PreferencesRepository _preferencesRepository;

  @override
  DialogState build() {
    _preferencesRepository = ref.read(preferencesRepositoryProvider);
    return DialogState(
      data: '',
      isCommitted: false,
    );
  }

  void setIsCommitted() {
    print('setIsCommitted');
    state = state.copyWith(isCommitted: true);
  }
}

final dialogNotifier =
    NotifierProvider<DialogNotifier, DialogState>(DialogNotifier.new);
