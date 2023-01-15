import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peerdart/peerdart.dart';

class PeerService {
  Peer? _peer;
  late DataConnection conn;
  StreamController<String>? _streamController;
  bool connected = false;

  Stream<String> startServer(String id) {
    _peer = Peer(
      id: id,
    ); // options: PeerOptions(debug: LogLevel.All));
    if (_peer == null) {
      throw Exception('creation failed');
    }
    _streamController ??= StreamController<String>();

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
        connected = false;
      });
      connected = true;
    });
    return _streamController!.stream;
  }

  void stopServer() {
    _peer?.dispose();
    _streamController?.close();
  }

  Future<void> initPeer() async {
    _streamController?.close();
    _streamController ??= StreamController<String>();
    _streamController?.add('peer initializing...');
    _peer = Peer(options: PeerOptions(debug: LogLevel.All));
    if (_peer == null) {
      throw Exception('creation failed');
    }
    await Future<void>.delayed(Duration(milliseconds: 300));
  }

  Stream<String> connectToServer(String id) {
    final connection =
        _peer!.connect(id, options: PeerConnectOption(reliable: true));
    conn = connection;

    conn.on<dynamic>('open').listen((dynamic event) {
      connected = true;
      _streamController?.add('connection opened');
//      print('conn.open: $event');

      conn.on<dynamic>('data').listen((dynamic data) {
//        print('client received data: $data');
        _streamController?.add(data.toString());
    });

      connection.on<dynamic>('close').listen((dynamic _) {
//        print('client received close');
        _streamController?.add('connection closed');
        connected = false;
      });
    });

    return _streamController!.stream;
  }

  void disconnect() {
    _peer?.dispose();
    _streamController?.close();
  }

  void sendMessage(String message) {
    conn.send(message);
  }

}

final peerServiceProvider = Provider<PeerService>(
  (ref) => PeerService(),
  name: 'PeerServiceProvider',
);
