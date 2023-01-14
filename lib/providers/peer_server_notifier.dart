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
  late PeerService _peerService;
  late Stream<String> _receivedStrings;

  @override
  PeerServerState build() {
    _preferencesRepository = ref.read(preferencesRepositoryProvider);
    _peerService = ref.read(peerServiceProvider);
    return PeerServerState(
      serverState: ServerState.notStarted,
      serverPeerId: '141414',
      message: '',
    );
  }

  void start() async {
    try {
      _receivedStrings = _peerService.startServer(state.serverPeerId);
    } on Exception catch (e, s) {
      print('exception: $e, $s');
    }

    state = state.copyWith(
        serverState: ServerState.starting,
        message: 'Server is starting with ID ${state.serverPeerId}');
    _receivedStrings.listen((message) {
      print('PeerServerNotifier.listen: $message');
      state =
          state.copyWith(serverState: ServerState.connected, message: message);
    });    
  }

  void stop() {
    _peerService.stopServer();
    state = state.copyWith(
      serverState: ServerState.notStarted,
      message: '',
    );
  }
}

final peerServerNotifier =
    NotifierProvider<PeerServerNotifier, PeerServerState>(
        PeerServerNotifier.new);
