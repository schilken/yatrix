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

  @override
  PeerState build() {
    _preferencesRepository = ref.read(preferencesRepositoryProvider);
    _peerService = ref.read(peerServiceProvider);
    return PeerState(
      isEnabled: false,
      isServer: false,
    );
  }

  void setIsEnabled(bool isEnabled) {
    state = state.copyWith(isEnabled: isEnabled);
  }

  void setIsServer(bool isServer) {
    state = state.copyWith(isServer: isServer);
  }


}

final peerNotifier =
    NotifierProvider<PeerNotifier, PeerState>(PeerNotifier.new);
