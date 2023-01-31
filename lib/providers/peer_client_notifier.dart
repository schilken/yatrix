// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/regex_helper.dart';
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
  String serverDetails;

  PeerClientState({
    required this.remotePeerId,
    required this.clientState,
    required this.message,
    required this.serverDetails,
  });

  PeerClientState copyWith({
    String? remotePeerId,
    ClientState? clientState,
    String? message,
    String? serverDetails,
  }) {
    return PeerClientState(
      remotePeerId: remotePeerId ?? this.remotePeerId,
      clientState: clientState ?? this.clientState,
      message: message ?? this.message,
      serverDetails: serverDetails ?? this.serverDetails,
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
      serverDetails: '',
    );
  }

  Future<void> connect() async {
    String? remotePeerId;
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      remotePeerId = RegexHelper.extractIdFromMessage(data.text!);
    }
    if (remotePeerId == null) {
      state = state.copyWith(
          clientState: ClientState.error,
        message:
            'No ServerId found on the clipboard. '
            'It should be seven characters long following -> like so "-> y8Wp3By"\n'
            'I found this: "$remotePeerId"',
      );
      return;
    }
    if (remotePeerId == _peerService.localPeerId) {
      state = state.copyWith(
        clientState: ClientState.error,
        message:
            "You can't connect to yourself. "
            "Put the ServerId of your peer's server on the clipboard.",
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
          state.copyWith(
        clientState: ClientState.connected,
        message: message,
      );
    });
  }

  void addOnDoneCallback() {
    _streamSubscription?.onDone(() {
      print('disConnect onDone');
      disConnect();
    });
  }

  void disConnect() {
//    print('disConnect');
    _peerService.disposePeer();
    state = state.copyWith(
      clientState: ClientState.notConnected,
      message: '@done!',
    );
  }

  void setServerDetails(String text) {
    state = state.copyWith(
      serverDetails: text,
      message: '',
    );
  }

}

final peerClientNotifier =
    NotifierProvider<PeerClientNotifier, PeerClientState>(
  PeerClientNotifier.new,
);
