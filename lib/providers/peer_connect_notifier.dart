// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

enum ConnectState {
  notConnected,
  connecting,
  connected,
  error,
}

class PeerConnectState {
  String remotePeerId;
  ConnectState connectState;
  String message;

  PeerConnectState({
    required this.remotePeerId,
    required this.connectState,
    required this.message,
  });

  PeerConnectState copyWith({
    String? remotePeerId,
    ConnectState? connectState,
    String? message,
  }) {
    return PeerConnectState(
      remotePeerId: remotePeerId ?? this.remotePeerId,
      connectState: connectState ?? this.connectState,
      message: message ?? this.message,
    );
  }
}

class PeerConnectNotifier extends Notifier<PeerConnectState> {
  late PreferencesRepository _preferencesRepository;

  String _remotePeerId = '';

  @override
  PeerConnectState build() {
    _preferencesRepository = ref.read(preferencesRepositoryProvider);
    return PeerConnectState(
      connectState: ConnectState.notConnected,
      remotePeerId: _remotePeerId,
      message: '',
    );
  }

  Future<void> connect({required String remotePeerId}) async {
    _remotePeerId = remotePeerId;
    state = state.copyWith(
        connectState: ConnectState.connecting,
        message: 'connecting to $remotePeerId');
    print('PeerConnectNotifier.connect → $remotePeerId');
    await Future<void>.delayed(Duration(milliseconds: 1000));
    state = state.copyWith(
        connectState: ConnectState.connected,
        message: 'connected with $remotePeerId');
  }

  void disConnect() {
    state = state.copyWith(
      connectState: ConnectState.notConnected,
      message: '',
    );
  }
}

final peerConnectNotifier =
    NotifierProvider<PeerConnectNotifier, PeerConnectState>(
        PeerConnectNotifier.new);
