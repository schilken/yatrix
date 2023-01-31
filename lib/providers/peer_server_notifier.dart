// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

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
  String clientDetails;

  PeerServerState({
    required this.localPeerId,
    required this.serverState,
    required this.message,
    required this.clientDetails,
  });

  PeerServerState copyWith({
    String? localPeerId,
    ServerState? serverState,
    String? message,
    String? clientDetails,
  }) {
    return PeerServerState(
      localPeerId: localPeerId ?? this.localPeerId,
      serverState: serverState ?? this.serverState,
      message: message ?? this.message,
      clientDetails: clientDetails ?? this.clientDetails,
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

  String formatTextForServerId(String serverId) {
    return 'Here is your ServerId for YaTriX: '
        'Copy the whole message unchanged to your clipboard -> $serverId\n'
        'Open the game at https://schilken.de/yatrix, select "Two-Player-Mode" and tap on "Connect"';
  }

  @override
  PeerServerState build() {
    _peerService = ref.read(peerServiceProvider);
    return PeerServerState(
      serverState: ServerState.notStarted,
      localPeerId: '?',
      message: '',
      clientDetails: '',
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
        text: formatTextForServerId(_peerService.localPeerId),
      ),
    );
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

  void shareServerId(Rect rect) {
    Share.share(
      formatTextForServerId(_peerService.localPeerId),
      subject: 'YaTriX',
      sharePositionOrigin: rect,
    );
  }

  void setClientDetails(String text) {
    state = state.copyWith(
      clientDetails: text,
      message: '',
    );
  }
}

final peerServerNotifier =
    NotifierProvider<PeerServerNotifier, PeerServerState>(
  PeerServerNotifier.new,
);
