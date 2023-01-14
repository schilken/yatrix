// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

enum ServerState {
  notStarted,
  starting,
  listening,
  connected,
  error,
}

class PeerServerState {
  String serverPeerId;
  ServerState serverState;
  String message;

  PeerServerState({
    required this.serverPeerId,
    required this.serverState,
    required this.message,
  });

  PeerServerState copyWith({
    String? serverPeerId,
    ServerState? serverState,
    String? message,
  }) {
    return PeerServerState(
      serverPeerId: serverPeerId ?? this.serverPeerId,
      serverState: serverState ?? this.serverState,
      message: message ?? this.message,
    );
  }
}

class PeerServerNotifier extends Notifier<PeerServerState> {
  late PreferencesRepository _preferencesRepository;

  @override
  PeerServerState build() {
    _preferencesRepository = ref.read(preferencesRepositoryProvider);
    return PeerServerState(
      serverState: ServerState.notStarted,
      serverPeerId: '141414',
      message: '',
    );
  }

  void start() async {
    state = state.copyWith(
        serverState: ServerState.starting,
        message: 'Server is starting with ID ${state.serverPeerId}');
    print('PeerServerNotifier.start → ${state.serverPeerId}');
    await Future<void>.delayed(Duration(milliseconds: 1000));
    state = state.copyWith(
        serverState: ServerState.listening,
        message: 'Server is listening with ${state.serverPeerId}');
    await Future<void>.delayed(Duration(milliseconds: 5000));
    state = state.copyWith(
        serverState: ServerState.connected,
        message: 'Server is connected to client');
  }

  void stop() {
    state = state.copyWith(
      serverState: ServerState.notStarted,
      message: '',
    );
  }
}

final peerServerNotifier =
    NotifierProvider<PeerServerNotifier, PeerServerState>(
        PeerServerNotifier.new);
