// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

class PeerState {
  bool activatePeerServer;
  String localPeerId;
  String remotePeerId;
  bool isConnected;
  String message;

  PeerState({
    required this.activatePeerServer,
    required this.localPeerId,
    required this.remotePeerId,
    required this.isConnected,
    required this.message,
  });

  PeerState copyWith({
    bool? activatePeerServer,
    String? localPeerId,
    String? remotePeerId,
    bool? isConnected,
    String? message,
  }) {
    return PeerState(
      activatePeerServer: activatePeerServer ?? this.activatePeerServer,
      localPeerId: localPeerId ?? this.localPeerId,
      remotePeerId: remotePeerId ?? this.remotePeerId,
      isConnected: isConnected ?? this.isConnected,
      message: message ?? this.message,
    );
  }
}

class PeerNotifier extends Notifier<PeerState> {
  late PreferencesRepository _preferencesRepository;

  bool _activatePeerServer = false;
  String _remotePeerId = '';

  @override
  PeerState build() {
    _preferencesRepository = ref.read(preferencesRepositoryProvider);
    return PeerState(
      isConnected: false,
      activatePeerServer: _activatePeerServer,
      localPeerId: '141414',
      remotePeerId: _remotePeerId,
      message: '',
    );
  }

  Future<void> setActivatePeerServer(bool activate) async {
    _activatePeerServer = activate;
    state = state.copyWith(activatePeerServer: activate);
  }

  Future<void> setLocalPeerId(String id) async {
    state = state.copyWith(localPeerId: id);
  }

  void connect({required String remotePeerId}) {
    _remotePeerId = remotePeerId;
    state = state.copyWith(
        remotePeerId: remotePeerId,
        isConnected: true,
        message: 'connected with $_remotePeerId');
    print('connect → $remotePeerId');
  }
}

final peerNotifier =
    NotifierProvider<PeerNotifier, PeerState>(PeerNotifier.new);
