// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

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

class PeerNotifier extends AsyncNotifier<PeerState> {
  late PreferencesRepository _preferencesRepository;

  bool _activatePeerServer = false;
  String _remotePeerId = '';

  @override
  FutureOr<PeerState> build() {
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
    try {
      state = const AsyncValue.loading();
      await Future<void>.delayed(
          Duration(milliseconds: 500)); // this future can fail
      state = AsyncValue.data(PeerState(
        isConnected: false,
        activatePeerServer: _activatePeerServer,
        localPeerId: '141414',
        remotePeerId: _remotePeerId,
        message: '',
      ));
    } catch (e, s) {
      state = AsyncValue.error(
        e,
        s,
      );
    }
    //   state = state.copyWith(activatePeerServer: activate);
  }

  Future<void> setLocalPeerId(String id) async {
    try {
      state = const AsyncValue.loading();
      await Future<void>.delayed(
          Duration(milliseconds: 500)); // this future can fail
      state = AsyncValue.data(PeerState(
        isConnected: false,
        activatePeerServer: _activatePeerServer,
        localPeerId: '141414',
        remotePeerId: _remotePeerId,
        message: '',
      ));
    } catch (e, s) {
      state = AsyncValue.error(
        e,
        s,
      );
    }
  }

  Future<void> connect({required String remotePeerId}) async {
    _remotePeerId = remotePeerId;
    state = const AsyncLoading();
    // state = state.copyWith(
    //     remotePeerId: remotePeerId,
    //     isConnected: true,
    //     message: 'connected with $_remotePeerId');
    print('connect → $remotePeerId');
    try {
      state = const AsyncValue.loading();
      await Future<void>.delayed(
          Duration(milliseconds: 500)); // this future can fail
      state = AsyncValue.data(PeerState(
        isConnected: false,
        activatePeerServer: _activatePeerServer,
        localPeerId: '141414',
        remotePeerId: _remotePeerId,
        message: '',
      ));
    } catch (e, s) {
      state = AsyncValue.error(
        e,
        s,
      );
    }
  }
}

final peerNotifier =
    AsyncNotifierProvider<PeerNotifier, PeerState>(PeerNotifier.new);
