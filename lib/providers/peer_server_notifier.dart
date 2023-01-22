// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'providers.dart';

enum ServerState {
  notStarted,
  starting,
  listening,
  connected,
  error,
}

class PeerServerState {
  String localPeerId;
  ServerState serverState;
  String message;

  PeerServerState({
    required this.localPeerId,
    required this.serverState,
    required this.message,
  });

  PeerServerState copyWith({
    String? localPeerId,
    ServerState? serverState,
    String? message,
  }) {
    return PeerServerState(
      localPeerId: localPeerId ?? this.localPeerId,
      serverState: serverState ?? this.serverState,
      message: message ?? this.message,
    );
  }

  @override
  String toString() => 'PeerServerState(serverPeerId: $localPeerId, '
      'serverState: $serverState, message: $message)';
}

class PeerServerNotifier extends Notifier<PeerServerState> {
  late PeerService _peerService;
  late Stream<String> _receivedStrings;
  StreamSubscription? _streamSubscription;

  @override
  PeerServerState build() {
    _peerService = ref.read(peerServiceProvider);
    return PeerServerState(
      serverState: ServerState.notStarted,
      localPeerId: '?',
      message: '',
    );
  }

  void start() {
    try {
      _receivedStrings = _peerService.startServer();
    } on Exception catch (e, s) {
      print('exception: $e, $s');
    }
    state = state.copyWith(
        serverState: ServerState.listening,
      localPeerId: _peerService.localPeerId,
      message: 'Server is listening on ID:',
    );
    Clipboard.setData(ClipboardData(
        text: 'Your ServerId for YaTriX: ${_peerService.localPeerId}'));
    addReceivedDataListener();
    addOnDoneCallback();
  }

  void addReceivedDataListener() {
    _streamSubscription = _receivedStrings.listen((message) {
      print('PeerServerNotifier.listen: $message');
      state =
          state.copyWith(
        serverState: ServerState.connected,
        message: message,
      );
    });
  }

  void addOnDoneCallback() {
    _streamSubscription?.onDone(stop);
  }

  void stop() {
    print('stop server');
    _peerService.disposePeer();
    state = state.copyWith(
      serverState: ServerState.notStarted,
      message: '@done!',
    );
  }
}

final peerServerNotifier =
    NotifierProvider<PeerServerNotifier, PeerServerState>(
  PeerServerNotifier.new,
);
