// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

class PeerState {
  bool isEnabled;
  bool isServer;

  PeerState({
    required this.isEnabled,
    required this.isServer,
  });

  PeerState copyWith({
    bool? isEnabled,
    bool? isServer,
  }) {
    return PeerState(
      isEnabled: isEnabled ?? this.isEnabled,
      isServer: isServer ?? this.isServer,
    );
  }
}

class PeerNotifier extends Notifier<PeerState> {
  late PreferencesRepository _preferencesRepository;
  late PeerService _peerService;
  late PeerClientState _peerClientState;
  late PeerServerState _peerServerState;

  PeerNotifier() {
    print('PeerNotifier.constructor');
  }

  bool _isEnabled = false;
  bool _isServer = false;


  @override
  PeerState build() {
    _preferencesRepository = ref.read(preferencesRepositoryProvider);
    _peerService = ref.read(peerServiceProvider);
    _peerClientState = ref.watch(peerClientNotifier);
    _peerServerState = ref.watch(peerServerNotifier);
    if (_peerClientState.clientState == ClientState.notConnected &&
        _peerServerState.serverState == ServerState.notStarted) {
      _isEnabled = false;
    }
    print('PeerNotifier.build $_peerClientState → _isEnabled = $_isEnabled');
    return PeerState(
      isEnabled: _isEnabled,
      isServer: _isServer,
    );
  }

  void setIsEnabled(bool isEnabled) {
    _isEnabled = isEnabled;
    state = state.copyWith(isEnabled: isEnabled);
    if (isEnabled) {
      _peerService.initPeer();
    } 
  }

  void setIsServer(bool isServer) {
    _isServer = isServer;
    state = state.copyWith(isServer: isServer);
  }

}

final peerNotifier =
    NotifierProvider<PeerNotifier, PeerState>(PeerNotifier.new);
