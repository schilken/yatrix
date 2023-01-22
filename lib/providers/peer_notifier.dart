// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/generate_unique_id.dart';
import 'providers.dart';

class PeerState {
  bool isEnabled;
  bool isServer;
  bool isConnected;
  String message;

  PeerState({
    required this.isEnabled,
    required this.isServer,
    required this.isConnected,
    required this.message,
  });

  PeerState copyWith({
    bool? isEnabled,
    bool? isServer,
    bool? isConnected,
    String? message,
  }) {
    return PeerState(
      isEnabled: isEnabled ?? this.isEnabled,
      isServer: isServer ?? this.isServer,
      isConnected: isConnected ?? this.isConnected,
      message: message ?? this.message,
    );
  }

  @override
  String toString() => 'PeerState(isEnabled: $isEnabled, isServer: $isServer, '
      'message: $message)';
}

class PeerNotifier extends Notifier<PeerState> {
  late PreferencesRepository _preferencesRepository;
  late PeerService _peerService;
  late PeerClientState _peerClientState;
  late PeerServerState _peerServerState;

  bool _isEnabled = false;
  bool _isServer = false;
  bool _isConnected = false;


  @override
  PeerState build() {
    _preferencesRepository = ref.read(preferencesRepositoryProvider);
    _peerService = ref.read(peerServiceProvider);
    _peerClientState = ref.watch(peerClientNotifier);
    _peerServerState = ref.watch(peerServerNotifier);
    _isEnabled = !(_peerClientState.clientState == ClientState.notConnected &&
        _peerServerState.serverState == ServerState.notStarted);
    _isConnected = _peerClientState.clientState == ClientState.connected &&
        _peerServerState.serverState == ServerState.connected;
    print('PeerNotifier.build $_peerClientState $_peerServerState');
    final message = _peerClientState.clientState == ClientState.connected
        ? _peerClientState.message
        : _peerServerState.message; 
    return PeerState(
      isEnabled: _isEnabled,
      isServer: _isServer,
      isConnected: _isConnected,
      message: message,
    );
  }

  void setIsEnabled(bool isEnabled) {
    _isEnabled = isEnabled;
    state = state.copyWith(isEnabled: isEnabled);
    var localPeerId = _preferencesRepository.localPeerId;
    if (localPeerId.isEmpty) {
      localPeerId = generateUniqueId();
      _preferencesRepository.setlocalPeerId(localPeerId);
    }
    if (isEnabled) {
      _peerService.initPeer(localPeerId);
    } else {
      _peerService.disposePeer();
    }
  }

  void setIsServer(bool isServer) {
    _isServer = isServer;
    state = state.copyWith(isServer: isServer);
  }

}

final peerNotifier =
    NotifierProvider<PeerNotifier, PeerState>(PeerNotifier.new);
