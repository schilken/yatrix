// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

enum ClientState {
  notConnected,
  connecting,
  connected,
  error,
}

class PeerClientState {
  String remotePeerId;
  ClientState clientState;
  String message;

  PeerClientState({
    required this.remotePeerId,
    required this.clientState,
    required this.message,
  });

  PeerClientState copyWith({
    String? remotePeerId,
    ClientState? clientState,
    String? message,
  }) {
    return PeerClientState(
      remotePeerId: remotePeerId ?? this.remotePeerId,
      clientState: clientState ?? this.clientState,
      message: message ?? this.message,
    );
  }
}

class PeerClientNotifier extends Notifier<PeerClientState> {
  late PreferencesRepository _preferencesRepository;
  late PeerService _peerService;
  late Stream<String> _receivedStrings;
  String _remotePeerId = '';

  @override
  PeerClientState build() {
    _preferencesRepository = ref.read(preferencesRepositoryProvider);
    _peerService = ref.read(peerServiceProvider);
    return PeerClientState(
      clientState: ClientState.notConnected,
      remotePeerId: _remotePeerId,
      message: '',
    );
  }

  Future<void> connect({required String remotePeerId}) async {
    if (remotePeerId.length < 5) {
      state = state.copyWith(
          clientState: ClientState.error,
          message: 'ID must be a 5 digit number');
      return;
    }
    _remotePeerId = remotePeerId;
    try {
      await _peerService.initPeer();
      _receivedStrings = _peerService.connectToServer(remotePeerId);
    } on Exception catch (e, s) {
      print('exception: $e, $s');
    }
    state = state.copyWith(
        clientState: ClientState.connecting,
      message: 'connecting to $remotePeerId',
    );
    print('PeerConnectNotifier.connect → $remotePeerId');
    // await Future<void>.delayed(Duration(milliseconds: 1000));
    // state = state.copyWith(
    //     clientState: ClientState.connected,
    //     message: 'connected with $remotePeerId');

    _receivedStrings.listen((message) {
      print('PeerClientNotifier.listen: $message');
      state =
          state.copyWith(clientState: ClientState.connected, message: message);
    });    

  }

  void disConnect() {
    _peerService.disconnect();
    state = state.copyWith(
      clientState: ClientState.notConnected,
      message: '',
    );
  }
}

final peerClientNotifier =
    NotifierProvider<PeerClientNotifier, PeerClientState>(
        PeerClientNotifier.new);
