// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

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

  @override
  String toString() =>
      'PeerClientState(remotePeerId: $remotePeerId, '
      'clientState: $clientState, message: $message)';
}

class PeerClientNotifier extends Notifier<PeerClientState> {
  late PreferencesRepository _preferencesRepository;
  late PeerService _peerService;
  late Stream<String> _receivedStrings;
  StreamSubscription? _streamSubscription;

  @override
  PeerClientState build() {
    _preferencesRepository = ref.read(preferencesRepositoryProvider);
    _peerService = ref.read(peerServiceProvider);
    return PeerClientState(
      clientState: ClientState.notConnected,
      remotePeerId: _preferencesRepository.remotePeerId,
      message: '',
    );
  }

  Future<void> connect({required String remotePeerId}) async {
    if (remotePeerId.length < 5) {
      state = state.copyWith(
          clientState: ClientState.error,
        message: 'ID must be a 5 digit number',
      );
      return;
    }
    _preferencesRepository.setRemotePeerId(remotePeerId);
    try {
      _receivedStrings = _peerService.connectToServer(remotePeerId);
    } on Exception catch (e, s) {
      print('exception: $e, $s');
    }
    state = state.copyWith(
      clientState: ClientState.connecting,
      message: 'connecting to $remotePeerId',
    );
    print('PeerConnectNotifier.connect → $remotePeerId');
    addReceivedDataListener();
    addOnDoneCallback();
  }

  void addReceivedDataListener() {
    _streamSubscription = _receivedStrings.listen((message) {
      print('PeerClientNotifier.listen: $message');
      state =
          state.copyWith(clientState: ClientState.connected, message: message);
    });
  }

  void addOnDoneCallback() {
    _streamSubscription?.onDone(() {
      print('disConnect onDone');
      disConnect();
    });
  }

  void disConnect() {
    _peerService.disposePeer();
    state = state.copyWith(
      clientState: ClientState.notConnected,
      message: '@done!',
    );
  }
}

final peerClientNotifier =
    NotifierProvider<PeerClientNotifier, PeerClientState>(
  PeerClientNotifier.new,
);
