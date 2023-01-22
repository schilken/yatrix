// ignore_for_file: avoid_print
import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:peerdart/peerdart.dart';

import '../helpers/generate_unique_id.dart';

class PeerService {
  late String _peerId;
  Peer? _peer;
  late DataConnection conn;
  StreamController<String>? _streamController;
  bool isConnected = false;

  String get localPeerId => _peerId;

  Future<void> initPeer(String localPeerId) async {
    _peer = Peer(id: _peerId, options: PeerOptions(debug: LogLevel.All));
    if (_peer == null) {
      throw Exception('creation failed');
    }
  }


  Stream<String> startServer() {
    initStreamController();
    _peer!.on<DataConnection>('connection').listen((event) {
      conn = event;
//      print('server got an connection: $event');
      _streamController?.add('connection opened');

      conn.on<dynamic>('data').listen((dynamic data) {
//        print('server received data: $data');
        _streamController?.add(data.toString());
      });

      conn.on<dynamic>('close').listen((dynamic _) {
//        print('server received close');
        _streamController?.add('connection closed');
        isConnected = false;
        Future<void>.delayed(
          const Duration(milliseconds: 100),
          _streamController?.close,
        );
      });
      isConnected = true;
    });
    return _streamController!.stream;
  }

  void disposePeer() {
    print('disposePeer');
    _peer?.dispose();
    _streamController?.close();
    _streamController = null;
  }

  void initStreamController() {
//    print('initStreamController');
    _streamController?.close();
    _streamController ??= StreamController<String>();
  }

  Stream<String> connectToServer(String id) {
    initStreamController();
    final connection =
        _peer!.connect(id, options: PeerConnectOption(reliable: true));
    conn = connection;

    conn.on<dynamic>('open').listen((dynamic event) {
      isConnected = true;
      _streamController?.add('connection opened');

      conn.on<dynamic>('data').listen((dynamic data) {
        _streamController?.add(data.toString());
      });

      connection.on<dynamic>('close').listen((dynamic _) {
        _streamController?.add('connection closed');
        isConnected = false;
        Future<void>.delayed(
          const Duration(milliseconds: 100),
          _streamController?.close,
        );
      });
    });

    return _streamController!.stream;
  }

  void sendMessage(String message) {
    if (isConnected) {
      conn.send(message);
    }
  }
}

final peerServiceProvider = Provider<PeerService>(
  (ref) => PeerService(),
  name: 'PeerServiceProvider',
);
