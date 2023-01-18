// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/painting.dart';
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

  @override
  String toString() => 'PeerServerState(serverPeerId: $serverPeerId, '
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
      serverPeerId: _peerService.localPeerId.toString(),
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
      message: 'Server is listening on ID ${state.serverPeerId}',
    );
    addReceivedDataListener();
    addOnDoneCallback();
  }

  void addReceivedDataListener() {
    _streamSubscription = _receivedStrings.listen((message) {
      print('PeerServerNotifier.listen: $message');
      state =
          state.copyWith(serverState: ServerState.connected, message: message);
      // BotToast.showText(
      //   text: message,
      //   duration: const Duration(seconds: 3),
      //   align: const Alignment(0, 0.3),
      // );
    });
  }

  void addOnDoneCallback() {
    _streamSubscription?.onDone(() {
      stop();
      // BotToast.showText(
      //   text: 'Two-Player Mode finished',
      //   duration: const Duration(seconds: 3),
      //   align: const Alignment(0, 0.3),
      // );
    });
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
