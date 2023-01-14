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

  String _remotePeerId = '';

  @override
  PeerClientState build() {
    _preferencesRepository = ref.read(preferencesRepositoryProvider);
    return PeerClientState(
      clientState: ClientState.notConnected,
      remotePeerId: _remotePeerId,
      message: '',
    );
  }

  Future<void> connect({required String remotePeerId}) async {
    _remotePeerId = remotePeerId;
    state = state.copyWith(
        clientState: ClientState.connecting,
        message: 'connecting to $remotePeerId');
    print('PeerConnectNotifier.connect → $remotePeerId');
    await Future<void>.delayed(Duration(milliseconds: 1000));
    state = state.copyWith(
        clientState: ClientState.connected,
        message: 'connected with $remotePeerId');
  }

  void disConnect() {
    state = state.copyWith(
      clientState: ClientState.notConnected,
      message: '',
    );
  }
}

final peerClientNotifier =
    NotifierProvider<PeerClientNotifier, PeerClientState>(
        PeerClientNotifier.new);
